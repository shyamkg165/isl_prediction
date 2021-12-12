//import 'dart:io';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void ackAlert(BuildContext context, String errorCode, bool isLogin) {
  String errorType;
  String errorMessage;
  if (isLogin) {
    errorType = "Login Failed";
  } else {
    errorType = "Registration Failed";
  }
  if (errorCode == 'email-already-exists') {
    errorMessage =
        "Provided email already exists. Register with a different email Id";
  } else {
    errorMessage = errorCode;
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(errorType),
        content: Text(errorMessage),
        actions: [
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
