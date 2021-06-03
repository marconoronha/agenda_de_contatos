import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginaContato extends StatefulWidget {
  final String idContato;
  PaginaContato({Key key, @required this.idContato}) : super(key: key);

  @override
  _PaginaContatoState createState() => _PaginaContatoState();
}

class _PaginaContatoState extends State<PaginaContato> {
  @override
  Widget build(BuildContext context) {

      CollectionReference contatos = FirebaseFirestore.instance.collection('contatos');

      return FutureBuilder<DocumentSnapshot>(
        future: contatos.doc(widget.idContato).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
              appBar: AppBar(
                title: Text("${data['nome']}"),
                centerTitle: true,
              ),
              body: ListView(
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 150.0, height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("asstes/images/nopic.png")

                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Nome",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${data['nome']}",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 10,),

                            Text(
                              "Telefone",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${data['telefone']}",
                              style: TextStyle(fontSize: 12),
                            ),

                            SizedBox(height: 10,),
                            Text(
                              "Email",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${data['email']}",
                              style: TextStyle(fontSize: 12),
                            ),

                            SizedBox(height: 10,),
                            Text(
                              "Endereço",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${data['endereco']}",
                              style: TextStyle(fontSize: 12),
                            ),

                            SizedBox(height: 10,),
                            Text(
                              "CEP",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${data['cep']}",
                              style: TextStyle(fontSize: 12),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      );
  }
}
