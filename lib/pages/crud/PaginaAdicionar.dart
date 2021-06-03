import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaginaAdicionar extends StatefulWidget {
  @override
  _PaginaAdicionarState createState() => _PaginaAdicionarState();
}

class _PaginaAdicionarState extends State<PaginaAdicionar> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerCep = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar um Contato"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[

            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Nome:",
              ),
              controller: _controllerNome,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite um nome";
                }
                return null;
              },
            ),
            SizedBox(height: 10,),

            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Email:",
              ),
              controller: _controllerEmail,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite o email do contato";
                }
                return null;
              },
            ),
            SizedBox(height: 10,),

            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "CEP: ",
              ),
              controller: _controllerCep,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite o CEP do contato ";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),

            TextFormField(
              style: TextStyle(
                fontSize: 20,
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
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Telefone: ",
              ),
              controller: _controllerTelefone,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite o telefone do contato ";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),

            Container(
              height: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      child: Text("Buscar CEP",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),),
                      onPressed: () async {
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

                      }
                  ),

                  Padding(padding: EdgeInsets.only(left: 40)),

                  ElevatedButton(
                      child: Text("Adicionar",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),),
                      onPressed: () async {
                        bool formOk = _formKey.currentState.validate();
                        if(! formOk){
                          return;
                        }else{
                          await db.collection("contatos")
                              .add({
                            'nome': _controllerNome.text,
                            'email': _controllerEmail.text,
                            'endereco': _controllerEndereco.text,
                            'cep': _controllerCep.text,
                            'telefone': _controllerTelefone.text,
                            'excluido': false
                          }).then((value){
                            showDialog(
                                context: context,
                                builder: (context){
                                  return _confirmacao();
                                });
                          });
                        }
                        print("Nome "+_controllerNome.text);
                        print("Email "+_controllerEmail.text);
                        print("Endereço "+_controllerEndereco.text);
                        print("CEP "+_controllerCep.text);
                        print("Telefone "+_controllerTelefone.text);

                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _confirmacao(){
    return AlertDialog(
      title: Text("Registro efetuado"),
      actions: <Widget>[
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("Ok")
        ),
      ],
    );
  }

  trataResponse(Map<String, dynamic> ret){
    return ret["logradouro"]+", "+ret["bairro"]+" - "+ret["localidade"];
  }

}
