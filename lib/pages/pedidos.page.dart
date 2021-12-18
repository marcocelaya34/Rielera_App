import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
                Container(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MIS',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 20)),
                      const Divider(
                        color: Colors.white,
                        endIndent: 250,
                      ),
                      Text('PEDIDOS',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 30))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: fetchOrdenes(),
                  initialData: 'waiting',
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == 'waiting') {
                      return loaderPedidos();
                    } else if (snapshot.data.body.contains('<!DOCTYPE HTML')) {
                      return Center(
                        child: Text(
                            'Recarga la pagina, el servidor esta arrancando',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 15)),
                      );
                    } else if (snapshot.data != null) {
                      List<dynamic> ordenes = json.decode(snapshot.data.body);
                      List<List<dynamic>> pedidos = [];
                      for (var i = 0; i < 600; i++) {
                        List<dynamic> addPedido = ordenes
                            .where((orden) => orden['id_Orden'] == i)
                            .toList();
                        if (addPedido.isNotEmpty) {
                          pedidos.add(addPedido);
                        }
                      }
                      return FutureBuilder(
                        future: fetchPlatillos(),
                        initialData: 'waiting',
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot2) {
                          if (snapshot2.data == 'waiting') {
                            return loaderPedidos();
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pedidos.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cardPedido(
                                    pedidos[index], snapshot2.data, index);
                              },
                            );
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
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          )),
    );
  }

  Widget cardPedido(List<dynamic> pedidos, dynamic platillos, int index) {
    List<String> fecha = pedidos[0]['Fecha'].toString().split(' ');

    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      padding: const EdgeInsets.only(left: 0, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text('PEDIDOx${index + 1}',
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
          ),
          const Divider(
            endIndent: 200,
            indent: 20,
            thickness: 2,
            color: Colors.black,
          ),
          Row(
            children: [
              Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      mostrarQR(pedidos[0]['Codigo_qr']);
                    },
                    child: Center(
                        child: SizedBox(
                            height: 80, child: Image.asset('assets/QR.png'))),
                  )),
              Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Fecha',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  fecha.length > 4
                                      ? fecha[1] +
                                          ' ' +
                                          fecha[2] +
                                          '.' +
                                          ' ' +
                                          fecha[3]
                                      : '',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Hora',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  fecha.length > 5
                                      ? fecha[4].split(':')[0] +
                                          ':' +
                                          fecha[4].split(':')[1]
                                      : '',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15))
                            ],
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
          ExpandableNotifier(
            // <-- Provides ExpandableController to its children
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expandable(
                  // <-- Driven by ExpandableController from ExpandableNotifier
                  collapsed: Container(
                    alignment: Alignment.centerRight,
                    child: ExpandableButton(
                      // <-- Expands when tapped on the cover photo
                      child: const Icon(
                        LineIcons.angleDown,
                        size: 30,
                      ),
                    ),
                  ),
                  expanded: Column(children: [
                    const SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pedidos.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<dynamic> platillo = jsonDecode(platillos.body);
                        List<dynamic> acompaniamientos = [];

                        acompaniamientos.add(platillo
                            .where((element) =>
                                element['id_Platillo'] ==
                                pedidos[index]['id_Platillo'])
                            .toList());

                        return platilloCard(
                          acompaniamientos[0][0]['Video_RA'],
                          acompaniamientos[0][0]['Nombre_platillo'],
                          pedidos[index]['Cantidad'],
                        );
                      },
                    ),
                    ExpandableButton(
                      // <-- Collapses when tapped on
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          LineIcons.angleUp,
                          size: 30,
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget cardPedidoLoader() {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      height: 154,
      margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              width: double.maxFinite,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.only(left: 20),
            ),
          ),
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Row(
              children: [
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5)),
                            height: 100,
                            width: double.maxFinite))),
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
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(5)),
                              height: double.maxFinite,
                              width: double.maxFinite),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5)),
                              height: double.maxFinite,
                              width: double.maxFinite),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> mostrarQR(String qr) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text('ESTE ES TU CÓDIGO QR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 15)),
              const Divider(
                color: Colors.black,
                thickness: 3,
              )
            ],
          ),
          content: Container(
            height: 300,
            width: 300,
            color: Colors.transparent,
            child: QrImage(
              data: qr,
              version: QrVersions.auto,
              size: 320,
              gapless: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget platilloCard(String imagen, String nombre, int? cantidad) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      child: Row(children: [
        Flexible(
            flex: 2,
            child: Center(
                child: Image.network(
              imagen,
              height: 80,
            ))),
        Flexible(
            flex: 4,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(nombre,
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Cantidad',
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('X${cantidad ?? '-'}',
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Subtotal',
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('MXN\$${(cantidad ?? 0) * 20}',
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15))
                    ],
                  ),
                ],
              ),
            ])),
      ]),
    );
  }

  Future<http.Response> fetchPlatillos() {
    return http.get(
      Uri.parse('https://luisrojas24.pythonanywhere.com/get-platillos'),
    );
  }

  Future<http.Response> fetchOrdenes() {
    String? id = _auth.currentUser?.uid;

    return http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/get-Ordenes?id_Usuario=$id'),
    );
  }

  Widget loaderPedidos() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return cardPedidoLoader();
      },
    );
  }
}
