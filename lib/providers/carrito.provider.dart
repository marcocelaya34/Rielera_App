import 'package:flutter/material.dart';

class CarritoProvider with ChangeNotifier {
  List<Map<String, dynamic>> articulos = [];

  get getArticulos => articulos;

  set setArticulos(articulos) {
    this.articulos = articulos;
    notifyListeners();
  }
}
