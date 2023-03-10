import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File userImageFile,
    bool isLogin,
    BuildContext ctx
  ) async {
    UserCredential authResponse;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResponse = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResponse = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        final ref = FirebaseStorage.instance.ref().child('user_image').child('${authResponse.user!.uid}.jpg');
        await ref.putFile(userImageFile);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(authResponse.user!.uid).set({
          'username': username,
          'email': email,
          'image_url': url,
        });

      }
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured, please check your credentials!';
      if (e.message != null) {
        message = e.message as String;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(message),
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
