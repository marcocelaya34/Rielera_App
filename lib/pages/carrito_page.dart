import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rielera_app/providers/carritoProvider.dart';
import 'package:http/http.dart' as http;

class CarritoPage extends StatefulWidget {
  @override
  _CarritoPageState createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    /*  MediaQueryData queryData = MediaQuery.of(context);
    double alto = queryData.size.height;
    double ancho = queryData.size.width;
 */

    final providerCarrito = Provider.of<CarritoProvider>(context);
    List<dynamic> articulos = providerCarrito.getArticulos;

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
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    //color: Colors.amber,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('CARRITO',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 30)),
                        ),
                        Divider(
                          color: Colors.white,
                          thickness: 3,
                          endIndent: 100,
                          indent: 100,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: articulos.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: articulos.length,
                                itemBuilder: (context, index) {
                                  return cardProductoCar(
                                      articulos[index]['nombre'],
                                      articulos[index]['imagen'],
                                      articulos[index]['cantidad']);
                                },
                              ),
                              getTotal() != 0
                                  ? Container(
                                      //color: Colors.amber,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('TOTAL: MXN\$${getTotal()}',
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 20)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              List<Map<String, dynamic>> empty =
                                                  [];
                                              providerCarrito.setArticulos =
                                                  empty;
                                              mostrarQR(context, articulos);
                                              generarOrden(articulos);
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: double.maxFinite,
                                              height: 60,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 30),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1),
                                              ),
                                              child: Text('GENERAR QR',
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 15)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 200,
                              )
                            ],
                          ),
                        )
                      : emptyCar(),
                ),
              ],
            ),
          )),
    );
  }

  Widget cardProductoCar(String nombre, String imagen, int cantidad) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        height: 130,
        margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
        padding: EdgeInsets.only(left: 0, right: 10, top: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Flexible(flex: 2, child: Center(child: Image.network('$imagen'))),
            Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre,
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
                    SizedBox(
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
                            SizedBox(
                              height: 10,
                            ),
                            Text('X${cantidad}',
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
                            SizedBox(
                              height: 10,
                            ),
                            Text('MXN\$${cantidad * 20}',
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
      ),
    );
  }

  Future<void> mostrarQR(BuildContext context, List<dynamic> articulos) async {
    String dataQR = '';

    for (var item in articulos) {
      dataQR = dataQR +
          'Platillo:${item['nombre']}\n Cantidad:${item['cantidad']}\n\n';
    }

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
              Divider(
                color: Colors.black,
                thickness: 3,
              )
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 300,
                  width: 300,
                  color: Colors.transparent,
                  child: QrImage(
                    data: dataQR,
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                  ),
                )
              ],
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

  int getTotal() {
    final providerCarrito = Provider.of<CarritoProvider>(context);
    List<dynamic> articulos = providerCarrito.getArticulos;
    int total = 0;

    for (var item in articulos) {
      int cantidad = item['cantidad'];
      total = total + (cantidad * 20);
    }

    return total;
  }

  Widget emptyCar() {
    MediaQueryData queryData = MediaQuery.of(context);
    double alto = queryData.size.height;

    return Container(
      height: alto * 0.9,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/shopping-cart.png',
            scale: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text('Tu carrito aún sigue vacío',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 20)),
          ),
        ],
      ),
    );
  }

  void generarOrden(List<dynamic> articulos) async {
    String? id = _auth.currentUser?.uid;

    String platillos = '';

    for (var i = 0; i < articulos.length; i++) {
      if (i == articulos.length - 1) {
        platillos =
            platillos + '${articulos[i]['nombre']}*${articulos[i]['cantidad']}';
      } else {
        platillos = platillos +
            '${articulos[i]['nombre']}*${articulos[i]['cantidad']},';
      }
    }

    String dataQR = '';

    for (var item in articulos) {
      dataQR = dataQR +
          'Platillo:${item['nombre']}\n Cantidad:${item['cantidad']}\n\n';
    }

    var response =
        await fetchGenerarOrden(id, platillos.replaceAll(' ', '_'), dataQR);
  }

  Future<http.Response> fetchGenerarOrden(
      String? id, String platillos, String dataQR) {
    var response = http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/set-orden?id_Usuario=${id}&Platillos=${platillos}&qr=${dataQR}'),
    );

    return response;
  }
}
