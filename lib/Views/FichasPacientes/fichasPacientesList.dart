// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pdcase_ideia_extra/Classes/especialidades.dart';
import 'package:pdcase_ideia_extra/Classes/fichaPaciente.dart';
import 'package:pdcase_ideia_extra/Classes/planosDeSaude.dart';
import 'package:pdcase_ideia_extra/Classes/usuario.dart';
import 'package:pdcase_ideia_extra/Views/FichasPacientes/fichaPacientesForm.dart';

class FichaPacientesList extends StatefulWidget {
  @override
  _FichaPacientesListState createState() => _FichaPacientesListState();
}

class _FichaPacientesListState extends State<FichaPacientesList> {
  FichaPaciente fichaPacienteHelper = FichaPaciente();
  Especialidades especialidadesHelper = Especialidades();
  PlanosDeSaude planosDeSaudeHelper = PlanosDeSaude();
  var usuario = GetIt.instance<Usuario>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
          future: fichaPacienteHelper.getAllFichaPaciente(usuario.id),
          builder: (context, dadosBanco) {
            if (dadosBanco.hasData) {
              if (dadosBanco.data.toString() != "[]") {
                return Container(
                    child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: dadosBanco.data.map((dadosBancoEmLista) {
                    return GestureDetector(
                      child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Nome do paciente: ${dadosBancoEmLista['NomePaciente']}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "Número da carteira: ${dadosBancoEmLista['NumeroCarteiraPlano']}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.file_copy_outlined,
                                      color: Colors.black54)
                                ],
                              ),
                            )),
                      ),
                      onTap: () {
                        showOptions(context, dadosBancoEmLista);
                      },
                    );
                  }).toList(),
                ));
              } else {
                return Center(
                    child:
                        Text("Não há dados salvos nas fichas de pacientes."));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          var especialidades =
              await especialidadesHelper.getAllEspecialidades(usuario.id);
          var planosDeSaude =
              await planosDeSaudeHelper.getAllPlanosDeSaude(usuario.id);

          if (especialidades.isEmpty || planosDeSaude.isEmpty) {
            alert(context);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FichaPacienteForm(
                          planosDeSaude: planosDeSaude,
                          especialidades: especialidades,
                        )));
          }
        },
        tooltip: 'Adicionar Ficha de Paciente',
        child: Icon(
          Icons.add,
          color: Colors.yellow,
        ),
      ),
    );
  }

  alert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Atenção!",
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Não é possível salvar uma ficha de paciente sem que hajam Planos de Saúde e Especidalidades salvos.",
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

  void showOptions(BuildContext context, fichaPaciente) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      child: Text(
                        "Ver",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () async {
                        var especialidades = await especialidadesHelper
                            .getAllEspecialidades(usuario.id);
                        var planosDeSaude = await planosDeSaudeHelper
                            .getAllPlanosDeSaude(usuario.id);
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FichaPacienteForm(
                                      fichaPaciente: fichaPaciente,
                                      especialidades: especialidades,
                                      planosDeSaude: planosDeSaude,
                                    )));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      child: Text(
                        "Deletar",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () {
                        var deletar;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return WillPopScope(
                              onWillPop: () async => true,
                              child: AlertDialog(
                                title: Text(
                                  "Deseja deletar a Ficha do Paciente?",
                                  textAlign: TextAlign.center,
                                ),
                                content: Row(
                                  children: <Widget>[
                                    new Expanded(
                                        child: new TextField(
                                      autofocus: true,
                                      decoration: new InputDecoration(
                                          labelText:
                                              'Digite "sim" para deletar',
                                          hintText: 'sim'),
                                      onChanged: (value) {
                                        setState(() {
                                          deletar = value;
                                        });
                                      },
                                    ))
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Não"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Deletar"),
                                    onPressed: () async {
                                      if (deletar == 'sim') {
                                        await fichaPacienteHelper
                                            .deleteFichaPaciente(
                                                fichaPaciente['Id']);
                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
