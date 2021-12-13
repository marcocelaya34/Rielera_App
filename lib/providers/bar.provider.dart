import 'package:flutter/material.dart';

class BarProvider with ChangeNotifier {
  int posicion = 1;
  PageController _pageController = PageController(initialPage: 1);

  PageController get getpageController => _pageController;

  setpageController(PageController value) {
    _pageController = value;
    notifyListeners();
  }

  int get getPosicion => posicion;

  setPosicion(int posicion) {
    this.posicion = posicion;
    notifyListeners();
  }
}
