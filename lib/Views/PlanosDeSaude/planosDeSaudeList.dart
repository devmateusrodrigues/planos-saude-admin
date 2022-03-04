// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pdcase_ideia_extra/Classes/planosDeSaude.dart';
import 'package:pdcase_ideia_extra/Classes/usuario.dart';
import 'package:pdcase_ideia_extra/Views/PlanosDeSaude/planosDeSaudeForm.dart';

class PlanosDeSaudeList extends StatefulWidget {
  @override
  _PlanosDeSaudeListState createState() => _PlanosDeSaudeListState();
}

class _PlanosDeSaudeListState extends State<PlanosDeSaudeList> {
  PlanosDeSaude planosDeSaudeHelper = PlanosDeSaude();
  var usuario = GetIt.instance<Usuario>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
          future: planosDeSaudeHelper.getAllPlanosDeSaude(usuario.id),
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
                                    "Nome do plano de saúde: ${dadosBancoEmLista['Nome']}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Icon(Icons.business, color: Colors.black54)
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
                    child: Text("Não há dados salvos nos planos de saúde."));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PlanosDeSaudeForm()));
        },
        tooltip: 'Adicionar Novo Plano de Saúde',
        child: Icon(
          Icons.add,
          color: Colors.yellow,
        ),
      ),
    );
  }

  void showOptions(BuildContext context, planoDeSaude) {
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
                                builder: (context) => PlanosDeSaudeForm(
                                    planoDeSaude: planoDeSaude)));
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
                                  "Deseja deletar o plano de saúde?",
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
                                        await planosDeSaudeHelper
                                            .deletePlanoDeSaude(
                                                planoDeSaude['Id']);
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
