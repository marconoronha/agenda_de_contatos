import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginaPesquisar extends StatefulWidget {
  @override
  _PaginaPesquisarState createState() => _PaginaPesquisarState();
}

class _PaginaPesquisarState extends State<PaginaPesquisar> {
  TextEditingController _controllerNome = TextEditingController();
  String query = '';
  final _formKey = GlobalKey<FormState>();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    var snap = db.collection("contatos")
        .where('nome', isEqualTo: query)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: Text("Procurar Contato"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: "Recarregar página",
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Icon(Icons.search),
          onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Procurar um Contato'),
                    content: pesquisaContato(),
                  );
                }
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
                    onTap: () {
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
                                ),
                                Text(
                                  "E-mail: ",
                                ),
                                Text(
                                  "Endereço: ",
                                ),
                                Text(
                                  "CEP: ",
                                ),
                                Text(
                                  "Telefone: ",
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(item['nome']),
                                Text(item['email']),
                                Text(item['endereco']),
                                Text(item['cep']),
                                Text(item['telefone']),
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
    String enderecoEditado = endereco;
    String cepEditado = cep;
    String telefoneEditado = telefone;

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
              labelText: "Endereco: ",
            ),
            controller: _controllerEndereco,
            validator: (String text){
              if(!text.isEmpty){
                enderecoEditado = _controllerEndereco.text;
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
            onPressed: () {
              bool formOk = _formKey.currentState.validate();
              if(! formOk){
                return;
              }else{
                contatos
                    .doc(id)
                    .update({'nome': nomeEditado, 'email': emailEditado, 'endereco': enderecoEditado, 'cep': cepEditado, 'telefone': telefoneEditado, }).then((value) => Navigator.of(context).pop());

              }
            },
            child: Text('Salvar'),
          ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),

        ],
      ),
    );
  }

  pesquisaContato(){
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
               // nomeEditado = _controllerNome.text;
              }
              return null;
            },
          ),
          SizedBox(height: 10,),

          TextButton(
            onPressed: () {
              bool formOk = _formKey.currentState.validate();
              if(! formOk){
                return;
              }else{
                query = _controllerNome.text;
                Navigator.of(context).pop();
              }
            },
            child: Text('Procurar'),
          ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),

        ],
      ),
    );
  }
}
