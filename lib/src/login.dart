import 'dart:convert';
//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_application_restaurante/src/app.dart';
//import 'package:flutter_application_restaurante/src/conection.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  //var db = connectToDatabase();
  
  final TextEditingController emailcontroller=TextEditingController();
  final TextEditingController passwordcontroller=TextEditingController();

  Future<void> _validarCredenciales() async {
    
    final String apiUrl = 'http://192.118.101.15:8000/api/login';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'email': emailcontroller.text,
        'password': passwordcontroller.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Inicia sesión en el usuario y redirige al usuario a la página principal.
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyAppForm()),
            );
    } else {
      // Muestra un mensaje de error al usuario.
      //_showMessage(context);
    }
  }
  // Define la función para mostrar el mensaje
 /*void _showMessage(BuildContext context) {
    // Crea un widget de tipo SnackBar con el mensaje
    final snackBar = SnackBar(
      content: Text('ERROR AL INICIAR SESIÓN'),
      duration: Duration(seconds: 3), // Duración del mensaje en segundos
    );

    // Muestra el widget en la parte inferior de la pantalla
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
*/
  /*void _validarCredenciales(){
    db.getConnection().then((conn)){
      String sql = 'SELECT*FROM users WHERE email = $_email AND password = $_password';
      conn.query(sql).then((results){
        for(var row in results){
          setState((){
          'Ha iniciado sesión';
        })
        }
      })
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 212, 211),
      
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              const CircleAvatar(
                radius: 100.0,
                backgroundColor: Color.fromARGB(255, 228, 104, 2),
                backgroundImage: AssetImage('images/logoRamada.png'),
              ),
              const Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'cursive',
                  fontSize: 50.0,
                  color: Colors.black
                ),
              ),
              const Divider(
                  height: 18.0,
              ),
              const Text(
                'Usuario',
                style: TextStyle(
                  fontFamily: 'cursive',
                  fontSize: 20.0,
                  color: Colors.black
                ),
              ),
              const SizedBox(
                width: 160.0,
                height: 15.0,
                child: Divider(
                  color: Color.fromARGB(255, 58, 167, 218),
                ),
              ),
              const Divider(
                  height: 18.0,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: emailcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
                decoration: InputDecoration(
                  hintText: 'E-MAIL',
                  hintStyle: const TextStyle(color: Colors.blue),
                  labelText: 'E-mail',
                  labelStyle: const TextStyle(color: Colors.black),
                   suffixIcon: const Icon(
                      Icons.alternate_email
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)
                    )
                ),
              ),
              const Divider(
                  height: 18.0,
                ),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: passwordcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'PASSWORD',
                  hintStyle: const TextStyle(color: Colors.blue),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black),
                  suffixIcon: const Icon(
                      Icons.lock_outline
                  ),
                border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)
                    )
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                
              ),
              ElevatedButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Aquí puedes realizar la autenticación del usuario
                      _validarCredenciales();
                    }
                  }, 
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )
                    )
                ),
            ],
          ),
        ),
      ),
    );
  }
}
