import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rielera_app/providers/platilloProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String id = '';
String nombre = '';
String imagen = '';
String descripcion = '';

class InfoNutriPage extends StatefulWidget {
  @override
  _InfoNutriPageState createState() => _InfoNutriPageState();
}

class _InfoNutriPageState extends State<InfoNutriPage> {
  @override
  Widget build(BuildContext context) {
    final providerPlatillo = Provider.of<PlatilloProvider>(context);

    id = providerPlatillo.getId;
    nombre = providerPlatillo.getNombre;
    descripcion = providerPlatillo.getDescripcion;
    imagen = providerPlatillo.getImagen;

    Future<bool> _onWillPop() async {
      Navigator.pushReplacementNamed(context, 'detallesProd');
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text('INFORMACIÓN',
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20)),
              Divider(
                color: Colors.black,
                thickness: 2,
                endIndent: 250,
              ),
              Text('NUTRICIONAL',
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 34)),
              Center(
                child: Container(
                    child: Image.network(imagen,
                        fit: BoxFit.fitWidth, height: 200)),
              ),
              Center(
                child: Text(nombre.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 27)),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: getInfoNut(id),
                    initialData: 'waiting',
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == 'waiting') {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: cardInfo(
                                        'CARBOHIDRATOS',
                                        snapshot.data.length > 2
                                            ? snapshot.data[2]['cantidad']
                                            : '-',
                                        snapshot.data.length > 2
                                            ? double.parse(snapshot.data[2]
                                                            ['cantidad']
                                                        .toString()
                                                        .replaceAll('mg', '')) >
                                                    150
                                                ? Colors.red
                                                : Colors.black
                                            : Colors.black)),
                                Flexible(
                                    flex: 1,
                                    child: cardInfo(
                                        'GRASAS',
                                        snapshot.data.length > 1
                                            ? snapshot.data[1]['cantidad']
                                            : '-',
                                        snapshot.data.length > 1
                                            ? double.parse(snapshot.data[1]
                                                            ['cantidad']
                                                        .toString()
                                                        .replaceAll('mg', '')) >
                                                    160
                                                ? Colors.red
                                                : Colors.black
                                            : Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: cardInfo(
                                      'SODIO',
                                      snapshot.data.length > 3
                                          ? snapshot.data[3]['cantidad']
                                          : '-',
                                      snapshot.data.length > 3
                                          ? double.parse(snapshot.data[3]
                                                          ['cantidad']
                                                      .toString()
                                                      .replaceAll('mg', '')) >
                                                  35
                                              ? Colors.red
                                              : Colors.black
                                          : Colors.black),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: cardInfo(
                                        'CALORIAS',
                                        snapshot.data.length > 0
                                            ? snapshot.data[0]['cantidad']
                                            : '-',
                                        snapshot.data.length > 0
                                            ? double.parse(snapshot.data[0]
                                                            ['cantidad']
                                                        .toString()
                                                        .replaceAll('mg', '')) >
                                                    275
                                                ? Colors.red
                                                : Colors.black
                                            : Colors.black))
                              ],
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardInfo(String text, String cantidad, Color color) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cantidad,
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Text(text,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Future<dynamic> getInfoNut(String id) async {
    http.Response request = await http.get(Uri.parse(
        'https://luisrojas24.pythonanywhere.com/get-etiqueta_platillo?id_Platillo=${id}'));

    List<dynamic> info = json.decode(request.body);

    return info;
  }
}
