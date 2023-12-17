import 'package:flutter/material.dart';
import 'package:lista_tarefas_flutter/helper/AnotationHelper.dart';
import 'package:lista_tarefas_flutter/model/Anotation.dart';
import 'package:lista_tarefas_flutter/shared/themes/color_schemes.g.dart';
import 'package:lista_tarefas_flutter/views/settings_page.dart';
import 'package:lista_tarefas_flutter/views/tarefas_page.dart';

class Inicial_Page extends StatefulWidget {
  const Inicial_Page({super.key});

  @override
  State<Inicial_Page> createState() => _Inicial_PageState();
}

class _Inicial_PageState extends State<Inicial_Page> {

  List<Anotation> _tarefas = [];
  var _db = AnotationHelper();
  String? _escolhaPrioridade="";
  Icon _iconTarefas = Icon(Icons.home);
  Icon _iconSettings = Icon(Icons.settings);
  int _controlPages = 0;
  List<Widget> pages = [Tarefas_Page(), Settings_Page()];

  TextEditingController _txtTitulo = TextEditingController();
  TextEditingController _txtDesc = TextEditingController();

  Color _getPriorityColor(String priority) {
  switch (priority) {
    case 'b':
      return lightColorScheme.primaryContainer; // Prioridade baixa
    case 'm':
      return Color(0xffffff99); // Prioridade média
    case 'a':
      return Color(0xffff8080); // Prioridade alta
    default:
      return lightColorScheme.primaryContainer; // Cor padrão se a prioridade for desconhecida
  }
}


  _listAnotation() async {
    List anotationsRec = await _db.listAnotation();
    List<Anotation> listTemp = [];

    for(var item in anotationsRec){

      Anotation anotation = Anotation(
        codtarefa: item["codtarefa"],
        titulo: item["titulo"],
        descricao: item["descricao"],
        data: item["data"],
        hora: item["hora"],
        prioridade: item["prioridade"]
        );

        listTemp.add(anotation);

    }

    setState(() {
      _tarefas = listTemp;
    });
    _tarefas = listTemp;
   // listTemp.clear();

  }

  _esc(){
    _txtTitulo.clear();
    _txtDesc.clear();
    _escolhaPrioridade = "";
  }

  _addPrioridade() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Prioridade da Tarefa"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                    title: Text("Baixa"),
                    value: "b",
                    groupValue: _escolhaPrioridade,
                    onChanged: (escolha){
                      setState(() {
                        _escolhaPrioridade = escolha;
                        Navigator.pop(context);
                      });
                    }
                    ),
                RadioListTile(
                    title: Text("Média"),
                    value: "m",
                    groupValue: _escolhaPrioridade,
                    onChanged: (escolha){
                      setState(() {
                        _escolhaPrioridade = escolha;
                        Navigator.pop(context);
                      });
                    }
                    ),
                RadioListTile(
                    title: Text("Alta"),
                    value: "a",
                    groupValue: _escolhaPrioridade,
                    onChanged: (escolha){
                      setState(() {
                        _escolhaPrioridade = escolha;
                        Navigator.pop(context);
                      });
                    }
                    ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
              ),
            ],
          );
        });
  }

  _addTarefa() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Nova Tarefa",
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _txtTitulo,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Título", hintText: "Ex: Jogar Bola..."),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: _txtDesc,
                      decoration: InputDecoration(
                          labelText: "Descrição",
                          hintText: "Ex: Levar chuteira azul..."),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                        onPressed: () {
                          _addPrioridade();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.info),
                            Text("Prioridade"),
                            Icon(Icons.arrow_right)
                          ],
                        )),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _esc();
                  },
                  child: Text("Sair")),
              ElevatedButton(
                onPressed: () async {
                  if(_txtTitulo.text == ""){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("ATENÇÃO", textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            Center(child: Text("Selecione um Título!"),)
                          ]),
                          actions: [
                            Center(child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK!")))
                          ],
                        );
                      }
                      );
                  }
                  else if(_escolhaPrioridade == ""){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("ATENÇÃO", textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            Center(child: Text("Selecione a Prioridade da Terefa!"),)
                          ]),
                          actions: [
                            Center(child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK!")))
                          ],
                        );
                      }
                      );
                  }
                  else{
                    Anotation _anotation = Anotation(titulo: _txtTitulo.text, descricao: _txtDesc.text, data: DateTime.now().toString(), hora: DateTime.now().toString(), prioridade: _escolhaPrioridade.toString());
                  await _db.saveAnotation(_anotation);
                  _esc();
                  Navigator.pop(context);
                  _listAnotation();
                  }
                },
                child: Text("Salvar")
                ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listAnotation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarefax",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: lightColorScheme.primary,
      ),
      body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index){
                  final item = _tarefas[index];
                  Color _cardColor = _getPriorityColor(item.prioridade);
                  return Card(
                    color: _cardColor,
                    child: ListTile(
                      title: Text(item.titulo),
                      subtitle: Text(item.descricao),
                    ),
                  );
                },        
              )
              ),
          ],
        ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _addTarefa();
        },
      ),
     /* bottomNavigationBar: BottomNavigationBar(
        currentIndex: _controlPages,
        onTap: (index) {
          setState(() {
            _controlPages = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "TAREFAS"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "AJUSTES"),
        ],
      ),*/
    );
  }
}
