import 'dart:io';

import 'package:chat_app_firebase/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  // ignore: unused_field
  var _email = '';
  // ignore: unused_field
  var _password = '';
  var _name = '';
  var _isLoading = false;
  File? _selectedImgae;
  void _submit() async {
    if (!_formKey.currentState!.validate() ||
        !_isLogin && _selectedImgae == null) {
      // show some error message in future
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_isLogin) {
      // login logic
      print('Logging in $_email   $_password');
      var res = await _firebase.signInWithEmailAndPassword(
          email: _email, password: _password);
      print("Login res: $res");
    } else {
      try {
        final res = await _firebase.createUserWithEmailAndPassword(
            email: _email, password: _password);

        final storageRef = await FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${res.user!.uid}.jpg');

        await storageRef.putFile(_selectedImgae!);

        final imageUrl = await storageRef.getDownloadURL();
        print('imageUrl--------------: $imageUrl');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(res.user!.uid)
            .set({'name': _name, 'email': _email, 'image_url': imageUrl});

        // ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showMaterialBanner(
            const SnackBar(content: Text("Signup success")) as MaterialBanner);
      } on FirebaseAuthException catch (error) {
        setState(() {
          _isLoading = false;
        });
        print("Error $error");
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showMaterialBanner(
            SnackBar(content: Text(error.message!)) as MaterialBanner);
      }
      // signup logic
    }
    setState(() {
      _isLoading = false;
    });

    // print('Form data: $_email       $_password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
              margin: const EdgeInsets.all(25),
              width: 150,
              child: Image.asset(
                "assets/images/icon.jpg",
                fit: BoxFit.cover,
                // scale: 255,

                // opacity:Animation<47> ,
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              _selectedImgae = pickedImage;
                            },
                          ),
                        if (!_isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Name"),
                            ),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().length < 4) {
                                return "please enter a valid name.";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _name = newValue!;
                            },
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Email Address"),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@') ||
                                !value.contains('.')) {
                              return "please enter a valid email address.";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _email = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 6) {
                              return "please enter a valid password.";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Password"),
                          ),
                          obscureText: true,
                          onSaved: (newValue) {
                            _password = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (!_isLoading)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size.fromWidth(350),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: Text(_isLogin ? 'Login' : "Sign up"),
                          ),
                        if (!_isLoading)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create an account'
                                : 'Already have an account.?'),
                          ),
                        if (_isLoading)
                          CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

mixin message {}
