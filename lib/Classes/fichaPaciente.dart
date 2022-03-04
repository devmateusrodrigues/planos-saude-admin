import 'package:pdcase_ideia_extra/DataBase/db.dart';
import 'package:sqflite/sqflite.dart';

class FichaPaciente {
  int id;
  String nomePaciente;
  String numeroCarteiraPlano;
  int idUsuario;
  int idPlanoDeSaude;
  int idEspecialidade;

  FichaPaciente();

  FichaPaciente.fromMap(Map map) {
    id = map['Id'];
    nomePaciente = map['NomePaciente'];
    numeroCarteiraPlano = map['NumeroCarteiraPlano'];
    idUsuario = map['IdUsuario'];
    idPlanoDeSaude = map['IdPlanoDeSaude'];
    idEspecialidade = map['IdEspecialidade'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "NomePaciente": nomePaciente,
      "NumeroCarteiraPlano": numeroCarteiraPlano,
      "IdUsuario": idUsuario,
      "IdPlanoDeSaude": idPlanoDeSaude,
      "IdEspecialidade": idEspecialidade
    };
    if (id != null) {
      map['Id'] = id;
    }
    return map;
  }

  //create data
  Future saveFichaPaciente(FichaPaciente fichaPaciente) async {
    Database dbClient = await DatabaseHelper().db;

    fichaPaciente.id = await dbClient.rawInsert("""
    INSERT OR REPLACE INTO FichaPaciente(NomePaciente,
                                         NumeroCarteiraPlano,
                                         IdUsuario,
                                         IdPlanoDeSaude,
                                         IdEspecialidade) VALUES (
                                                          \'${fichaPaciente.nomePaciente}\',
                                                          \'${fichaPaciente.numeroCarteiraPlano}\',
                                                          \'${fichaPaciente.idUsuario}\',
                                                          \'${fichaPaciente.idPlanoDeSaude}\',
                                                          \'${fichaPaciente.idEspecialidade}\')""");

    return fichaPaciente;
  }

  //retrieve data
  Future<List> getAllFichaPaciente(int idUsuario) async {
    Database dbClient = await DatabaseHelper().db;

    var dados = await dbClient.rawQuery(
        """SELECT * FROM FichaPaciente WHERE IdUsuario = \'$idUsuario\'""");
    return dados;
  }

  //update data
  Future updateFichaPaciente(FichaPaciente fichaPaciente) async {
    Database dbClient = await DatabaseHelper().db;

    await dbClient.rawInsert("""
    UPDATE FichaPaciente
        SET
           NomePaciente = \'${fichaPaciente.nomePaciente}\',
           NumeroCarteiraPlano = \'${fichaPaciente.numeroCarteiraPlano}\',
           IdPlanoDeSaude = \'${fichaPaciente.idPlanoDeSaude}\',
           IdEspecialidade = \'${fichaPaciente.idEspecialidade}\'
        WHERE
          Id = \'${fichaPaciente.id}\'
    """);
  }

  //delete data
  Future deleteFichaPaciente(int id) async {
    Database dbClient = await DatabaseHelper().db;

    await dbClient
        .rawDelete("""DELETE FROM FichaPaciente WHERE Id = \'$id\'""");
  }
}
