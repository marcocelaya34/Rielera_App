import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rielera_app/interfaces/infoNut.interface.dart';
import 'package:rielera_app/interfaces/masComprados.interface.dart';

import 'package:rielera_app/providers/carrito.provider.dart';
import 'package:rielera_app/providers/platillo.provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? nombre = _auth.currentUser?.displayName?.toUpperCase();

    Random random = Random();
    int randomNumber = random.nextInt(14) + 1;

    return Scaffold(
      body: Container(
          height: double.maxFinite,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff545454),
              Colors.black,
            ],
          )),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                titulos(nombre),
                const SizedBox(
                  height: 30,
                ),
                recomendaciones(),
                const SizedBox(
                  height: 30,
                ),
                masComprados(),
                const SizedBox(
                  height: 30,
                ),
                vanJuntos(),
                const SizedBox(
                  height: 30,
                ),
                tePuedeInteresar(),
                const SizedBox(
                  height: 30,
                ),
                otrosTambien(),
                const SizedBox(
                  height: 30,
                ),
                topRanking(randomNumber),
                const SizedBox(
                  height: 30,
                ),
                infoNutri('Grasas'),
                const SizedBox(
                  height: 140,
                ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'loginPage');
    } catch (e) {
      // ignore: avoid_print
      print('Error signing out. Try again.');
    }
  }

  List<Widget> itemsList(dynamic data, dynamic platillos) {
    List<Widget> items = [];

    List<dynamic> platillo = jsonDecode(platillos.body);

    if (data != null) {
      List<MasComprados> masComprados = data;

      for (var comprado in masComprados) {
        List<dynamic> imagen = platillo
            .where((element) =>
                element['Nombre_platillo'] == comprado.nombrePlatillo)
            .toList();

        List<dynamic> id = platillo
            .where((element) =>
                element['Nombre_platillo'] == comprado.nombrePlatillo)
            .toList();

        items.add(
          InkWell(
            onTap: () {
              final providerPlatillo =
                  Provider.of<PlatilloProvider>(context, listen: false);

              providerPlatillo.setId = id[0]['id_Platillo'].toString();
              providerPlatillo.setNombre = comprado.nombrePlatillo;
              providerPlatillo.setDescripcion = 'descripcion';
              providerPlatillo.setImagen = imagen[0]['Video_RA'];
              providerPlatillo.setCategoria = comprado.nombrePlatillo;

              Navigator.pushReplacementNamed(context, 'detallesProd');
            },
            child: Container(
              width: 300,
              padding: const EdgeInsets.only(left: 0, right: 5, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Flexible(
                      flex: 2,
                      child:
                          Center(child: Image.network(imagen[0]['Video_RA']))),
                  Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comprado.nombrePlatillo,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          const Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      }
    }

    return items;
  }

  List<Widget> itemsListRecomendaciones(dynamic data, dynamic platillos) {
    List<Widget> items = [];

    List<dynamic> recomendados = data;

    List<dynamic> platillo = jsonDecode(platillos.body);
    List<dynamic> acompaniamientos = [];
    for (var i = 0; i < recomendados.length; i++) {
      acompaniamientos.add(platillo
          .where(
              (element) => element['id_Platillo'].toString() == recomendados[i])
          .toList());
    }

    if (data != null) {
      for (var acompaniamiento in acompaniamientos) {
        items.add(
          InkWell(
            onTap: () {
              final providerPlatillo =
                  Provider.of<PlatilloProvider>(context, listen: false);

              providerPlatillo.setId =
                  acompaniamiento[0]['id_Platillo'].toString();
              providerPlatillo.setNombre =
                  acompaniamiento[0]['Nombre_platillo'];
              providerPlatillo.setDescripcion = 'descripcion';
              providerPlatillo.setImagen = acompaniamiento[0]['Video_RA'];
              providerPlatillo.setCategoria =
                  acompaniamiento[0]['id_Categoria'].toString();

              Navigator.pushReplacementNamed(context, 'detallesProd');
            },
            child: Container(
              width: 300,
              padding: const EdgeInsets.only(left: 0, right: 5, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Flexible(
                      flex: 2,
                      child: Center(
                          child:
                              Image.network(acompaniamiento[0]['Video_RA']))),
                  Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(acompaniamiento[0]['Nombre_platillo'],
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          const Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      }
    }

    return items;
  }

  List<Widget> itemsListVanJuntos(dynamic data, dynamic platillos) {
    List<Widget> items = [];
    List<List<String>> vanjuntosPareja = [];

    if (data != null) {
      List<dynamic> platillo = jsonDecode(platillos.body);
      List<dynamic> vanJuntos = jsonDecode(data.body);
      for (var juntos in vanJuntos) {
        String producto1 = juntos
            .split('->')[0]
            .replaceAll('{', '')
            .replaceAll('}', '')
            .split(',')[0]
            .replaceAll('\'', '')
            .trim();
        String producto2 = juntos
            .split('->')[1]
            .replaceAll('{', '')
            .replaceAll('}', '')
            .split(',')[0]
            .replaceAll('\'', '')
            .split(',')[0]
            .trim();

        List<String> secondCompare1 = [producto1, producto2];
        List<String> secondCompare2 = [producto2, producto1];
        bool comparacion1 = vanjuntosPareja
            .any((element) => listEquals(element, secondCompare1));
        bool comparacion2 = vanjuntosPareja
            .any((element) => listEquals(element, secondCompare2));
        if (!comparacion1 && !comparacion2) {
          vanjuntosPareja.add([producto1, producto2]);
          List<dynamic> imagen1 = platillo
              .where((element) => element['Nombre_platillo'] == producto1)
              .toList();
          List<dynamic> imagen2 = platillo
              .where((element) => element['Nombre_platillo'] == producto2)
              .toList();

          items.add(
            Container(
              width: 300,
              padding: const EdgeInsets.only(left: 0, right: 5, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Flexible(
                      flex: 2,
                      child:
                          Center(child: Image.network(imagen1[0]['Video_RA']))),
                  Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(producto1,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          const Divider(
                            thickness: 2,
                            color: Colors.black,
                          ),
                          Text(producto2,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                        ],
                      )),
                  Flexible(
                      flex: 2,
                      child:
                          Center(child: Image.network(imagen2[0]['Video_RA']))),
                ],
              ),
            ),
          );
        }
      }
    }

    return items;
  }

  List<Widget> itemsInfoNutri(List<InfoNutri> data, dynamic platillos) {
    List<Widget> items = [];

    List<dynamic> platillo = jsonDecode(platillos.body);
    List<dynamic> acompaniamientos = [];
    for (var i = 0; i < 4; i++) {
      acompaniamientos.add(platillo
          .where((element) => element['id_Platillo'] == data[i].id_Platillo)
          .toList());
    }

    if (data != null) {
      for (var acompaniamiento in acompaniamientos) {
        items.add(
          InkWell(
            onTap: () {
              final providerPlatillo =
                  Provider.of<PlatilloProvider>(context, listen: false);

              providerPlatillo.setId =
                  acompaniamiento[0]['id_Platillo'].toString();
              providerPlatillo.setNombre =
                  acompaniamiento[0]['Nombre_platillo'];
              providerPlatillo.setDescripcion = 'descripcion';
              providerPlatillo.setImagen = acompaniamiento[0]['Video_RA'];
              providerPlatillo.setCategoria =
                  acompaniamiento[0]['id_Categoria'].toString();

              Navigator.pushReplacementNamed(context, 'detallesProd');
            },
            child: Container(
              width: 300,
              padding: const EdgeInsets.only(left: 0, right: 5, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Flexible(
                      flex: 2,
                      child: Center(
                          child:
                              Image.network(acompaniamiento[0]['Video_RA']))),
                  Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(acompaniamiento[0]['Nombre_platillo'],
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          const Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      }
    }

    return items;
  }

  List<Widget> itemsTePuedeInteresar(dynamic data, dynamic platillos) {
    List<Widget> items = [];

    var json = jsonDecode(data.body);
    List<dynamic> recomendados = json['data'];

    List<dynamic> platillo = jsonDecode(platillos.body);
    List<dynamic> acompaniamientos = [];
    for (var i = 0; i < recomendados.length; i++) {
      acompaniamientos.add(platillo
          .where((element) => element['id_Platillo'] == recomendados[i])
          .toList());
    }

    if (data != null) {
      for (var acompaniamiento in acompaniamientos) {
        items.add(
          InkWell(
            onTap: () {
              final providerPlatillo =
                  Provider.of<PlatilloProvider>(context, listen: false);

              providerPlatillo.setId =
                  acompaniamiento[0]['id_Platillo'].toString();
              providerPlatillo.setNombre =
                  acompaniamiento[0]['Nombre_platillo'];
              providerPlatillo.setDescripcion = 'descripcion';
              providerPlatillo.setImagen = acompaniamiento[0]['Video_RA'];
              providerPlatillo.setCategoria =
                  acompaniamiento[0]['id_Categoria'].toString();

              Navigator.pushReplacementNamed(context, 'detallesProd');
            },
            child: Container(
              width: 300,
              padding: const EdgeInsets.only(left: 0, right: 5, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Flexible(
                      flex: 2,
                      child: Center(
                          child:
                              Image.network(acompaniamiento[0]['Video_RA']))),
                  Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(acompaniamiento[0]['Nombre_platillo'],
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          const Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      }
    }

    return items;
  }

  List<Widget> itemsOtrosTambien(dynamic data, dynamic platillos) {
    List<Widget> items = [];

    var json = jsonDecode(data.body);
    List<dynamic> recomendados = json['data'];

    List<dynamic> platillo = jsonDecode(platillos.body);
    List<dynamic> acompaniamientos = [];
    for (var i = 0; i < recomendados.length; i++) {
      acompaniamientos.add(platillo
          .where((element) => element['id_Platillo'] == recomendados[i][0])
          .toList());
    }

    if (data != null) {
      for (var acompaniamiento in acompaniamientos) {
        items.add(
          InkWell(
            onTap: () {
              final providerPlatillo =
                  Provider.of<PlatilloProvider>(context, listen: false);

              providerPlatillo.setId =
                  acompaniamiento[0]['id_Platillo'].toString();
              providerPlatillo.setNombre =
                  acompaniamiento[0]['Nombre_platillo'];
              providerPlatillo.setDescripcion = 'descripcion';
              providerPlatillo.setImagen = acompaniamiento[0]['Video_RA'];
              providerPlatillo.setCategoria =
                  acompaniamiento[0]['id_Categoria'].toString();

              Navigator.pushReplacementNamed(context, 'detallesProd');
            },
            child: Container(
              width: 300,
              padding: const EdgeInsets.only(left: 0, right: 5, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Flexible(
                      flex: 2,
                      child: Center(
                          child:
                              Image.network(acompaniamiento[0]['Video_RA']))),
                  Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(acompaniamiento[0]['Nombre_platillo'],
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          const Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      }
    }

    return items;
  }

  List<Widget> itemsTopRanking(dynamic data, dynamic platillos) {
    List<Widget> items = [];

    List<dynamic> recomendados = jsonDecode(data.body);

    List<dynamic> platillo = jsonDecode(platillos.body);
    List<dynamic> acompaniamientos = [];
    for (var i = 0; i < recomendados.length; i++) {
      acompaniamientos.add(platillo
          .where((element) => element['Nombre_platillo'] == recomendados[i][0])
          .toList());
    }

    if (data != null && acompaniamientos.isNotEmpty) {
      for (var acompaniamiento in acompaniamientos) {
        items.add(
          InkWell(
            onTap: () {
              final providerPlatillo =
                  Provider.of<PlatilloProvider>(context, listen: false);

              providerPlatillo.setId =
                  acompaniamiento[0]['id_Platillo'].toString();
              providerPlatillo.setNombre =
                  acompaniamiento[0]['Nombre_platillo'];
              providerPlatillo.setDescripcion = 'descripcion';
              providerPlatillo.setImagen = acompaniamiento[0]['Video_RA'];
              providerPlatillo.setCategoria =
                  acompaniamiento[0]['id_Categoria'].toString();

              Navigator.pushReplacementNamed(context, 'detallesProd');
            },
            child: Container(
              width: 300,
              padding: const EdgeInsets.only(left: 0, right: 5, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Flexible(
                      flex: 2,
                      child: Center(
                          child:
                              Image.network(acompaniamiento[0]['Video_RA']))),
                  Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(acompaniamiento[0]['Nombre_platillo'],
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          const Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      }
    }

    return items;
  }

  Widget otrosTambien() {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A OTROS COMO T??, LES GUST??',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 16)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fetchOtrosTambien(context),
          initialData: 'waiting',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != 'waiting') {
              if (snapshot.data != null) {
                if (snapshot.data.body !=
                    'Usuario sin informaci??n suficiente') {
                  return FutureBuilder(
                    future: fetchPlatillos(),
                    initialData: 'waiting',
                    builder: (BuildContext context, AsyncSnapshot snapshot2) {
                      if (snapshot2.data != 'waiting') {
                        if (snapshot2.data != null) {
                          return CarouselSlider(
                              items: itemsOtrosTambien(
                                  snapshot.data, snapshot2.data),
                              options: CarouselOptions(
                                  height: 110,
                                  aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                                  viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                                  initialPage: 0,
                                  enableInfiniteScroll: false,
                                  reverse: false,
                                  autoPlay: false,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 1000),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {},
                                  scrollDirection: Axis.horizontal,
                                  disableCenter: true));
                        } else {
                          return Center(
                            child: Text('Uppss, el servidor se cayo',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15)),
                          );
                        }
                      } else {
                        return Center(child: loaderRecomendacion());
                      }
                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 38.0, vertical: 20),
                    child: Center(
                      child: Text(
                          'Estamos recabando datos, para ofrecerte una recomendaci??n',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 15)),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text('Uppss, el servidor se cayo',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15)),
                );
              }
            } else {
              return loaderRecomendacion();
            }
          },
        )
      ],
    );
  }

  Widget tePuedeInteresar() {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TE PUEDE INTERESAR',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 16)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fetchTePuedeInteresar(context),
          initialData: 'waiting',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != 'waiting') {
              if (snapshot.data != null) {
                if (snapshot.data.body !=
                    '{"columns":[],"index":[],"data":[]}') {
                  if (!snapshot.data.body
                      .toString()
                      .contains('<!DOCTYPE HTML PUBLIC')) {
                    return FutureBuilder(
                      future: fetchPlatillos(),
                      initialData: 'waiting',
                      builder: (BuildContext context, AsyncSnapshot snapshot2) {
                        if (snapshot2.data != 'waiting') {
                          if (snapshot2.data != null) {
                            return CarouselSlider(
                                items: itemsTePuedeInteresar(
                                    snapshot.data, snapshot2.data),
                                options: CarouselOptions(
                                    height: 110,
                                    aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                                    viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: false,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 1000),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, reason) {},
                                    scrollDirection: Axis.horizontal,
                                    disableCenter: true));
                          } else {
                            return Center(
                              child: Text('Uppss, el servidor se cayo',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15)),
                            );
                          }
                        } else {
                          return loaderRecomendacion();
                        }
                      },
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 38.0, vertical: 20),
                      child: Center(
                        child: Text('Trayendo info del servidor',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 15)),
                      ),
                    );
                  }
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 38.0, vertical: 20),
                    child: Center(
                      child: Text(
                          'Estamos recabando datos, para ofrecerte una recomendaci??n',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 15)),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text('Uppss, el servidor se cayo',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15)),
                );
              }
            } else {
              return loaderRecomendacion();
            }
          },
        )
      ],
    );
  }

  Widget topRanking(int randomNumber) {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;
    return Column(
      children: [
        FutureBuilder(
          future: fetchTopRanking(randomNumber),
          initialData: 'waiting',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != 'waiting') {
              if (snapshot.data != null) {
                if (snapshot.data.body == '[]') {
                  return const SizedBox();
                } else {
                  return FutureBuilder(
                    future: fetchPlatillos(),
                    initialData: 'waiting',
                    builder: (BuildContext context, AsyncSnapshot snapshot2) {
                      if (snapshot2.data != 'waiting') {
                        if (snapshot2.data != null) {
                          return Column(
                            children: [
                              FutureBuilder(
                                future: getCategoriaRndom(randomNumber),
                                initialData: 'waiting',
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.data == 'waiting') {
                                    return const SizedBox();
                                  } else {
                                    return Container(
                                      padding: const EdgeInsets.only(left: 30),
                                      alignment: Alignment.centerLeft,
                                      width: double.maxFinite,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'TOP RANKING DE ${snapshot.data}',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 16)),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                              CarouselSlider(
                                  items: itemsTopRanking(
                                      snapshot.data, snapshot2.data),
                                  options: CarouselOptions(
                                      height: 110,
                                      aspectRatio:
                                          ancho < 1000 ? 16 / 9 : 4 / 3,
                                      viewportFraction:
                                          ancho < 1000 ? 0.8 : 0.4,
                                      initialPage: 0,
                                      enableInfiniteScroll: false,
                                      reverse: false,
                                      autoPlay: false,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 1000),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      onPageChanged: (index, reason) {},
                                      scrollDirection: Axis.horizontal,
                                      disableCenter: true)),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text('Uppss, el servidor se cayo',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15)),
                          );
                        }
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                }
              } else {
                return Center(
                  child: Text('Uppss, el servidor se cayo',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15)),
                );
              }
            } else {
              return const SizedBox();
            }
          },
        )
      ],
    );
  }

  Widget vanJuntos() {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(left: 30),
        alignment: Alignment.centerLeft,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('VAN JUNTOS',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontSize: 16)),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      FutureBuilder(
        future: fetchVanJuntos(context),
        initialData: 'waiting',
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != 'waiting') {
            if (snapshot.data != null) {
              if (snapshot.data.body != "[]") {
                return FutureBuilder(
                  future: fetchPlatillos(),
                  initialData: 'waiting',
                  builder: (BuildContext context, AsyncSnapshot snapshot2) {
                    if (snapshot2.data != 'waiting') {
                      if (snapshot2.data != null) {
                        return CarouselSlider(
                            items: itemsListVanJuntos(
                                snapshot.data, snapshot2.data),
                            options: CarouselOptions(
                                height: 110,
                                aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                                viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlay: false,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1000),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {},
                                scrollDirection: Axis.horizontal,
                                disableCenter: true));
                      } else {
                        return Center(
                          child: Text('Uppss, el servidor se cayo',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15)),
                        );
                      }
                    } else {
                      return loaderRecomendacion();
                    }
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 38.0, vertical: 20),
                  child: Center(
                    child: Text(
                        'Estamos recabando datos, para ofrecerte una recomendaci??n',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 15)),
                  ),
                );
              }
            } else {
              return Center(
                child: Text('Uppss, el servidor se cayo',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15)),
              );
            }
          } else {
            return loaderRecomendacion();
          }
        },
      ),
    ]);
  }

  Widget masComprados() {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('M??S COMPRADOS',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 16)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fetchMasComprados(),
          initialData: 'waiting',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == 'waiting') {
              return loaderRecomendacion();
            } else if (snapshot.data != null) {
              return FutureBuilder(
                future: fetchPlatillos(),
                initialData: 'waiting',
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  if (snapshot2.data != 'waiting') {
                    if (snapshot2.data != null) {
                      return CarouselSlider(
                          items: itemsList(snapshot.data, snapshot2.data),
                          options: CarouselOptions(
                              height: 110,
                              aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                              viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {},
                              scrollDirection: Axis.horizontal,
                              disableCenter: true));
                    } else {
                      return Center(
                        child: Text('Uppss, el servidor se cayo',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 15)),
                      );
                    }
                  } else {
                    return loaderRecomendacion();
                  }
                },
              );
            } else {
              return Center(
                child: Text('Uppss, el servidor se cayo',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15)),
              );
            }
          },
        ),
      ],
    );
  }

  Widget infoNutri(String tipo) {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CON MENOS ${tipo.toUpperCase()}',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 16)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fetchInfoNutri(tipo),
          initialData: 'waiting',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == 'waiting') {
              return loaderRecomendacion();
            } else if (snapshot.data != null) {
              return FutureBuilder(
                future: fetchPlatillos(),
                initialData: 'waiting',
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  if (snapshot2.data != 'waiting') {
                    if (snapshot2.data != null) {
                      return CarouselSlider(
                          items: itemsInfoNutri(snapshot.data, snapshot2.data),
                          options: CarouselOptions(
                              height: 110,
                              aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                              viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {},
                              scrollDirection: Axis.horizontal,
                              disableCenter: true));
                    } else {
                      return Center(
                        child: Text('Uppss, el servidor se cayo',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 15)),
                      );
                    }
                  } else {
                    return loaderRecomendacion();
                  }
                },
              );
            } else {
              return Center(
                child: Text('Uppss, el servidor se cayo',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15)),
              );
            }
          },
        ),
      ],
    );
  }

  Widget recomendaciones() {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RECOMENDACIONES',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 16)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fetchRecomendados(context),
          initialData: 'waiting',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != 'waiting') {
              if (snapshot.data != null) {
                return FutureBuilder(
                  future: fetchPlatillos(),
                  initialData: 'waiting',
                  builder: (BuildContext context, AsyncSnapshot snapshot2) {
                    if (snapshot2.data != 'waiting' && snapshot2.data != null) {
                      return CarouselSlider(
                          items: itemsListRecomendaciones(
                              snapshot.data, snapshot2.data),
                          options: CarouselOptions(
                              height: 110,
                              aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                              viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {},
                              scrollDirection: Axis.horizontal,
                              disableCenter: true));
                    } else {
                      return loaderRecomendacion();
                    }
                  },
                );
              } else {
                return Center(
                  child: Text('Uppss, el servidor se cayo',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15)),
                );
              }
            } else {
              return loaderRecomendacion();
            }
          },
        ),
      ],
    );
  }

  Widget titulos(String? nombre) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BIENVENID@',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: 30)),
                Text(nombre!.split(' ')[0] + nombre.split(' ')[1],
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: 30)),
                Row(
                  children: [
                    Text('A LA',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontSize: 30)),
                    Text(' RIELERITA !',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 30)),
                  ],
                )
              ],
            ),
            InkWell(
              onTap: () async {
                final providerCarrito =
                    Provider.of<CarritoProvider>(context, listen: false);
                List<Map<String, dynamic>> clear = [];
                providerCarrito.setArticulos = clear;

                await signOut(context: context);
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/logout.png',
                  scale: 19,
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Future<String> getCategoriaRndom(int randomNumber) async {
    final response = await fetchCategorias(context);

    List<dynamic> json = jsonDecode(response.body);
    String recomendados = json[randomNumber - 1]['Nombre_categoria'];

    return recomendados.toUpperCase();
  }

  List<Widget> itemsLoader() {
    List<Widget> card = [];

    for (var i = 0; i < 5; i++) {
      card.add(Container(
        width: 300,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Center(
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(bottom: 5, left: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(top: 5, left: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ));
    }

    return card;
  }

  Widget loaderRecomendacion() {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;

    return CarouselSlider(
        items: itemsLoader(),
        options: CarouselOptions(
            height: 110,
            aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
            viewportFraction: ancho < 1000 ? 0.8 : 0.4,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {},
            scrollDirection: Axis.horizontal,
            disableCenter: true));
  }

  Future<http.Response> fetchCategorias(BuildContext context) {
    return http.get(
      Uri.parse('https://luisrojas24.pythonanywhere.com/get-categorias'),
    );
  }

  Future<http.Response> fetchVanJuntos(BuildContext context) {
    return http.get(
      Uri.parse('https://luisrojas24.pythonanywhere.com/get-reglas'),
    );
  }

  Future<http.Response> fetchTePuedeInteresar(BuildContext context) {
    String? id = _auth.currentUser?.uid;
    return http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/rec_content_based?id_Usuario=$id'),
    );
  }

  Future<http.Response> fetchTopRanking(randomNumber) {
    return http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/get-rankings?id_categoria=$randomNumber'),
    );
  }

  Future<http.Response> fetchOtrosTambien(randomNumber) {
    String? id = _auth.currentUser?.uid;
    return http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/rec_colab_item?id_Usuario=$id'),
    );
  }

  Future<dynamic> fetchMasComprados() async {
    List<MasComprados> posts = [];

    for (var i = 1; i < 15; i++) {
      http.Response request = await http.get(
        Uri.parse(
            'https://luisrojas24.pythonanywhere.com/get-mas_pedidos?tiempo=30&id_categoria=$i'),
      );

      Iterable l = json.decode(request.body);

      posts.addAll(l.map((model) => MasComprados.fromJson(model)));
    }

    return posts;
  }

  Future<dynamic> fetchInfoNutri(String tipo) async {
    List<InfoNutri> posts = [];

    http.Response request = await http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/get-platillos_saludables?Etiqueta=$tipo'),
    );

    Iterable l = json.decode(request.body);

    posts.addAll(l.map((model) => InfoNutri.fromJson(model)));

    return posts;
  }

  Future<http.Response> fetchPlatillos() {
    return http.get(
      Uri.parse('https://luisrojas24.pythonanywhere.com/get-platillos'),
    );
  }

  Future<List<dynamic>> fetchRecomendados(BuildContext context) async {
    final providerCarrito =
        Provider.of<CarritoProvider>(context, listen: false);
    List<dynamic> posts = [];
    List<dynamic> articulos = providerCarrito.getArticulos;
    if (articulos.isNotEmpty) {
      posts = await platillosRecomendados(posts, articulos.length, articulos);

      return posts;
    } else {
      http.Response request = await http.get(
        Uri.parse(
            'https://luisrojas24.pythonanywhere.com/get-asociaciones?id_platillo=2'),
      );

      Iterable l = json.decode(request.body);

      var acompaniamiento = l.first
          .toString()
          .split(',')[1]
          .split(':')[1]
          .trim()
          .replaceAll('.0', '');

      posts.contains(acompaniamiento) ? null : posts.add(acompaniamiento);

      return posts;
    }
  }

  Future<List> platillosRecomendados(
      List posts, int length, List<dynamic> articulos) async {
    for (var i = 0; i < length; i++) {
      var request = await http.get(
        Uri.parse(
            'https://luisrojas24.pythonanywhere.com/get-asociaciones?id_platillo=${articulos[i]['id']}'),
      );

      if (!request.body.contains('<!DOCTYPE HTML')) {
        List<dynamic> l = json.decode(request.body);

        //Primero 2 PLatillos Recomendados

        if (l.length > 2) {
          for (var i = 0; i < 2; i++) {
            var acompaniamiento = l[i]
                .toString()
                .split(',')[1]
                .split(':')[1]
                .trim()
                .replaceAll('.0', '');

            var nombreArticulos = articulos.map((e) => e['id']);

            if (!nombreArticulos.contains(acompaniamiento)) {
              posts.contains(acompaniamiento)
                  ? null
                  : posts.add(acompaniamiento);
            }
          }
        }
      }
    }
    if (posts.isEmpty) {
      return [1];
    } else {
      return posts;
    }
  }

  nutriCategoria(String s) {}
}
