import 'package:flutter/material.dart';

class PlatilloProvider with ChangeNotifier {
  String id = '';
  String nombre = '';
  String imagen = '';
  String descripcion = '';
  String categoria = '';

  get getId => id;

  set setId(id) {
    this.id = id;
    notifyListeners();
  }

  get getCategoria => categoria;

  set setCategoria(categoria) {
    this.categoria = categoria;
    notifyListeners();
  }

  get getNombre => nombre;

  set setNombre(nombre) {
    this.nombre = nombre;
    notifyListeners();
  }

  get getImagen => imagen;

  set setImagen(imagen) {
    this.imagen = imagen;
    notifyListeners();
  }

  get getDescripcion => descripcion;

  set setDescripcion(descripcion) {
    this.descripcion = descripcion;
    notifyListeners();
  }
}
