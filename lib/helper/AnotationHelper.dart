import 'package:flutter/material.dart';
import 'package:lista_tarefas_flutter/model/Anotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Esta classe está usando o padrão SINGLETON
class AnotationHelper {
  Database? _Db;
  String _nomeTabela = "tarefa";
  static final AnotationHelper _anotationHelper = AnotationHelper._internal();

  AnotationHelper._internal();

  factory AnotationHelper() {
    return _anotationHelper;
  }

  // Banco de Dados
  Future<Database> get db async {
    if (_Db != null) {
      return _Db!;
    } else {
      _Db = await initDB();
      return _Db!;
    }
  }

  Future<Database> initDB() async {
    final directoryDb = await getDatabasesPath();
    final localDb = join(directoryDb, "db_tarefas.db");

    var db = await openDatabase(localDb, version: 1, onCreate: _onCreate);
    return db;
  }

Future<void> _onCreate(Database db, int version) async {
  String sqlTarefa = '''
    CREATE TABLE tarefa (
      codtarefa INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo VARCHAR,
      descricao TEXT,
      data DATE,
      hora TIME,
      prioridade VARCHAR
    );
  ''';

  String sqlTema = '''
    CREATE TABLE tema (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      modonoturno VARCHAR DEFAULT 'light'
    );
  ''';

  await db.execute(sqlTarefa);
  await db.execute(sqlTema);

  await db.insert("tema", {"modonoturno": "light"});
}

  Future<int> saveAnotation(Anotation anotation) async {
    Database bd = await db;
    Map<String, dynamic> tarefa = {
      "titulo": anotation.titulo,
      "descricao": anotation.descricao,
      "data": anotation.data,
      "hora": anotation.hora,
      "prioridade": anotation.prioridade,
    };

    int result = await bd.insert(_nomeTabela, tarefa);
    return result;
  }

  listAnotation() async {
    Database bd = await db;
    String sql = "SELECT * FROM tarefa ORDER BY data DESC";
    List tarefas = await bd.rawQuery(sql);

    return tarefas;
  }


  deleteAnotation(String codtarefa) async {
    Database bd = await db;
    await bd.delete(
      _nomeTabela,
      where: "codtarefa = ?",
      whereArgs: [codtarefa]
      ); 
  }

  uptadeAnotation(Anotation anotation) async {
    Database bd = await db;
    Map<String, dynamic> tarefa = {
      "titulo": anotation.titulo,
      "descricao": anotation.descricao,
      "data": anotation.data,
      "hora": anotation.hora,
      "prioridade": anotation.prioridade,
    };

    bd.update(
      _nomeTabela,
      tarefa,
      where: "codtarefa = ?",
      whereArgs: [anotation.codtarefa]
      );
  }

  setTheme(int value) async {
    Database bd = await db;
    Map<String, dynamic> temaMap ={
      "modonoturno": value
    };
    bd.update("tema", temaMap, where: "id = ?",whereArgs: [1]);
  }

  listThemeApp() async {
    Database bd = await db;
    String sql = "SELECT * FROM tema";
    List theme = await bd.rawQuery(sql);

    return theme;
  }

}
