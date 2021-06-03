import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'PaginaPrincipal.dart';
import 'PaginaRegistro.dart';

class PaginaLogin extends StatefulWidget {
  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de Contatos"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaginaRegistro()
            ),
          );
        },
        child: Icon(Icons.app_registration),
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
                  labelText: "Login:",
                  hintText: "Digite o login"
              ),
              controller: _controllerLogin,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite o login";
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
                  labelText: "Senha:",
                  hintText: "Digite a senha"
              ),
              obscureText: true,
              controller: _controllerSenha,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite a senha ";
                }
                if(text.length < 4){
                  return "A senha tem pelo menos 4 dígitos";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),

            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text("Login",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),),
                  onPressed: () async {
                    bool formOk = _formKey.currentState.validate();
                    if(! formOk){
                      return;
                    }else{
                      await db.collection('usuarios')
                          .where('nome', isEqualTo: _controllerLogin.text)
                          .get().then((QuerySnapshot querySnapshot) {
                        if(querySnapshot.docs.isEmpty){
                          showDialog(
                              context: context,
                              builder: (context){
                                return _falhaLogin();
                              });
                        }else{
                          var item = querySnapshot.docs[0];
                          if(item['senha'] == _controllerSenha.text){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaginaPrincipal()
                              ),
                            );
                          }else{
                            showDialog(
                                context: context,
                                builder: (context){
                                  return _falhaLogin();
                                });
                          }
                        }
                      });

                    }
                    //print("Login "+_controllerLogin.text);
                    //print("Senha "+_controllerSenha.text);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  _falhaLogin(){
    return AlertDialog(
      title: Text("Usuário ou senha incorretos!"),
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

}
