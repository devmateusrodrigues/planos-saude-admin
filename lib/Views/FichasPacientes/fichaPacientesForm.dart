// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pdcase_ideia_extra/Classes/fichaPaciente.dart';
import 'package:pdcase_ideia_extra/Classes/usuario.dart';
import 'package:pdcase_ideia_extra/DataBase/db.dart';
import 'package:pdcase_ideia_extra/Views/home.dart';
import 'package:sqflite/sqflite.dart';

class FichaPacienteForm extends StatefulWidget {
  FichaPacienteForm(
      {Key key, this.fichaPaciente, this.planosDeSaude, this.especialidades})
      : super(key: key);

  @override
  _FichaPacienteFormState createState() => _FichaPacienteFormState();

  final fichaPaciente;
  final planosDeSaude;
  final especialidades;
}

class _FichaPacienteFormState extends State<FichaPacienteForm> {
  int idFichaPaciente;
  TextEditingController nomePaciente = TextEditingController();
  TextEditingController numeroCarteiraPlano = TextEditingController();
  int idPlanoDeSaude;
  List<dynamic> planoSelecionado;
  int idEspecialidade;
  List<dynamic> especialidadeSelecionada;

  FichaPaciente fichaPacienteHelper = FichaPaciente();

  GlobalKey<FormState> formKey = GlobalKey();

  var fichaPaciente;

  List<DropdownMenuItem<dynamic>> especialidades =
      List<DropdownMenuItem<dynamic>>();
  List<DropdownMenuItem<dynamic>> planos = List<DropdownMenuItem<dynamic>>();

  @override
  void initState() {
    super.initState();

    for (var especialidade in widget.especialidades) {
      especialidades.add(DropdownMenuItem<dynamic>(
        value: [especialidade['Nome'], especialidade['Id']],
        child: Text(especialidade['Nome']),
      ));
    }

    for (var plano in widget.planosDeSaude) {
      planos.add(DropdownMenuItem<dynamic>(
        value: [plano['Nome'], plano['Id']],
        child: Text(plano['Nome']),
      ));
    }

    if (widget.fichaPaciente == null) {
      fichaPaciente = FichaPaciente();
    } else {
      fichaPaciente = FichaPaciente.fromMap(widget.fichaPaciente);

      idFichaPaciente = fichaPaciente.id;
      nomePaciente.text = fichaPaciente.nomePaciente;
      numeroCarteiraPlano.text = fichaPaciente.numeroCarteiraPlano;
      idPlanoDeSaude = fichaPaciente.idPlanoDeSaude;
      idEspecialidade = fichaPaciente.idEspecialidade;

      for (var espec in especialidades) {
        if (espec.value[1] == idEspecialidade) {
          especialidadeSelecionada = espec.value;
        }
      }

      for (var planS in planos) {
        if (planS.value[1] == idPlanoDeSaude) {
          planoSelecionado = planS.value;
        }
      }
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
          title: Text("Ficha de Paciente"),
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
              if (nomePaciente.text.isEmpty ||
                  nomePaciente.text == null &&
                      numeroCarteiraPlano.text.isEmpty ||
                  numeroCarteiraPlano.text == null &&
                      idPlanoDeSaude == null &&
                      idEspecialidade == null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              } else {
                goBack(context, "Deseja sair sem salvar/editar os dados?");
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nomePaciente,
                      decoration: InputDecoration(
                        labelText: "Nome do Paciente",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validaCampo),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: numeroCarteiraPlano,
                      decoration: InputDecoration(
                        labelText: "Número da Carteira do Plano",
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validaCampo),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButton(
                      isExpanded: true,
                      hint: Text("Especialidade"),
                      value: especialidadeSelecionada,
                      items: especialidades,
                      onChanged: (itemClicado) {
                        setState(() {
                          especialidadeSelecionada = itemClicado;
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: DropdownButton(
                      isExpanded: true,
                      hint: Text("Plano de Saúde"),
                      value: planoSelecionado,
                      items: planos,
                      onChanged: (itemSelecionado) {
                        setState(() {
                          planoSelecionado = itemSelecionado;
                        });
                      }),
                ),
              ],
            ),
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
                        await validaFichaPaciente();
                      } else {
                        goBack(context, "O formulário não foi validado!");
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

  Future save() async {
    if (idFichaPaciente == null) {
      var usuario = GetIt.instance<Usuario>();
      fichaPaciente.idUsuario = usuario.id;
      await fichaPacienteHelper.saveFichaPaciente(fichaPaciente);
    } else {
      await fichaPacienteHelper.updateFichaPaciente(fichaPaciente);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future validaFichaPaciente() async {
    fichaPaciente.nomePaciente = nomePaciente.text;
    fichaPaciente.numeroCarteiraPlano = numeroCarteiraPlano.text;
    fichaPaciente.idPlanoDeSaude = planoSelecionado[1];
    fichaPaciente.idEspecialidade = especialidadeSelecionada[1];
    Database dbClient = await DatabaseHelper().db;

    var fichas = await dbClient.rawQuery("""
           SELECT Id FROM FichaPaciente 
           WHERE NumeroCarteiraPlano = \'${fichaPaciente.numeroCarteiraPlano}\' 
           AND IdPlanoDeSaude = \'${fichaPaciente.idPlanoDeSaude}\'
           AND IdEspecialidade = \'${fichaPaciente.idEspecialidade}\'""");

    if (fichas.isEmpty) {
      await save();
    } else {
      formInvalido(context);
    }
  }

  String validaCampo(String value) {
    if (value.length == 0 || value.length < 3) {
      return "Insira um valor válido";
    } else {
      return null;
    }
  }

  Future goBack(BuildContext context, String textoExibido) {
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

  Future formInvalido(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Atenção!",
            textAlign: TextAlign.center,
          ),
          content: Text(
            "A especialidade ${especialidadeSelecionada[0]} já foi utiliza para o plano ${planoSelecionado[0]}",
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
}
