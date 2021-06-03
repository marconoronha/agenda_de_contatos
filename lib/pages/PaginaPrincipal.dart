import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crud/PaginaAdicionar.dart';
import 'PaginaContato.dart';

class PaginaPrincipal extends StatefulWidget {
  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore db = FirebaseFirestore.instance;
    var snap = db.collection("contatos")
    .where('excluido', isEqualTo: false)
    .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaginaAdicionar()
            ),
          );
        },
      ),
      body: StreamBuilder(
        stream: snap,
        builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot
        ){
          if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }

          if(snapshot.data.docs.length == 0){
            return Center(child: Text('Nenhum contato ainda'));
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int i){
              var item = snapshot.data.docs[i];
              CollectionReference contatos = FirebaseFirestore.instance.collection('contatos');
              return GestureDetector(
                onTap: (){
                  print(item.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaginaContato(idContato: item.id)
                    ),
                  );
                },
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text(
                            'Contato: '+item['nome'],
                            style: TextStyle(fontSize: 15),
                          ),

                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text('Editar Contato'),
                                        content: editarContato(item['nome'], item['email'], item['endereco'], item['cep'], item['telefone'], item.id),
                                      );
                                    }
                                );
                              },
                              child: Text('Editar'),
                            ),

                            TextButton(
                              onPressed: () => contatos
                            .doc(item.id)
                            .update({'excluido': true}).then((value) => Navigator.of(context).pop()),
                              child: Text('Excluir'),
                            ),

                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancelar'),
                            ),

                          ],
                        );
                      });
                },
                child: Card(
                  child: Padding(padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Nome: ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "E-mail: ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Endereço: ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "CEP: ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Telefone: ",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(left: 12)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item['nome'],
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              item['email'],
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              item['endereco'],
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              item['cep'],
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              item['telefone'],
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      )
    );
  }

  editarContato(String nome, String email, String endereco, String cep, String telefone, String id){
    TextEditingController _controllerNome = TextEditingController();
    TextEditingController _controllerEmail = TextEditingController();
    TextEditingController _controllerEndereco = TextEditingController();
    TextEditingController _controllerCep = TextEditingController();
    TextEditingController _controllerTelefone = TextEditingController();
    CollectionReference contatos = FirebaseFirestore.instance.collection('contatos');

    String nomeEditado = nome;
    String emailEditado = email;
    String cepEditado = cep;
    String telefoneEditado = telefone;

    _controllerNome.text = nome;
    _controllerEmail.text = email;
    _controllerEndereco.text = endereco;
    _controllerCep.text = cep;
    _controllerTelefone.text = telefone;

    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[

          TextFormField(
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: "Nome:",
            ),
            controller: _controllerNome,
            validator: (String text){
              if(!text.isEmpty){
                nomeEditado = _controllerNome.text;
              }
              return null;
            },
          ),
          SizedBox(height: 10,),

          TextFormField(
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: "Email:",
            ),
            controller: _controllerEmail,
            validator: (String text){
              if(!text.isEmpty){
                emailEditado = _controllerEmail.text;
              }
              return null;
            },
          ),
          SizedBox(height: 10,),

          TextFormField(
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: "CEP: ",
            ),
            controller: _controllerCep,
            validator: (String text){
              if(!text.isEmpty){
                cepEditado = _controllerCep.text;
              }
              return null;
            },
          ),
          SizedBox(height: 20,),

          TextFormField(
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: "Endereco: ",
            ),
            controller: _controllerEndereco,
            validator: (String text){
              if(text.isEmpty){
                return "Digite o endereco do contato ";
              }
              return null;
            },
          ),
          SizedBox(height: 20,),

          TextFormField(
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: "Telefone: ",
            ),
            controller: _controllerTelefone,
            validator: (String text){
              if(!text.isEmpty){
                telefoneEditado = _controllerTelefone.text;
              }
              return null;
            },
          ),
          SizedBox(height: 20,),

          TextButton(
            onPressed:  () async {
              if(_controllerCep.text.isNotEmpty){
                var url = Uri.parse('https://viacep.com.br/ws/${_controllerCep.text}/json');
                var response = await http.get(url);
                print('Response status: ${response.statusCode}');
                print('Response body: ${response.body}');

                Map<String, dynamic> retorno = json.decode(response.body);
                print(retorno);


                _controllerEndereco.text = trataResponse(retorno);

              }

              print("Endereço "+_controllerEndereco.text);
              print("CEP "+_controllerCep.text);

            },
            child: Text('Buscar CEP'),
          ),

          Container(
            height: 46,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    bool formOk = _formKey.currentState.validate();
                    if(! formOk){
                      return;
                    }else{
                      contatos
                          .doc(id)
                          .update({'nome': nomeEditado, 'email': emailEditado, 'endereco': _controllerEndereco.text, 'cep': cepEditado, 'telefone': telefoneEditado, }).then((value) => Navigator.of(context).pop());

                    }
                  },
                  child: Text('Salvar'),
                ),
                Padding(padding: EdgeInsets.only(left: 40)),

                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ),



        ],
      ),
    );
  }

  trataResponse(Map<String, dynamic> ret){
    return ret["logradouro"]+", "+ret["bairro"]+" - "+ret["localidade"];
  }
}
