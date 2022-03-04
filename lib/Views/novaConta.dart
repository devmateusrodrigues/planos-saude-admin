// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pdcase_ideia_extra/Classes/usuario.dart';
import 'package:pdcase_ideia_extra/Views/home.dart';
import 'package:pdcase_ideia_extra/Views/login.dart';

class NovaConta extends StatefulWidget {
  @override
  _NovaContaState createState() => _NovaContaState();
}

class _NovaContaState extends State<NovaConta> {
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController senhaConfirm = TextEditingController();

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nome',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.limeAccent[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            validator: validaNome,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: nome,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person_add,
                  color: Colors.black,
                ),
                hintText: 'Digite seu nome',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                errorStyle:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'E-mail',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.limeAccent[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            validator: validaEmail,
            controller: email,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                hintText: 'Digite seu e-mail',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                errorStyle:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Senha',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.limeAccent[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            validator: validaSenha,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: senha,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Digite sua senha',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                errorStyle:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirme sua senha',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.limeAccent[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            validator: confirmaSenha,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: senhaConfirm,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Confirme sua senha',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                errorStyle:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildCadastroBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          await validaFormCompleto();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.limeAccent[100],
        child: Text(
          'CRIAR UMA CONTA',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.yellow,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                        Colors.black,
                        Colors.grey,
                      ],
                          stops: [
                        0.0,
                        1.0
                      ],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          tileMode: TileMode.repeated)),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 40.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "pd | ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "case",
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 45,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50.0),
                        _buildNameTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildEmailTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildConfirmPasswordTF(),
                        SizedBox(height: 50.0),
                        _buildCadastroBtn()
                      ],
                    ),
                  ),
                )
              ],
            ),
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
    if (value != senha.text) {
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

  Future validaFormCompleto() async {
    if (validaNome(nome.text) == null &&
        validaEmail(email.text) == null &&
        validaSenha(senha.text) == null &&
        confirmaSenha(senhaConfirm.text) == null) {
      await saveUser();
    } else {
      erroForm(context, "Preencha corretamente o formulário");
    }
  }

  Future saveUser() async {
    var usuario = GetIt.instance<Usuario>();
    bool userExists = false;

    usuario.nome = nome.text;
    usuario.email = email.text;
    usuario.senha = senha.text;

    var users = await usuario.getUsuario();

    for (var user in users) {
      if (user['Email'] == usuario.email &&
          user['Nome'] == usuario.nome &&
          user['Senha'] == usuario.senha) {
        userExists = true;
      }
    }

    if (!userExists) {
      await usuario.saveUsuario(usuario);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      erroForm(context, "Esse usuário já existe");
    }
  }
}
