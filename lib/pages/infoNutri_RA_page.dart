import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rielera_app/providers/platilloProvider.dart';

String nombre = '';
String imagen = '';
String descripcion = '';

class InfoNutriPageRA extends StatefulWidget {
  @override
  _InfoNutriPageRAState createState() => _InfoNutriPageRAState();
}

class _InfoNutriPageRAState extends State<InfoNutriPageRA> {
  @override
  Widget build(BuildContext context) {
    final providerPlatillo = Provider.of<PlatilloProvider>(context);

    nombre = providerPlatillo.getNombre;
    descripcion = providerPlatillo.getDescripcion;
    imagen = providerPlatillo.getImagen;

    Future<bool> _onWillPop() async {
      Navigator.pushReplacementNamed(context, 'detallesProdRA');
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
                    child: Image.asset('assets/$nombre.png',
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: cardInfo('CARBOHIDRATOS', '31.88mg')),
                          Flexible(
                              flex: 1, child: cardInfo('GRASAS', '32.02mg')),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(flex: 1, child: cardInfo('SODIO', '404mg')),
                          Flexible(
                              flex: 1, child: cardInfo('CALORIAS', '32.02mg')),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardInfo(String text, String cantidad) {
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
                        fontSize: 34)),
                Text('gr',
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 20)),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.black,
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
}
