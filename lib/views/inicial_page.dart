import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  List _tarefasSelecionadas = [];
  var _db = AnotationHelper();
  String? _escolhaPrioridade="";
  Icon _iconTarefas = Icon(Icons.home);
  Icon _iconSettings = Icon(Icons.settings);
  int _controlPages = 0;
  List<Widget> pages = [Tarefas_Page(), Settings_Page()];

  TextEditingController _txtTitulo = TextEditingController();
  TextEditingController _txtDesc = TextEditingController();


  _confirmDelete(){
     showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Confirma exclusão de ${_tarefasSelecionadas.length.toString()} Tarefa(s)?",textAlign: TextAlign.center,),
          actions: [
            ElevatedButton(
              onPressed: (){Navigator.pop(context);},
              child: Text("Não")
              ),
              ElevatedButton(
              onPressed: (){
                for(var item in _tarefasSelecionadas){
                 _db.deleteAnotation(item.toString());
                }
                setState(() {
                 _tarefasSelecionadas.clear();
                _listAnotation();
                Navigator.pop(context);
                });
              },
              child: Text("Sim")
              ),
          ],
        );
      }
      );
  }

  _appBarDinamyc(){

    if(_tarefasSelecionadas.isEmpty){
      return AppBar(
        title: Text("Tarefax",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: lightColorScheme.primary,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.bedtime,color: Colors.white,))
        ],
      );
    }
    else {
      return AppBar(
        title: Text(_tarefasSelecionadas.length.toString()+" selecionada(s)",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: lightColorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            setState(() {
              _tarefasSelecionadas = [];
            });
          },
        ),
        actions: [
          IconButton(
          onPressed: (){
            _confirmDelete();
          },
          icon: Icon(Icons.delete,color: Colors.white,))
        ],
      );
    }

  }


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
      appBar: _appBarDinamyc(),
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
                      selected: _tarefasSelecionadas.contains(item.codtarefa),
                      //selectedTileColor: lightColorScheme.primary,
                      //selectedColor: Colors.black,
                      onLongPress: (){
                        setState(() {
                          (_tarefasSelecionadas.contains(item.codtarefa)) ? null : _tarefasSelecionadas.add(item.codtarefa);
                        });
                      },
                      onTap: (){
                         setState(() {
                          (_tarefasSelecionadas.contains(item.codtarefa)) ? _tarefasSelecionadas.remove(item.codtarefa) : _tarefasSelecionadas.add(item.codtarefa);
                        });
                      },
                      title: Text(item.titulo,style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(item.descricao+"\n"+item.data,style: TextStyle(fontWeight: FontWeight.w500),),
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
