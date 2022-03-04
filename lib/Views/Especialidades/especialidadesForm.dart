// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pdcase_ideia_extra/Classes/especialidades.dart';
import 'package:pdcase_ideia_extra/Classes/usuario.dart';
import 'package:pdcase_ideia_extra/Views/home.dart';

class EspecialidadesForm extends StatefulWidget {
  EspecialidadesForm({Key key, this.especialidade}) : super(key: key);

  @override
  _EspecialidadesFormState createState() => _EspecialidadesFormState();

  final especialidade;
}

class _EspecialidadesFormState extends State<EspecialidadesForm> {
  TextEditingController nomeEspecialidade = TextEditingController();
  int idEspecialidade;

  Especialidades especialidadesHelper = Especialidades();

  GlobalKey<FormState> formKey = GlobalKey();

  var especialidade;

  @override
  void initState() {
    super.initState();
    if (widget.especialidade == null) {
      especialidade = Especialidades();
    } else {
      especialidade = Especialidades.fromMap(widget.especialidade);

      idEspecialidade = especialidade.id;
      nomeEspecialidade.text = especialidade.nomeEspecialidade;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text("Especialidade"),
          actions: [
            Padding(
              padding:
                  EdgeInsets.only(top: 15.0, bottom: 8.0, left: 8.0, right: 15),
              child: Row(
                children: [
                  Text(
                    "PD | ",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    "Case",
                    style: TextStyle(color: Colors.yellow, fontSize: 15),
                  ),
                ],
              ),
            )
          ],
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.yellow),
            onPressed: () {
              if (nomeEspecialidade.text.isEmpty ||
                  nomeEspecialidade.text == null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              } else {
                goBack(context, "Deseja sair sem salvar?");
              }
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: new TextFormField(
                keyboardType: TextInputType.text,
                controller: nomeEspecialidade,
                decoration: InputDecoration(
                  labelText: "Nome da Especialidade",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validaNome),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 15),
          color: Colors.black,
          child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 52.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(""),
                  FlatButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        await save();
                      }
                    },
                    textColor: Colors.white,
                    textTheme: ButtonTextTheme.normal,
                    child: new Row(children: const <Widget>[
                      const Text('Salvar '),
                      const Icon(
                        Icons.send,
                        color: Colors.yellow,
                      )
                    ]),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  save() async {
    var usuario = GetIt.instance<Usuario>();
    especialidade.idUsuario = usuario.id;
    especialidade.nomeEspecialidade = nomeEspecialidade.text;

    if (idEspecialidade == null) {
      await especialidadesHelper.saveEspecialidade(especialidade);
    } else {
      await especialidadesHelper.updateEspecialidade(especialidade);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  String validaNome(String value) {
    if (value.length == 0 || value.length < 3) {
      return "Insira um valor válido";
    } else {
      return null;
    }
  }

  goBack(BuildContext context, String textoExibido) {
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
                "Não",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                "Sim",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            )
          ],
        );
      },
    );
  }
}
