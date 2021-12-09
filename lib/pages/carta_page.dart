import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rielera_app/providers/platilloProvider.dart';

class CartaDigitalPage extends StatefulWidget {
  @override
  _CartaDigitalPageState createState() => _CartaDigitalPageState();
}

final PageController controller = PageController(initialPage: 0);

class _CartaDigitalPageState extends State<CartaDigitalPage> {
  String busqueda = '';

  String categoria = '';

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    /*   double alto = queryData.size.height; */
    double ancho = queryData.size.width;
    List<List<dynamic>> carta = [
      ['Clamato', '01_clamato.png', 'Descripcion'],
      ['XX', '02_XX.png', 'Descripcion'],
      ['Bohemia', '03_bohemia.png', 'Descripcion'],
      ['Mojito', '04_mojito.png', 'Descripcion'],
      ['Tecate', '05_tecate.png', 'Descripcion'],
      ['Heineken', '06_heineken.png', 'Descripcion'],
      ['Ultra', '07_ultra.png', 'Descripcion'],
      ['Tecate-Light', '08_tecate_light.png', 'Descripcion'],
      ['Shots', '09_shots.png', 'Descripcion'],
      ['Cubeta-de-Cervezas', '10_cubeta_de_cervezas.png', 'Descripcion'],
      ['Mojito-Ultra', '11_mojito_ultra.png', 'Descripcion'],
      ['Margarita', '12_margarita.png', 'Descripcion'],
      ['Mojito-Black', '13_mojito_black.png', 'Descripcion'],
      ['Sunrise', '15_sunrise.png', 'Descripcion'],
      ['Mojito-Clasico', '16_mojito_clasico.png', 'Descripcion'],
      ['Chilaquiles', '17_chilaquiles.png', 'Descripcion'],
      ['Tostada-de-Tinga', '18_tostada_de_tinga.png', 'Descripcion'],
      ['Pozole', '19_pozole.png', 'Descripcion'],
      ['MargaChela', '20_margachela.png', 'Descripcion'],
      ['Malteada-de-vainilla', '21_maltedad_de_vainilla.png', 'Descripcion'],
      ['Tacos-de-Bistek', '22_tacos_de_bistek.png', 'Descripcion'],
      ['Papas-a-la-francesa', '23_papas_a_la_francesa.png', 'Descripcion'],
      [
        'Enchiladas',
        '24_Enchiladas_Suizas_Rojas.png',
        'Deliciosas enchiladas rojas al gusto',
      ],
      ['Caldo-de-Carne', '25_caldo_de_carne.png', 'Descripcion'],
      ['Salchipulpos', '26_salchipulpos.png', 'Descripcion'],
      ['Tacos-Campechanos', '27_tacos_campechanos.png', 'descripcion']
    ];

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
                Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DISFRUTA DE',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 20)),
                      Row(
                        children: [
                          Text('NUESTRO AMPLIO',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 24)),
                          Text(' MENÚ !',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24)),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    margin: EdgeInsets.only(left: 30, right: 30),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 9,
                            child: TextField(
                              onChanged: (value) {
                                busqueda = value;
                                setState(() {});
                              },
                              style: GoogleFonts.roboto(),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            child: Container(
                                height: 50, child: Icon(LineIcons.search)))
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                /* Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 40),
                  child: ToggleSwitch(
                    initialLabelIndex: 0,
                    totalSwitches: 2,
                    activeBgColor: [Colors.white],
                    inactiveBgColor: Colors.black,
                    inactiveFgColor: Colors.white,
                    activeFgColor: Colors.black,
                    labels: ['RA', 'STDR'],
                    onToggle: (index) {
                      controller.jumpToPage(index);
                    },
                  ),
                ), */
                Container(
                  height: 550,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    children: <Widget>[
                      /* Container(
                          height: 450,
                          margin: EdgeInsets.only(bottom: 80),
                          width: double.maxFinite,
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            scrollDirection: Axis.vertical,
                            itemCount: carta.length,
                            itemBuilder: (BuildContext context, int index) {
                              return cardPlatilloRA(
                                  carta[index][0],
                                  carta[index][1],
                                  carta[index][2],
                                  index.toString());
                            },
                            staggeredTileBuilder: (int index) {
                              if (ancho > 760) {
                                return new StaggeredTile.count(2, 1);
                              } else {
                                return new StaggeredTile.count(2, 2.3);
                              }
                            },
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 20.0,
                          )), */
                      Container(
                        height: 550,
                        margin: EdgeInsets.only(bottom: 80),
                        width: double.maxFinite,
                        child: FutureBuilder(
                          future: fetchPlatillos(),
                          initialData: 'waiting',
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == 'waiting') {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return FutureBuilder(
                                future: fetchCateogorias(),
                                initialData: 'waiting',
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot2) {
                                  if (snapshot2.data != 'waiting') {
                                    List<dynamic> categorias =
                                        jsonDecode(snapshot2.data.body);
                                    List<dynamic> platillos =
                                        jsonDecode(snapshot.data.body);
                                    List<List<dynamic>> platillosxCategoria =
                                        [];

                                    for (var item in categorias) {
                                      platillosxCategoria.add(platillos
                                          .where((element) =>
                                              element['id_Categoria'] ==
                                              item['id_Categoria'])
                                          .toList());
                                    }

                                    bool existePlatillo = false;
                                    String id = '';
                                    String nombre = '';
                                    String imagen = '';

                                    if (busqueda != '' &&
                                        existePlatillo == false) {
                                      for (var item in platillosxCategoria) {
                                        for (var item2 in item) {
                                          if (item2['Nombre_platillo']
                                                  .toLowerCase() ==
                                              busqueda.toLowerCase()) {
                                            id =
                                                item2['id_Platillo'].toString();
                                            nombre = item2['Nombre_platillo'];
                                            imagen = item2['Video_RA'];
                                            categoria = item2['id_Categoria']
                                                .toString();
                                            existePlatillo = true;
                                          }
                                        }
                                      }
                                    } else {
                                      existePlatillo = false;
                                    }

                                    return !existePlatillo
                                        ? ListView.builder(
                                            itemCount:
                                                platillosxCategoria.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 60),
                                                    child: Text(
                                                        '${categorias[index]['Nombre_categoria']}',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                fontSize: 30)),
                                                  ),
                                                  StaggeredGridView
                                                      .countBuilder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        ClampingScrollPhysics(),
                                                    crossAxisCount: 4,
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        platillosxCategoria[
                                                                index]
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index2) {
                                                      return cardPlatillo(
                                                          platillosxCategoria[
                                                                      index]
                                                                  [index2]
                                                              [
                                                              'Nombre_platillo'],
                                                          platillosxCategoria[
                                                                  index][index2]
                                                              ['Video_RA'],
                                                          '',
                                                          platillosxCategoria[
                                                                          index]
                                                                      [index2][
                                                                  'id_Categoria']
                                                              .toString(),
                                                          platillosxCategoria[
                                                                          index]
                                                                      [index2][
                                                                  'id_Platillo']
                                                              .toString());
                                                    },
                                                    staggeredTileBuilder:
                                                        (int index) {
                                                      if (ancho > 1000) {
                                                        return new StaggeredTile
                                                            .count(1, .5);
                                                      } else if ((ancho >
                                                          800)) {
                                                        return new StaggeredTile
                                                            .count(1, 1);
                                                      } else if ((ancho > 50)) {
                                                        return new StaggeredTile
                                                            .count(2, 2.3);
                                                      }
                                                    },
                                                    mainAxisSpacing: 20.0,
                                                    crossAxisSpacing: 20.0,
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        : cardPlatillo(nombre, imagen,
                                            'descripcion', categoria, id);
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget cardPlatillo(String nombre, String imagen, String descripcion,
      String categoria, String id) {
    return InkWell(
      onTap: () {
        final providerPlatillo =
            Provider.of<PlatilloProvider>(context, listen: false);

        providerPlatillo.setId = id;
        providerPlatillo.setNombre = nombre;
        providerPlatillo.setDescripcion = descripcion;
        providerPlatillo.setImagen = imagen;
        providerPlatillo.setCategoria = categoria;

        Navigator.pushReplacementNamed(context, 'detallesProd');
      },
      child: Column(
        children: [
          Center(
              child: Container(
                  height: 100,
                  width: 100,
                  padding:
                      EdgeInsets.only(left: 0, right: 0, top: 1, bottom: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.network(
                    imagen,
                    fit: BoxFit.contain,
                  ))),
          Container(
            padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(nombre,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 2,
                  color: Colors.white,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(descripcion,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 12)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardPlatilloRA(
      String nombre, String imagen, String descripcion, String index) {
    return InkWell(
      onTap: () {
        final providerPlatillo =
            Provider.of<PlatilloProvider>(context, listen: false);

        providerPlatillo.setNombre = nombre;
        providerPlatillo.setDescripcion = descripcion;
        providerPlatillo.setImagen = imagen;

        Navigator.pushReplacementNamed(context, 'detallesProdRA');
      },
      child: Column(
        children: [
          Center(
              child: Container(
                  height: 100,
                  width: 100,
                  padding:
                      EdgeInsets.only(left: 0, right: 0, top: 1, bottom: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    'assets/$nombre.png',
                    fit: BoxFit.contain,
                  ))),
          Container(
            padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(nombre,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 2,
                  color: Colors.white,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(descripcion,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 12)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<http.Response> fetchPlatillos() {
  return http.get(
      Uri.parse('https://luisrojas24.pythonanywhere.com/get-platillos'),
      headers: {
        'Access-Control-Allow-Origin':
            '*', // Request header field access-control-allow-origin is not allowed by Access-Control-Allow-Headers in preflight response.
//        'Access-Control-Allow-Origin':'http://localhost:5000/', // Request header field access-control-allow-origin is not allowed by Access-Control-Allow-Headers in preflight response.

        "Access-Control-Allow-Methods":
            "GET, POST, OPTIONS, PUT, PATCH, DELETE",
        "Access-Control-Allow-Headers":
            "Origin, X-Requested-With, Content-Type, Accept"
      });
}

Future<http.Response> fetchCateogorias() {
  return http.get(
      Uri.parse('https://luisrojas24.pythonanywhere.com/get-categorias'),
      headers: {
        'Access-Control-Allow-Origin':
            '*', // Request header field access-control-allow-origin is not allowed by Access-Control-Allow-Headers in preflight response.
//        'Access-Control-Allow-Origin':'http://localhost:5000/', // Request header field access-control-allow-origin is not allowed by Access-Control-Allow-Headers in preflight response.

        "Access-Control-Allow-Methods":
            "GET, POST, OPTIONS, PUT, PATCH, DELETE",
        "Access-Control-Allow-Headers":
            "Origin, X-Requested-With, Content-Type, Accept"
      });
}
