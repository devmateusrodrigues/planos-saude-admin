import 'package:pdcase_ideia_extra/DataBase/db.dart';
import 'package:sqflite/sqflite.dart';

class PlanosDeSaude {
  int id;
  int idUsuario;
  String nomePlanoDeSaude;

  PlanosDeSaude();

  PlanosDeSaude.fromMap(Map map) {
    id = map['Id'];
    idUsuario = map['IdUsuario'];
    nomePlanoDeSaude = map['Nome'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "IdUsuario": idUsuario,
      "Nome": nomePlanoDeSaude
    };
    if (id != null) {
      map['Id'] = id;
    }
    return map;
  }

  //create data
  Future savePlanoDeSaude(PlanosDeSaude planoDeSaude) async {
    Database dbClient = await DatabaseHelper().db;

    planoDeSaude.id = await dbClient.rawInsert("""
    INSERT OR REPLACE INTO PlanosDeSaude (IdUsuario, Nome)
                                         VALUES (
                                          \'${planoDeSaude.idUsuario}\',
                                          \'${planoDeSaude.nomePlanoDeSaude}\')""");

    return planoDeSaude;
  }

  //retrieve data
  Future<List> getAllPlanosDeSaude(int idUsuario) async {
    Database dbClient = await DatabaseHelper().db;

    var dados = await dbClient.rawQuery(
        """SELECT * FROM PlanosDeSaude WHERE IdUsuario = \'$idUsuario\'""");
    return dados;
  }

  //update data
  Future updatePlanoDeSaude(PlanosDeSaude planoDeSaude) async {
    Database dbClient = await DatabaseHelper().db;

    await dbClient.rawInsert("""
    UPDATE PlanosDeSaude
        SET
           Nome = \'${planoDeSaude.nomePlanoDeSaude}\'
        WHERE
          Id = \'${planoDeSaude.id}\'
    """);
  }

  //delete data
  Future deletePlanoDeSaude(int id) async {
    Database dbClient = await DatabaseHelper().db;

    await dbClient
        .rawDelete("""DELETE FROM PlanosDeSaude WHERE Id = \'$id\'""");
  }
}
