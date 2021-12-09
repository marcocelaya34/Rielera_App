import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:rielera_app/providers/barProvider.dart';

import 'package:url_launcher/url_launcher.dart';

class DetallesProdPage2 extends StatefulWidget {
  @override
  _DetallesProdPage2State createState() => _DetallesProdPage2State();
}

class _DetallesProdPage2State extends State<DetallesProdPage2> {
  int cantidad = 1;
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;
  String calificacion = '';

  @override
  Widget build(BuildContext context) {
    star1 = false;
    star2 = false;
    star3 = false;
    star4 = false;
    star5 = false;

    MediaQueryData queryData = MediaQuery.of(context);
    double alto = queryData.size.height;
    double ancho = queryData.size.width;
    final providerBar = Provider.of<BarProvider>(context);

    Future<bool> _onWillPop() async {
      providerBar.setpageController(PageController(initialPage: 3));
      Navigator.pushReplacementNamed(context, 'bottomBar');
      return true;
    }

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
                    width: double.maxFinite,
                    decoration: BoxDecoration(
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
                                child: Image.asset('assets/112_Salchipulpos.png',
                                    fit: BoxFit.fitWidth, height: 250))),
                        Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ancho > 760
                                      ? Text('SALCHIPULPOS',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 55))
                                      : Text('SALCHIPULPOS',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30)),
                                  Divider(
                                    color: Colors.white,
                                    indent: 80,
                                    thickness: 3,
                                  ),
                                  SizedBox(
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
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text('DESCRIPCIÓN',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 20, bottom: 10),
                            child: Text(
                                'Ricos salchipulpos',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 17)),
                          ),
                          StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              if (ancho > 760) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 70),
                                  child: Row(
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = false;
                                              star3 = false;
                                              star4 = false;
                                              star5 = false;

                                              calificacion = '1';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star1
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = true;
                                              star3 = false;
                                              star4 = false;
                                              star5 = false;
                                              calificacion = '2';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star2
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = true;
                                              star3 = true;
                                              star4 = false;
                                              star5 = false;
                                              calificacion = '3';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star3
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = true;
                                              star3 = true;
                                              star4 = true;
                                              star5 = false;
                                              calificacion = '4';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star4
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = true;
                                              star3 = true;
                                              star4 = true;
                                              star5 = true;
                                              calificacion = '5';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star5
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = false;
                                              star3 = false;
                                              star4 = false;
                                              star5 = false;

                                              calificacion = '1';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star1
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = true;
                                              star3 = false;
                                              star4 = false;
                                              star5 = false;
                                              calificacion = '2';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star2
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = true;
                                              star3 = true;
                                              star4 = false;
                                              star5 = false;
                                              calificacion = '3';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star3
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = true;
                                              star3 = true;
                                              star4 = true;
                                              star5 = false;
                                              calificacion = '4';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star4
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              star1 = true;
                                              star2 = true;
                                              star3 = true;
                                              star4 = true;
                                              star5 = true;
                                              calificacion = '5';
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: star5
                                                  ? Image.asset(
                                                      'assets/star_fill2.png')
                                                  : Image.asset(
                                                      'assets/star2.png'),
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.maxFinite,
                            height: 60,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 30),
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
                                  Flexible(
                                      flex: 1,
                                      child: Icon(LineIcons.arrowRight))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text('CANTIDAD',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (cantidad > 1)
                                            cantidad = cantidad - 1;
                                        });
                                      },
                                      child:
                                          Image.asset('assets/BotonMas.png'))),
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
                                          if (cantidad < 10)
                                            cantidad = cantidad + 1;
                                        });
                                      },
                                      child: Image.asset(
                                          'assets/BotonMenos.png'))),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: (){
                              
                              Navigator.pushReplacementNamed(context, 'bottomBar');
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 50,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 30),
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
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  bottom: alto * 0.65,
                  right: 15,
                  child: Container(
                    height: 80,
                    child: InkWell(
                        onTap: () async {
                          await launch(
                            'https://ra-gif.web.app/27-tacos.html',
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
}
