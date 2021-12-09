import 'package:flutter/material.dart';

class PlatilloProvider with ChangeNotifier {
  String id = '';
  String nombre = '';
  String imagen = '';
  String descripcion = '';
  String categoria = '';

  get getId => this.id;

  set setId(id) {
    this.id = id;
    notifyListeners();
  }

  get getCategoria => this.categoria;

  set setCategoria(categoria) {
    this.categoria = categoria;
    notifyListeners();
  }

  get getNombre => this.nombre;

  set setNombre(nombre) {
    this.nombre = nombre;
    notifyListeners();
  }

  get getImagen => this.imagen;

  set setImagen(imagen) {
    this.imagen = imagen;
    notifyListeners();
  }

  get getDescripcion => this.descripcion;

  set setDescripcion(descripcion) {
    this.descripcion = descripcion;
    notifyListeners();
  }
}
