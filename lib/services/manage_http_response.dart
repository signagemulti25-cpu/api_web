import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response, // Http Response from the requiset

  required BuildContext context, //the context to show snackbar
  required VoidCallback
  onSuccess, // the callback to execute on  sucessful response
}) {
  //swtich stment to handle diffenerent https status code
  switch (response.statusCode) {
    case 200:
      onSuccess();
      // print("Success");
      break;
    case 400:
      // print("Bad Request");
      showSnackBar(context, json.decode(response.body)['msg']);
      break;
    case 500: //show indicates server error
      showSnackBar(context, json.decode(response.body)['error']);
      break;
    case 201: //show indicates resource was creeate sucess
      onSuccess();
       break;
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}






//  switch (response.statusCode) {
//     case 200:
//       onSuccess();
//       print("Success");
//       break;

//     case 201:
//       print("Created");
//       break;

//     case 400:
//       print("Bad Request");
//       break;

//     case 401:
//       print("Unauthorized");
//       break;

//     case 403:
//       print("Forbidden");
//       break;

//     case 404:
//       print("Not Found");
//       break;

//     case 500:
//       print("Server Error");
//       break;

//     default:
//       print("Unknown Error: ${response.statusCode}");
//   }