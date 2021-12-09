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
import 'package:rielera_app/interfaces/masComprados.interface.dart';
import 'package:rielera_app/interfaces/recomendados.interface.dart';
import 'package:rielera_app/providers/carritoProvider.dart';
import 'package:rielera_app/providers/platilloProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? nombre = _auth.currentUser?.displayName?.toUpperCase();
    Random random = new Random();
    int randomNumber = random.nextInt(14) + 1;

    return Scaffold(
      body: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
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
                SizedBox(
                  height: 60,
                ),
                titulos(nombre),
                SizedBox(
                  height: 30,
                ),
                recomendaciones(),
                SizedBox(
                  height: 30,
                ),
                masComprados(),
                SizedBox(
                  height: 30,
                ),
                vanJuntos(),
                SizedBox(
                  height: 30,
                ),
                tePuedeInteresar(),
                SizedBox(
                  height: 30,
                ),
                otrosTambien(),
                SizedBox(
                  height: 30,
                ),
                topRanking(randomNumber),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 100,
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
              padding: EdgeInsets.only(left: 0, right: 5, top: 10),
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
                          Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                          Text('Descripcion',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12))
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
              padding: EdgeInsets.only(left: 0, right: 5, top: 10),
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
                          Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                          Text('Descripcion',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12))
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

    if (data != null) {
      List<dynamic> platillo = jsonDecode(platillos.body);
      List<dynamic> vanJuntos = jsonDecode(data.body);
      for (var juntos in vanJuntos) {
        String producto1 = juntos
            .split('->')[0]
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll('\'', '')
            .trim();
        String producto2 = juntos
            .split('->')[1]
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll('\'', '')
            .split(',')[0]
            .trim();

        List<dynamic> imagen1 = platillo
            .where((element) => element['Nombre_platillo'] == producto1)
            .toList();
        List<dynamic> imagen2 = platillo
            .where((element) => element['Nombre_platillo'] == producto2)
            .toList();

        items.add(
          Container(
            width: 300,
            padding: EdgeInsets.only(left: 0, right: 5, top: 10),
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
                        Divider(
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
              padding: EdgeInsets.only(left: 0, right: 5, top: 10),
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
                          Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                          Text('Descripcion',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12))
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
              padding: EdgeInsets.only(left: 0, right: 5, top: 10),
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
                          Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                          Text('Descripcion',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12))
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
              padding: EdgeInsets.only(left: 0, right: 5, top: 10),
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
                          Divider(
                            endIndent: 50,
                            thickness: 2,
                            color: Colors.black,
                          ),
                          Text('Descripcion',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12))
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
          padding: EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A OTROS TAMBIÉN LES GUSTÓ',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 16)),
              SizedBox(
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
              return FutureBuilder(
                future: fetchPlatillos(),
                initialData: 'waiting',
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  if (snapshot2.data != 'waiting') {
                    return CarouselSlider(
                        items: itemsOtrosTambien(snapshot.data, snapshot2.data),
                        options: CarouselOptions(
                            height: 110,
                            aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                            viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            reverse: false,
                            autoPlay: false,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                            disableCenter: true));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
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
          padding: EdgeInsets.only(left: 30),
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
              SizedBox(
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
              return FutureBuilder(
                future: fetchPlatillos(),
                initialData: 'waiting',
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  if (snapshot2.data != 'waiting') {
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
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                            disableCenter: true));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
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
              if (snapshot.data.body == '[]') {
                return SizedBox();
              } else {
                return FutureBuilder(
                  future: fetchPlatillos(),
                  initialData: 'waiting',
                  builder: (BuildContext context, AsyncSnapshot snapshot2) {
                    if (snapshot2.data != 'waiting') {
                      return Column(
                        children: [
                          FutureBuilder(
                            future: getCategoriaRndom(randomNumber),
                            initialData: 'waiting',
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == 'waiting') {
                                return CircularProgressIndicator();
                              } else {
                                return Container(
                                  padding: EdgeInsets.only(left: 30),
                                  alignment: Alignment.centerLeft,
                                  width: double.maxFinite,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('TOP RANKING DE ${snapshot.data}',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 16)),
                                      SizedBox(
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
                                  aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                                  viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: false,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 1000),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {},
                                  scrollDirection: Axis.horizontal,
                                  disableCenter: true)),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
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
        padding: EdgeInsets.only(left: 30),
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
            SizedBox(
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
            return FutureBuilder(
              future: fetchPlatillos(),
              initialData: 'waiting',
              builder: (BuildContext context, AsyncSnapshot snapshot2) {
                if (snapshot2.data != 'waiting') {
                  return CarouselSlider(
                      items: itemsListVanJuntos(snapshot.data, snapshot2.data),
                      options: CarouselOptions(
                          height: 110,
                          aspectRatio: ancho < 1000 ? 16 / 9 : 4 / 3,
                          viewportFraction: ancho < 1000 ? 0.8 : 0.4,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {},
                          scrollDirection: Axis.horizontal,
                          disableCenter: true));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
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
          padding: EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MÁS COMPRADOS',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 16)),
              SizedBox(
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
              return Center(child: CircularProgressIndicator());
            } else {
              return FutureBuilder(
                future: fetchPlatillos(),
                initialData: 'waiting',
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  if (snapshot2.data != 'waiting') {
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
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                            disableCenter: true));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
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
          padding: EdgeInsets.only(left: 30),
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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fetchRecomendados(context),
          initialData: 'waiting',
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != 'waiting' && snapshot.data != null) {
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
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                            disableCenter: true));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  Widget titulos(String? nombre) {
    return Column(children: [
      Container(
        padding: EdgeInsets.only(left: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BIENVENIDO',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: 30)),
                Text(nombre ?? 'AMIGO',
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
    print(response.body);
    List<dynamic> json = jsonDecode(response.body);
    String recomendados = json[randomNumber - 1]['Nombre_categoria'];

    return recomendados.toUpperCase();
  }
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
  return http.get(
    Uri.parse(
        'https://luisrojas24.pythonanywhere.com/rec_content_based?id_Usuario=114518122078180188707'),
  );
}

Future<http.Response> fetchTopRanking(randomNumber) {
  return http.get(
    Uri.parse(
        'https://luisrojas24.pythonanywhere.com/get-rankings?id_categoria=$randomNumber'),
  );
}

Future<http.Response> fetchOtrosTambien(randomNumber) {
  return http.get(
    Uri.parse(
        'https://luisrojas24.pythonanywhere.com/rec_colab_item?id_Usuario=101994360380017395432'),
  );
}

Future<dynamic> fetchMasComprados() async {
  List<MasComprados> posts = [];

  for (var i = 1; i < 15; i++) {
    http.Response request = await http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/get-mas_pedidos?tiempo=30&id_categoria=${i}'),
    );

    Iterable l = json.decode(request.body);

    posts.addAll(l.map((model) => MasComprados.fromJson(model)));
  }

  return posts;
}

Future<http.Response> fetchPlatillos() {
  return http.get(
    Uri.parse('https://luisrojas24.pythonanywhere.com/get-platillos'),
  );
}

Future<List<dynamic>> fetchRecomendados(BuildContext context) async {
  final providerCarrito = Provider.of<CarritoProvider>(context, listen: false);
  List<dynamic> posts = [];
  List<dynamic> articulos = providerCarrito.getArticulos;
  if (articulos.isNotEmpty) {
    for (var i = 0; i < articulos.length; i++) {
      http.Response request = await http.get(
        Uri.parse(
            'https://luisrojas24.pythonanywhere.com/get-asociaciones?id_platillo=${articulos[i]['id']}'),
      );

      List<dynamic> l = json.decode(request.body);

//Primero 2 PLatillos Recomendados
      for (var i = 0; i < 2; i++) {
        var idPlatillo = l[i]
            .toString()
            .split(',')[0]
            .split(':')[1]
            .trim()
            .replaceAll('.0', '');
        var acompaniamiento = l[i]
            .toString()
            .split(',')[1]
            .split(':')[1]
            .trim()
            .replaceAll('.0', '');
        var asociacion = l[i]
            .toString()
            .split(',')[2]
            .split(':')[1]
            .trim()
            .replaceAll('.0', '');

        posts.contains(acompaniamiento) ? null : posts.add(acompaniamiento);
      }
    }

    return posts;
  } else {
    http.Response request = await http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/get-asociaciones?id_platillo=2'),
    );

    Iterable l = json.decode(request.body);

    var idPlatillo = l.first
        .toString()
        .split(',')[0]
        .split(':')[1]
        .trim()
        .replaceAll('.0', '');
    var acompaniamiento = l.first
        .toString()
        .split(',')[1]
        .split(':')[1]
        .trim()
        .replaceAll('.0', '');
    var asociacion = l.first
        .toString()
        .split(',')[2]
        .split(':')[1]
        .trim()
        .replaceAll('.0', '');

    posts.contains(acompaniamiento) ? null : posts.add(acompaniamiento);

    return posts;
  }
}
