// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pdcase_ideia_extra/Classes/especialidades.dart';
import 'package:pdcase_ideia_extra/Classes/usuario.dart';
import 'package:pdcase_ideia_extra/Views/Especialidades/especialidadesForm.dart';

class EspecialidadesList extends StatefulWidget {
  @override
  _EspecialidadesListState createState() => _EspecialidadesListState();
}

class _EspecialidadesListState extends State<EspecialidadesList> {
  Especialidades especialidadesHelper = Especialidades();
  var usuario = GetIt.instance<Usuario>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
          future: especialidadesHelper.getAllEspecialidades(usuario.id),
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
                                children: <Widget>[
                                  Text(
                                    "Nome da especialidade: ${dadosBancoEmLista['Nome']}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Icon(
                                    Icons.medical_services,
                                    color: Colors.black54,
                                  )
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
                    child: Text("Não há dados salvos nas especialidades."));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EspecialidadesForm()));
        },
        tooltip: 'Adicionar Nova Especialidade',
        child: Icon(
          Icons.add,
          color: Colors.yellow,
        ),
      ),
    );
  }

  void showOptions(BuildContext context, especialidade) {
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
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EspecialidadesForm(
                                    especialidade: especialidade)));
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
                                  "Deseja deletar a especialidade?",
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
                                        await especialidadesHelper
                                            .deleteEspecialidade(
                                                especialidade['Id']);
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
