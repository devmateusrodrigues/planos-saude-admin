import 'package:pdcase_ideia_extra/DataBase/db.dart';
import 'package:sqflite/sqflite.dart';

class Usuario {
  int id;
  String email;
  String nome;
  String senha;

  Usuario();

  Usuario.fromMap(Map map) {
    id = map['Id'];
    email = map['Email'];
    nome = map['Nome'];
    senha = map['Senha'];
  }

  Map toMap() {
    Map<String, dynamic> map = {"Email": email, "Nome": nome, "Senha": senha};
    if (id != null) {
      map['Id'] = id;
    }
    return map;
  }

  Future saveUsuario(Usuario usuario) async {
    Database dbClient = await DatabaseHelper().db;

    usuario.id = await dbClient.rawInsert("""
    INSERT OR REPLACE INTO Usuario(Email, Nome, Senha) VALUES (
                                                       \'${usuario.email}\',
                                                       \'${usuario.nome}\',
                                                       \'${usuario.senha}\')""");
    return usuario;
  }

  Future getUsuario() async {
    Database dbClient = await DatabaseHelper().db;

    var usuario = await dbClient.rawQuery("""
        SELECT * FROM Usuario""");

    return usuario;
  }

  Future getUsuarioLogin(Usuario usuario) async {
    Database dbClient = await DatabaseHelper().db;

    var login = await dbClient.rawQuery("""
        SELECT * FROM Usuario WHERE 
        Email = \'${usuario.email}\' AND 
        Senha = \'${usuario.senha}\'""");

    return login;
  }

  Future updateUsuario(Usuario usuario) async {
    Database dbClient = await DatabaseHelper().db;

    await dbClient.rawInsert("""
    UPDATE Usuario
        SET
           Email = \'${usuario.email}\',
           Nome = \'${usuario.nome}\',
           Senha = \'${usuario.senha}\'
        WHERE
          Id = \'${usuario.id}\'
    """);
  }

  Future deleteUsuario(int id) async {
    Database dbClient = await DatabaseHelper().db;

    await dbClient.rawDelete("""DELETE FROM Usuario WHERE Id = \'$id\'""");
  }
}
