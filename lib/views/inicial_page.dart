import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lista_tarefas_flutter/helper/AnotationHelper.dart';
import 'package:lista_tarefas_flutter/model/Anotation.dart';
import 'package:lista_tarefas_flutter/shared/themes/color_schemes.g.dart';
import 'package:lista_tarefas_flutter/views/settings_page.dart';
import 'package:lista_tarefas_flutter/views/tarefas_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String? _escolhaEditPrioridade="";
  Icon _iconTarefas = Icon(Icons.home);
  Icon _iconSettings = Icon(Icons.settings);
  int _controlPages = 0;
  List<Widget> pages = [Tarefas_Page(), Settings_Page()];


  late Color foregroundColor;
  late Color backgroundColor;
  late Color appBarFABColor;
  late Color iconColor;


  TextEditingController _txtTitulo = TextEditingController();
  TextEditingController _txtDesc = TextEditingController();


  _formatDate(String data){
    initializeDateFormatting("pt_BR");
    
    var formater = DateFormat.yMd("pt_BR");

    DateTime dataConverted = DateTime.parse(data);
    String dataFormated = formater.format(dataConverted);

    return dataFormated;
  }

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
        title: Text("Tarefax",style: GoogleFonts.yanoneKaffeesatz(textStyle: TextStyle(color: Colors.white),fontSize: 30)),
        centerTitle: true,
        //backgroundColor: lightColorScheme.primary,
        actions: [
          //IconButton(onPressed: (){}, icon: Icon(Icons.bedtime,color: Colors.white,))
        ],
      );
    }
    else {
      return AppBar(
        title: Text(_tarefasSelecionadas.length.toString()+" selecionada(s)",style: GoogleFonts.yanoneKaffeesatz(textStyle: TextStyle(color: Colors.white),fontSize: 30)),
        centerTitle: true,
       // backgroundColor: lightColorScheme.primary,
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
    _escolhaEditPrioridade = "";
  }

  _editPrioridade() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Prioridade da Tarefa",style: GoogleFonts.yanoneKaffeesatz()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                    title: Text("Baixa",style: GoogleFonts.yanoneKaffeesatz()),
                    value: "b",
                    groupValue: _escolhaEditPrioridade,
                    onChanged: (escolha){
                      setState(() {
                        _escolhaEditPrioridade = escolha;
                        Navigator.pop(context);
                      });
                    }
                    ),
                RadioListTile(
                    title: Text("Média",style: GoogleFonts.yanoneKaffeesatz()),
                    value: "m",
                    groupValue: _escolhaEditPrioridade,
                    onChanged: (escolha){
                      setState(() {
                        _escolhaEditPrioridade = escolha;
                        Navigator.pop(context);
                      });
                    }
                    ),
                RadioListTile(
                    title: Text("Alta",style: GoogleFonts.yanoneKaffeesatz()),
                    value: "a",
                    groupValue: _escolhaEditPrioridade,
                    onChanged: (escolha){
                      setState(() {
                        _escolhaEditPrioridade = escolha;
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
                    child: Text("Cancelar",style: GoogleFonts.yanoneKaffeesatz())),
              ),
            ],
          );
        });
  }


  _addPrioridade() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Prioridade da Tarefa",style: GoogleFonts.yanoneKaffeesatz()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                    title: Text("Baixa",style: GoogleFonts.yanoneKaffeesatz()),
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
                    title: Text("Média",style: GoogleFonts.yanoneKaffeesatz()),
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
                    title: Text("Alta",style: GoogleFonts.yanoneKaffeesatz()),
                    value: "a",
                    groupValue: _escolhaEditPrioridade,
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
                    child: Text("Cancelar",style: GoogleFonts.yanoneKaffeesatz())),
              ),
            ],
          );
        });
  }

  _editTarefa(int index) {
    TextEditingController _txtEditTitulo = TextEditingController();
    TextEditingController _txtEditDesc = TextEditingController(); 
    _txtEditTitulo.text = _tarefas[index].titulo;
    _txtEditDesc.text = _tarefas[index].descricao;
    _escolhaEditPrioridade=_tarefas[index].prioridade;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Editar Tarefa",
              textAlign: TextAlign.center,
              style: GoogleFonts.yanoneKaffeesatz()
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _txtEditTitulo,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Título", hintText: "Ex: Jogar Bola..."),
                        style: GoogleFonts.yanoneKaffeesatz()
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: _txtEditDesc,
                      decoration: InputDecoration(
                          labelText: "Descrição",
                          hintText: "Ex: Levar chuteira azul...",
                          ),style: GoogleFonts.yanoneKaffeesatz()
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                        onPressed: () {
                          _editPrioridade();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.info),
                            Text("Prioridade",style: GoogleFonts.yanoneKaffeesatz()),
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
                  child: Text("Sair",style: GoogleFonts.yanoneKaffeesatz())),
              ElevatedButton(
                onPressed: () async {
                  if(_txtEditTitulo.text == ""){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("ATENÇÃO", textAlign: TextAlign.center,style: GoogleFonts.yanoneKaffeesatz(textStyle: TextStyle(color: Colors.red),)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            Center(child: Text("Selecione um Título!",style: GoogleFonts.yanoneKaffeesatz()),)
                          ]),
                          actions: [
                            Center(child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK!",style: GoogleFonts.yanoneKaffeesatz())))
                          ],
                        );
                      }
                      );
                  }
                  else if(_escolhaEditPrioridade == ""){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("ATENÇÃO",  textAlign: TextAlign.center,style: GoogleFonts.yanoneKaffeesatz(textStyle: TextStyle(color: Colors.red),)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            Center(child: Text("Selecione a Prioridade da Terefa!",style: GoogleFonts.yanoneKaffeesatz()),)
                          ]),
                          actions: [
                            Center(child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK!",style: GoogleFonts.yanoneKaffeesatz())))
                          ],
                        );
                      }
                      );
                  }
                  else{
                    Anotation _anotation = Anotation(codtarefa: _tarefas[index].codtarefa,titulo: _txtEditTitulo.text, descricao: _txtEditDesc.text, data: DateTime.now().toString(), hora: DateTime.now().toString(), prioridade: _escolhaEditPrioridade.toString());
                  await _db.uptadeAnotation(_anotation);
                  _esc();
                  Navigator.pop(context);
                  _listAnotation();
                  }
                },
                child: Text("Salvar",style: GoogleFonts.yanoneKaffeesatz())
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
              style: GoogleFonts.yanoneKaffeesatz()
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
                        style: GoogleFonts.yanoneKaffeesatz()
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: _txtDesc,
                      decoration: InputDecoration(
                          labelText: "Descrição",
                          hintText: "Ex: Levar chuteira azul..."),
                          style: GoogleFonts.yanoneKaffeesatz()
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
                            Text("Prioridade",style: GoogleFonts.yanoneKaffeesatz()),
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
                  child: Text("Sair",style: GoogleFonts.yanoneKaffeesatz())),
              ElevatedButton(
                onPressed: () async {
                  if(_txtTitulo.text == ""){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("ATENÇÃO", textAlign: TextAlign.center,style: GoogleFonts.yanoneKaffeesatz(textStyle: TextStyle(color: Colors.red),)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            Center(child: Text("Selecione um Título!",style: GoogleFonts.yanoneKaffeesatz()),)
                          ]),
                          actions: [
                            Center(child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK!",style: GoogleFonts.yanoneKaffeesatz())))
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
                          title: Text("ATENÇÃO", textAlign: TextAlign.center,style: GoogleFonts.yanoneKaffeesatz(textStyle: TextStyle(color: Colors.red),)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            Center(child: Text("Selecione a Prioridade da Terefa!",style: GoogleFonts.yanoneKaffeesatz()),)
                          ]),
                          actions: [
                            Center(child: ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK!",style: GoogleFonts.yanoneKaffeesatz())))
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
                child: Text("Salvar",style: GoogleFonts.yanoneKaffeesatz())
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
                        selectedTileColor: lightColorScheme.inversePrimary,
                        //selectedColor: Colors.black,
                        onLongPress: (){
                          setState(() {
                            (_tarefasSelecionadas.contains(item.codtarefa)) ? null : _tarefasSelecionadas.add(item.codtarefa);
                          });
                        },
                        onTap: (){
                           setState(() {
                            if(_tarefasSelecionadas.contains(item.codtarefa)){
                              _tarefasSelecionadas.remove(item.codtarefa);
                            }
                            else if(_tarefasSelecionadas.isNotEmpty){
                              _tarefasSelecionadas.add(item.codtarefa);
                            }
                            else{
                              _editTarefa(index);
                            }
                          });
                        },
                        title: Text(item.titulo,style: GoogleFonts.yanoneKaffeesatz(textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),)),
                        subtitle: Text(item.descricao+"\n"+_formatDate(item.data),style: GoogleFonts.yanoneKaffeesatz(textStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),))
                      ),
                    );
                  },        
                )
                ),
            ],
          ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          //backgroundColor: lightColorScheme.primary,
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
