import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginaRegistro extends StatefulWidget {
  @override
  _PaginaRegistroState createState() => _PaginaRegistroState();
}

class _PaginaRegistroState extends State<PaginaRegistro> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmaSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
          title: Text("Registrar")
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
                  labelText: "Usuário:",
                  hintText: "Digite um nome de usuário"
              ),
              controller: _controllerLogin,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite um nome de usuário";
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
                if(text.length < 4 || _controllerConfirmaSenha.text != _controllerSenha.text){
                  return "As senhas devem ter pelo menos 4 dígitos e serem iguais";
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
                  labelText: "Confirmar Senha:",
                  hintText: "Confirme sua senha"
              ),
              obscureText: true,
              controller: _controllerConfirmaSenha,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite a senha ";
                }
                if(text.length < 4 || _controllerConfirmaSenha.text != _controllerSenha.text){
                  return "As senhas devem ter pelo menos 4 dígitos e serem iguais";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text("Registrar",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                  onPressed: () async {
                    bool formOk = _formKey.currentState.validate();
                    if(! formOk){
                      return;
                    }else{
                      await db.collection('usuarios')
                          .where('nome', isEqualTo: _controllerLogin.text)
                          .get().then((QuerySnapshot querySnapshot) {

                            if(querySnapshot.docs.isEmpty){
                              db.collection('usuarios')
                                  .add({
                                'nome': _controllerLogin.text,
                                'senha': _controllerSenha.text,
                              }).then((value){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return _confirmacao();
                                    });
                              });
                            }
                            else{
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return _falha();
                                  });
                            }
                      });

                      _controllerLogin.text = "";
                      _controllerSenha.text = "";
                      _controllerConfirmaSenha.text = "";
                    }
                  }
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

  _falha(){
    return AlertDialog(
      title: Text("Username taken!"),
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
