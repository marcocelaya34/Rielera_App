import 'package:flutter/material.dart';

class BarProvider with ChangeNotifier {
  int posicion = 1;
  PageController _pageController = PageController(initialPage: 1);

  PageController get getpageController => this._pageController;

  setpageController(PageController value) {
    this._pageController = value;
    notifyListeners();
  }

  int get getPosicion => this.posicion;

  setPosicion(int posicion) {
    this.posicion = posicion;
    notifyListeners();
  }
}
