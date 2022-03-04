// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pdcase_ideia_extra/Classes/usuario.dart';
import 'package:pdcase_ideia_extra/Views/home.dart';

class UsuarioForm extends StatefulWidget {
  @override
  _UsuarioFormState createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nomeUsuario = TextEditingController();
  TextEditingController emailUsuario = TextEditingController();
  TextEditingController senhaUsuario = TextEditingController();
  TextEditingController senhaConfirmUsuario = TextEditingController();
  var usuario = GetIt.instance<Usuario>();

  @override
  void initState() {
    super.initState();

    nomeUsuario.text = usuario.nome;
    emailUsuario.text = usuario.email;
    senhaUsuario.text = usuario.senha;
    senhaConfirmUsuario.text = usuario.senha;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nomeUsuario,
                      decoration: InputDecoration(
                        labelText: "Nome do Usuário",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validaNome),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailUsuario,
                      decoration: InputDecoration(
                        labelText: "E-mail do usuário",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validaEmail),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      controller: senhaUsuario,
                      decoration: InputDecoration(
                        labelText: "Senha do usuário",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validaSenha),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: senhaConfirmUsuario,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirmar senha",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: confirmaSenha),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            if (formKey.currentState.validate()) {
              await update();
            } else {
              erroForm(context, "O formulário não foi validado!");
            }
          },
          tooltip: 'Adicionar Ficha de Paciente',
          child: Icon(
            Icons.send_outlined,
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }

  String validaNome(String value) {
    if (value.length < 3) {
      return "     Digite um nome com 3 letras ou mais";
    } else {
      return null;
    }
  }

  String validaEmail(String value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (emailValid) {
      return null;
    } else {
      return "     O e-mail digitado é inválido.";
    }
  }

  String validaSenha(String value) {
    if (value.length < 4) {
      return "     Senha digitada é inválida";
    } else {
      return null;
    }
  }

  String confirmaSenha(String value) {
    if (value != senhaUsuario.text) {
      return "     Senhas diferentes";
    } else {
      return null;
    }
  }

  Future erroForm(BuildContext context, String textoExibido) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            textoExibido,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future update() async {
    bool userExists = false;

    usuario.nome = nomeUsuario.text;
    usuario.email = emailUsuario.text;
    usuario.senha = senhaUsuario.text;

    var users = await usuario.getUsuario();

    for (var user in users) {
      if (user['Email'] == usuario.email &&
          user['Nome'] == usuario.nome &&
          user['Senha'] == usuario.senha) {
        userExists = true;
      }
    }

    if (!userExists) {
      await usuario.updateUsuario(usuario);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      erroForm(context, "Esse usuário já existe");
    }
  }
}
