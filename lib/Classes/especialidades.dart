import 'package:pdcase_ideia_extra/DataBase/db.dart';
import 'package:sqflite/sqflite.dart';

class Especialidades {
  int id;
  int idUsuario;
  String nomeEspecialidade;

  Especialidades();

  Especialidades.fromMap(Map map) {
    id = map['Id'];
    idUsuario = map['IdUsuario'];
    nomeEspecialidade = map['Nome'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "IdUsuario": idUsuario,
      "Nome": nomeEspecialidade
    };
    if (id != null) {
      map['Id'] = id;
    }
    return map;
  }

  //create data
  Future saveEspecialidade(Especialidades especialidade) async {
    Database dbClient = await DatabaseHelper().db;

    especialidade.id = await dbClient.rawInsert("""
    INSERT OR REPLACE INTO Especialidades (IdUsuario, Nome)
                                         VALUES (
                                          \'${especialidade.idUsuario}\',
                                          \'${especialidade.nomeEspecialidade}\')""");

    return especialidade;
  }

  //retrieve data
  Future<List> getAllEspecialidades(int idUsuario) async {
    Database dbClient = await DatabaseHelper().db;

    var dados = await dbClient.rawQuery(
        """SELECT * FROM Especialidades WHERE IdUsuario = \'$idUsuario\'""");
    return dados;
  }

  //update data
  Future updateEspecialidade(Especialidades especialidade) async {
    Database dbClient = await DatabaseHelper().db;

    await dbClient.rawInsert("""
    UPDATE Especialidades
        SET
           Nome = \'${especialidade.nomeEspecialidade}\'
        WHERE
          Id = \'${especialidade.id}\'
    """);
  }

  //delete data
  Future deleteEspecialidade(int id) async {
    Database dbClient = await DatabaseHelper().db;

    await dbClient
        .rawDelete("""DELETE FROM Especialidades WHERE Id = \'$id\'""");
  }
}
