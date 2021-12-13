import 'dart:convert';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rielera_app/providers/platillo.provider.dart';

class CartaDigitalPage extends StatefulWidget {
  const CartaDigitalPage({Key? key}) : super(key: key);

  @override
  _CartaDigitalPageState createState() => _CartaDigitalPageState();
}

final PageController controller = PageController(initialPage: 0);

class _CartaDigitalPageState extends State<CartaDigitalPage> {
  String busqueda = '';
  String filterCard = 'Desayunos';
  String categoria = '';

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30),
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
              const SizedBox(
                height: 30,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  margin: const EdgeInsets.only(left: 30, right: 30),
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          )),
                      const Flexible(
                          flex: 1,
                          child: SizedBox(
                              height: 50, child: Icon(LineIcons.search)))
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: fetchCateogorias(),
                initialData: 'waiting',
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == 'waiting') {
                    return const Center(
                      child: SizedBox(
                        height: 40,
                      ),
                    );
                  } else {
                    if (snapshot.data != null) {
                      List<dynamic> list = json.decode(snapshot.data.body);

                      return CustomRadioButton(
                        elevation: 0,
                        radius: 500,
                        absoluteZeroSpacing: false,
                        unSelectedColor: Colors.white,
                        autoWidth: true,
                        enableShape: true,
                        defaultSelected: 'Desayunos',
                        customShape: const StadiumBorder(),
                        buttonLables: list
                            .map<String>((e) => e['Nombre_categoria'])
                            .toList(),
                        buttonValues: list
                            .map<String>((e) => e['Nombre_categoria'])
                            .toList(),
                        unSelectedBorderColor: Colors.transparent,
                        selectedBorderColor: Colors.transparent,
                        buttonTextStyle: ButtonTextStyle(
                            selectedColor: Colors.white,
                            unSelectedColor: Colors.black,
                            textStyle: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                                fontSize: 14)),
                        radioButtonValue: (value) {
                          filterCard = value.toString();
                          setState(() {});
                        },
                        selectedColor: Colors.black,
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Text(
                              'Uppss, el servidor se cayo, no podemos mostrar las categorias',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15)),
                        ),
                      );
                    }
                  }
                },
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchPlatillos(),
                  initialData: 'waiting',
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == 'waiting') {
                      return loaderCarta();
                    } else {
                      if (snapshot.data != null) {
                        return FutureBuilder(
                          future: fetchCateogorias(),
                          initialData: 'waiting',
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot2) {
                            if (snapshot2.data != 'waiting') {
                              List<dynamic> categorias =
                                  jsonDecode(snapshot2.data.body);
                              List<dynamic> platillos =
                                  jsonDecode(snapshot.data.body);
                              List<List<dynamic>> platillosxCategoria = [];

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

                              if (busqueda != '' && existePlatillo == false) {
                                for (var item in platillosxCategoria) {
                                  for (var item2 in item) {
                                    if (item2['Nombre_platillo']
                                            .toLowerCase() ==
                                        busqueda.toLowerCase()) {
                                      id = item2['id_Platillo'].toString();
                                      nombre = item2['Nombre_platillo'];
                                      imagen = item2['Video_RA'];
                                      categoria =
                                          item2['id_Categoria'].toString();
                                      existePlatillo = true;
                                    }
                                  }
                                }
                              } else {
                                existePlatillo = false;
                              }

                              return !existePlatillo
                                  ? ListView.builder(
                                      itemCount: platillosxCategoria.length,
                                      itemBuilder: (context, index) {
                                        if (filterCard ==
                                            categorias[index]
                                                ['Nombre_categoria']) {
                                          return Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 60),
                                                child: Text(
                                                    '${categorias[index]['Nombre_categoria']}',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontSize: 30)),
                                              ),
                                              StaggeredGridView.countBuilder(
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                crossAxisCount: 4,
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    platillosxCategoria[index]
                                                        .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index2) {
                                                  return cardPlatillo(
                                                      platillosxCategoria[index]
                                                              [index2]
                                                          ['Nombre_platillo'],
                                                      platillosxCategoria[index]
                                                          [index2]['Video_RA'],
                                                      '',
                                                      platillosxCategoria[index]
                                                                  [index2]
                                                              ['id_Categoria']
                                                          .toString(),
                                                      platillosxCategoria[index]
                                                                  [index2]
                                                              ['id_Platillo']
                                                          .toString());
                                                },
                                                staggeredTileBuilder:
                                                    (int index) {
                                                  if (ancho > 1000) {
                                                    return const StaggeredTile
                                                        .count(1, .5);
                                                  } else if ((ancho > 800)) {
                                                    return const StaggeredTile
                                                        .count(1, 1);
                                                  } else if ((ancho > 50)) {
                                                    return const StaggeredTile
                                                        .count(2, 2.3);
                                                  }
                                                },
                                                mainAxisSpacing: 20.0,
                                                crossAxisSpacing: 20.0,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    )
                                  : cardPlatillo(nombre, imagen, 'descripcion',
                                      categoria, id);
                            } else {
                              return loaderCarta();
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Text(
                                'Uppss, el servidor se cayo, no podemos mostrar la carta',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15)),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
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
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 1, bottom: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.network(
                    imagen,
                    fit: BoxFit.contain,
                  ))),
          Container(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(nombre,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 2,
                  color: Colors.white,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
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

  Widget cardPlatilloLoader() {
    return Column(
      children: [
        Center(
            child: Container(
          height: 100,
          width: 100,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 10,
            width: 10,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
          ),
        )),
        Container(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: double.maxFinite,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(5)),
              ),
            ],
          ),
        ),
      ],
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
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 1, bottom: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    'assets/$nombre.png',
                    fit: BoxFit.contain,
                  ))),
          Container(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(nombre,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 2,
                  color: Colors.white,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
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

  Widget loaderCarta() {
    MediaQueryData queryData = MediaQuery.of(context);
    double ancho = queryData.size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 30,
            width: 300,
            margin: const EdgeInsets.only(top: 35, bottom: 60),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5)),
          ),
          StaggeredGridView.countBuilder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            crossAxisCount: 4,
            padding: const EdgeInsets.only(left: 5, right: 5),
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index2) {
              return cardPlatilloLoader();
            },
            staggeredTileBuilder: (int index) {
              if (ancho > 1000) {
                return const StaggeredTile.count(1, .5);
              } else if ((ancho > 800)) {
                return const StaggeredTile.count(1, 1);
              } else if ((ancho > 50)) {
                return const StaggeredTile.count(2, 2.3);
              }
            },
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
          ),
        ],
      ),
    );
  }
}

Future<http.Response> fetchPlatillos() async {
  var response = await http.get(
    Uri.parse('https://luisrojas24.pythonanywhere.com/get-platillos'),
  );

  return response;
}

Future<http.Response> fetchCateogorias() async {
  var response = await http.get(
    Uri.parse('https://luisrojas24.pythonanywhere.com/get-categorias'),
  );

  return response;
}
