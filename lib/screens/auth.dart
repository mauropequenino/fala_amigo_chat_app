import 'package:fala_amigo_chat_app/widgets/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async{
    final isValid = _formKey.currentState!.validate();

    if(!isValid) {
      return;
    }

    _formKey.currentState!.save();    

    try {
      if(_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, 
          password: _enteredPassword
        );
      }else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, 
          password: _enteredPassword
        );
      }
    } on FirebaseAuthException catch (error) {
      if(error.code == 'email-already-in-use') {

      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Autenticação falhou.")
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
               ),
               Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserImagePicker(),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email'
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Insira o seu email';
                              } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                                return 'Insira um email válido';
                              }
                              return null; 
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password'
                            ),
                            obscureText: true,
                            validator: (value) {
                              if(value == null || value.trim().length < 6){
                                return 'A palavra passe deve maior que 6 caracteres.'; 
                              }
                              // Contains at least one uppercase letter 
                              else if (!value.contains(RegExp(r'[A-Z]'))) { 
                                return 'A palavra passe deve conter pelo menos uma letra maiúscula.'; 
                              } 
                              // Contains at least one lowercase letter 
                              else if (!value.contains(RegExp(r'[a-z]'))) { 
                                return 'A palavra passe deve conter pelo menos uma letra minúscula.'; 
                              } 
                              // Contains at least one digit 
                              else if (!value.contains(RegExp(r'[0-9]'))) { 
                                return 'A palavra passe deve conter pelo menos um número.'; 
                              } 
                              // Contains at least one special character 
                              else if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) { 
                                return 'A palavra passe deve conter pelo menos um caracter especial.'; 
                              }        
                              return null;              
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer 
                            ),
                            child: Text(
                              _isLogin 
                              ? 'Entrar' 
                              : 'Registar'
                            )
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                            ? 'Criar conta'
                            : 'Ja tenho uma conta'),
                          )
                        ],
                      ),
                    )
                  ),
                ),
               )
            ],
          )
        )
      ),
    );
  }
}