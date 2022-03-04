// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pdcase_ideia_extra/Classes/planosDeSaude.dart';
import 'package:pdcase_ideia_extra/Classes/usuario.dart';
import 'package:pdcase_ideia_extra/Views/home.dart';

class PlanosDeSaudeForm extends StatefulWidget {
  PlanosDeSaudeForm({Key key, this.planoDeSaude}) : super(key: key);

  @override
  _PlanosDeSaudeFormState createState() => _PlanosDeSaudeFormState();

  final planoDeSaude;
}

class _PlanosDeSaudeFormState extends State<PlanosDeSaudeForm> {
  TextEditingController nomePlanoDeSaude = TextEditingController();
  int idPlanoDeSaude;

  PlanosDeSaude planoDeSaudeHelper = PlanosDeSaude();

  GlobalKey<FormState> formKey = GlobalKey();

  var planoDeSaude;

  @override
  void initState() {
    super.initState();
    if (widget.planoDeSaude == null) {
      planoDeSaude = PlanosDeSaude();
    } else {
      planoDeSaude = PlanosDeSaude.fromMap(widget.planoDeSaude);

      idPlanoDeSaude = planoDeSaude.id;
      nomePlanoDeSaude.text = planoDeSaude.nomePlanoDeSaude;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Plano de Saúde"),
          centerTitle: true,
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
              if (nomePlanoDeSaude.text.isEmpty ||
                  nomePlanoDeSaude.text == null) {
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
                controller: nomePlanoDeSaude,
                decoration: InputDecoration(
                  labelText: "Nome do Plano de Saúde",
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
    planoDeSaude.nomePlanoDeSaude = nomePlanoDeSaude.text;

    if (idPlanoDeSaude == null) {
      var usuario = GetIt.instance<Usuario>();
      planoDeSaude.idUsuario = usuario.id;
      await planoDeSaudeHelper.savePlanoDeSaude(planoDeSaude);
    } else {
      await planoDeSaudeHelper.updatePlanoDeSaude(planoDeSaude);
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
