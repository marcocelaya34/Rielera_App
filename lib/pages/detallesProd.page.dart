import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:rielera_app/providers/carrito.provider.dart';
import 'package:rielera_app/providers/bar.provider.dart';
import 'package:rielera_app/providers/platillo.provider.dart';

import 'package:url_launcher/url_launcher.dart';

class DetallesProdPage extends StatefulWidget {
  const DetallesProdPage({Key? key}) : super(key: key);

  @override
  _DetallesProdPageState createState() => _DetallesProdPageState();
}

class _DetallesProdPageState extends State<DetallesProdPage> {
  int cantidad = 1;
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;
  String calificacion = '';

  String id = '';
  String nombre = '';
  String imagen = '';
  String descripcion = '';
  var categoria = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    star1 = false;
    star2 = false;
    star3 = false;
    star4 = false;
    star5 = false;

    final providerPlatillo = Provider.of<PlatilloProvider>(context);
    String? idUser = _auth.currentUser?.uid;

    id = providerPlatillo.getId;
    nombre = providerPlatillo.getNombre;
    descripcion = providerPlatillo.getDescripcion;
    imagen = providerPlatillo.getImagen;
    categoria = providerPlatillo.getCategoria;

    MediaQueryData queryData = MediaQuery.of(context);
    double alto = queryData.size.height;
    double ancho = queryData.size.width;
    final providerBar = Provider.of<BarProvider>(context);

    Future<bool> _onWillPop() async {
      providerBar.setpageController(PageController(initialPage: 3));
      Navigator.pushReplacementNamed(context, 'bottomBar');
      return true;
    }

    agregarRevisado(id);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          height: alto,
          width: ancho,
          color: Colors.amber,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: alto * 0.35,
                    padding: const EdgeInsets.only(top: 30),
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xff545454),
                        Colors.black,
                      ],
                    )),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.center,
                                child: Image.network(imagen,
                                    alignment: Alignment.center,
                                    fit: BoxFit.fitWidth,
                                    height: 130))),
                        Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ancho > 760
                                      ? Text(nombre,
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 55))
                                      : Text(nombre,
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30)),
                                  const Divider(
                                    color: Colors.white,
                                    indent: 80,
                                    thickness: 3,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  ancho > 760
                                      ? Center(
                                          child: Text('MXN\$20',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 45)),
                                        )
                                      : Center(
                                          child: Text('MXN\$20',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 25)),
                                        ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: alto * 0.70,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text('INGREDIENTES',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 20, bottom: 10),
                            child: FutureBuilder(
                              future: fetchIngredientes(id),
                              initialData: 'waiting',
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data != 'waiting') {
                                  List<dynamic> ingrediente =
                                      jsonDecode(snapshot.data.body);

                                  String descripcion = '';

                                  ingrediente.map((e) {
                                    if (descripcion == '') {
                                      descripcion = e['Nombre_ingrediente'];
                                    } else {
                                      descripcion = descripcion +
                                          ', ' +
                                          e['Nombre_ingrediente'];
                                    }
                                  }).toList();
                                  return Text(descripcion,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17));
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                          FutureBuilder(
                            future: fetchisCalificado(idUser!, id),
                            initialData: 'waiting',
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data != 'waiting') {
                                return estrellas(snapshot.data.body);
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.maxFinite,
                            height: 60,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, 'infoNutri');
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: Text('INFORMACIÓN NUTRICIONAL',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15)),
                                  ),
                                  const Flexible(
                                      flex: 1,
                                      child: Icon(LineIcons.arrowRight))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text('CANTIDAD',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22)),
                          ),
                          StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (cantidad > 1) {
                                                cantidad = cantidad - 1;
                                              }
                                            });
                                          },
                                          child: Image.asset(
                                              'assets/BotonMas.png'))),
                                  Flexible(
                                      flex: 1,
                                      child: Text('$cantidad',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 40))),
                                  Flexible(
                                      flex: 1,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (cantidad < 10) {
                                                cantidad = cantidad + 1;
                                              }
                                            });
                                          },
                                          child: Image.asset(
                                              'assets/BotonMenos.png'))),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              Provider.of<BarProvider>(context, listen: false);

                              final providerCarrito =
                                  Provider.of<CarritoProvider>(context,
                                      listen: false);
                              List<dynamic> articulos =
                                  providerCarrito.getArticulos;
                              articulos.add({
                                'id': id,
                                'nombre': nombre,
                                'imagen': imagen,
                                'descripcion': descripcion,
                                'categoria': categoria,
                                'cantidad': cantidad
                              });
                              providerCarrito.setArticulos = articulos;

                              agregarCalificacion(id);
                              Navigator.pushReplacementNamed(
                                  context, 'bottomBar');
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 50,
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text('AGREGAR A CARRITO',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  bottom: alto * 0.65,
                  right: 15,
                  child: SizedBox(
                    height: 80,
                    child: InkWell(
                        onTap: () async {
                          await launch(
                            'https://ra-gif.web.app/$nombre.html',
                            forceSafariVC: false,
                            forceWebView: false,
                            headers: <String, String>{
                              'my_header_key': 'my_header_value'
                            },
                          );
                        },
                        child: Image.asset('assets/BotonRA.png')),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget estrellas(String opcion) {
    MediaQueryData queryData = MediaQuery.of(context);

    if (opcion == '-1') {
      star1 = false;
      star2 = false;
      star3 = false;
      star4 = false;
      star5 = false;
    } else {
      switch (opcion) {
        case '1':
          star1 = true;
          star2 = false;
          star3 = false;
          star4 = false;
          star5 = false;
          break;
        case '2':
          star1 = true;
          star2 = true;
          star3 = false;
          star4 = false;
          star5 = false;
          break;
        case '3':
          star1 = true;
          star2 = true;
          star3 = true;
          star4 = false;
          star5 = false;
          break;
        case '4':
          star1 = true;
          star2 = true;
          star3 = true;
          star4 = true;
          star5 = false;
          break;
        case '5':
          star1 = true;
          star2 = true;
          star3 = true;
          star4 = true;
          star5 = true;
          break;
      }
    }

    double ancho = queryData.size.width;
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        if (ancho > 760) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = false;
                          star3 = false;
                          star4 = false;
                          star5 = false;

                          calificacion = '1';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star1
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = true;
                          star3 = false;
                          star4 = false;
                          star5 = false;
                          calificacion = '2';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star2
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = true;
                          star3 = true;
                          star4 = false;
                          star5 = false;
                          calificacion = '3';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star3
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = true;
                          star3 = true;
                          star4 = true;
                          star5 = false;
                          calificacion = '4';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star4
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = true;
                          star3 = true;
                          star4 = true;
                          star5 = true;
                          calificacion = '5';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star5
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = false;
                          star3 = false;
                          star4 = false;
                          star5 = false;

                          calificacion = '1';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star1
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = true;
                          star3 = false;
                          star4 = false;
                          star5 = false;
                          calificacion = '2';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star2
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = true;
                          star3 = true;
                          star4 = false;
                          star5 = false;
                          calificacion = '3';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star3
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = true;
                          star3 = true;
                          star4 = true;
                          star5 = false;
                          calificacion = '4';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star4
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (opcion == '-1') {
                          star1 = true;
                          star2 = true;
                          star3 = true;
                          star4 = true;
                          star5 = true;
                          calificacion = '5';
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: star5
                            ? Image.asset('assets/star_fill2.png')
                            : Image.asset('assets/star2.png'),
                      ),
                    )),
              ],
            ),
          );
        }
      },
    );
  }

  Future<http.Response> fetchIngredientes(String id) {
    return http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/get-ingredientes_platillo?id_Platillo=$id'),
    );
  }

  Future<http.Response> fetchCalificacion(
      String idUser, String idPlatillo, String calificacion) {
    return http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/set-ranking?id_Usuario=$idUser&id_Platillo=$idPlatillo&ranking=$calificacion'),
    );
  }

  Future<http.Response> fetchisCalificado(String idUser, String idPlatillo) {
    return http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/ranking-usr?id_Usuario=$idUser&id_Platillo=$idPlatillo'),
    );
  }

  Future<http.Response> fetchRevisado(
      String idUser, String idPlatillo, String calificacion) {
    return http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/set-revisado?id_Usuario=$idUser&id_Platillo=$idPlatillo'),
    );
  }

  Future agregarCalificacion(String idPlatillo) async {
    String? idUser = _auth.currentUser?.uid;
    var response = await fetchCalificacion(idUser!, idPlatillo, calificacion);
    return response;
  }

  Future agregarRevisado(String idPlatillo) async {
    String? idUser = _auth.currentUser?.uid;
    var response = await fetchRevisado(idUser!, idPlatillo, calificacion);
    return response;
  }
}
