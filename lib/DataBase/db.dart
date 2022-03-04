import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  DatabaseHelper.internal();

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "estagio_pdcase.db");

    var dbInstance = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return dbInstance;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE Usuario (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Email TEXT,
        Nome TEXT,
        Senha TEXT)""");
    await db.execute("""CREATE TABLE FichaPaciente (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        NomePaciente TEXT,
        NumeroCarteiraPlano TEXT,
        IdUsuario INTEGER,
        IdPlanoDeSaude INTEGER,
        IdEspecialidade INTEGER)""");
    await db.execute("""CREATE TABLE Especialidades (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        IdUsuario INTEGER,
        Nome TEXT)""");
    await db.execute("""CREATE TABLE PlanosDeSaude (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        IdUsuario INTEGER,
        Nome TEXT)""");

    await _loadInitialData(db);
  }

  _loadInitialData(Database db) async {
    Map<String, dynamic> senio = {
      "Email": "senio.caires@pdcase.com.br",
      "Nome": "Sênio Caires",
      "Senha": "pdcase2021"
    };

    Map<String, dynamic> gilvane = {
      "Email": "gilvane.santos@pdcase.com.br",
      "Nome": "Gilvane Santos",
      "Senha": "pdcase2021"
    };

    Map<String, dynamic> mateus = {
      "Email": "mateus.santos@pdcase.com.br",
      "Nome": "Mateus Santos",
      "Senha": "pdcase2021"
    };

    List<String> especialidades = [
      "Clínico Geral",
      "Dentista",
      "Ortopedista",
      "Nutricionista",
      "Fonoaudiólogo",
      "Fisioterapeuta",
      "Neurologista",
      "Psicólogo",
      "Psiquiatra",
      "Ginecologista"
    ];

    List<String> planosDeSaude = [
      "Unimed",
      "SaudeVida",
      "OdontoPrev",
      "Consórcio Itaú Saúde",
      "SulAmérica",
      "HapVida"
    ];

    await db.rawInsert(
        """INSERT OR REPLACE INTO Usuario(Email, Nome, Senha) VALUES (
                                                       \'${senio['Email']}\',
                                                       \'${senio['Nome']}\',
                                                       \'${senio['Senha']}\')""");

    await db.rawInsert(
        """INSERT OR REPLACE INTO Usuario(Email, Nome, Senha) VALUES (
                                                       \'${gilvane['Email']}\',
                                                       \'${gilvane['Nome']}\',
                                                       \'${gilvane['Senha']}\')""");

    await db.rawInsert(
        """INSERT OR REPLACE INTO Usuario(Email, Nome, Senha) VALUES (
                                                       \'${mateus['Email']}\',
                                                       \'${mateus['Nome']}\',
                                                       \'${mateus['Senha']}\')""");

    for (String especialidade in especialidades) {
      await db.rawInsert(
          """INSERT OR REPLACE INTO Especialidades(Nome, IdUsuario) VALUES ( \'$especialidade\', '1')""");

      await db.rawInsert(
          """INSERT OR REPLACE INTO Especialidades(Nome, IdUsuario) VALUES ( \'$especialidade\', '2')""");

      await db.rawInsert(
          """INSERT OR REPLACE INTO Especialidades(Nome, IdUsuario) VALUES ( \'$especialidade\', '3')""");
    }

    for (String planoDeSaude in planosDeSaude) {
      await db.rawInsert(
          """INSERT OR REPLACE INTO PlanosDeSaude(Nome, IdUsuario) VALUES ( \'$planoDeSaude\', '1')""");

      await db.rawInsert(
          """INSERT OR REPLACE INTO PlanosDeSaude(Nome, IdUsuario) VALUES ( \'$planoDeSaude\', '2')""");

      await db.rawInsert(
          """INSERT OR REPLACE INTO PlanosDeSaude(Nome, IdUsuario) VALUES ( \'$planoDeSaude\', '3')""");
    }
  }
}
