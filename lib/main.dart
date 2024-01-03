import 'package:flutter/material.dart';
import 'package:lista_tarefas_flutter/shared/themes/color_schemes.g.dart';
import 'package:lista_tarefas_flutter/views/inicial_page.dart';


void main(){
  runApp(MaterialApp(
    theme: ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColorScheme.primary,
        elevation: 10,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary
      ),
      useMaterial3: true,
      colorScheme: lightColorScheme,
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white
      ),
      listTileTheme: ListTileThemeData(
        textColor: Colors.black,
      ),   
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.outlineVariant
      ),
    ),
    themeMode: ThemeMode.light,
    home: Inicial_Page(),
    debugShowCheckedModeBanner: false,
  ));
}