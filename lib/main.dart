import 'package:flutter/material.dart';
import 'package:lista_tarefas_flutter/shared/themes/color_schemes.g.dart';
import 'package:lista_tarefas_flutter/views/inicial_page.dart';


void main(){
  runApp(MaterialApp(
    theme: ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 10,
      ),
      useMaterial3: true,
      colorScheme: lightColorScheme,
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme
    ),
    themeMode: ThemeMode.light,
    home: Inicial_Page(),
    debugShowCheckedModeBanner: false,
  ));
}