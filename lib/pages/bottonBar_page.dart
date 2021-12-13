import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:provider/provider.dart';
import 'package:rielera_app/pages/carrito_page.dart';
import 'package:rielera_app/pages/home_page.dart';
import 'package:rielera_app/pages/pedidos_page.dart';
import 'package:rielera_app/providers/barProvider.dart';
import 'package:rielera_app/custom_icons.dart';

import 'carta_page.dart';

class BottomBarPage extends StatefulWidget {
  @override
  _BottomBarPageState createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerBar = Provider.of<BarProvider>(context);

    var posicion = providerBar.getPosicion;

    Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
      if (providerBar.getpageController.hasClients) {
        providerBar.getpageController.jumpToPage(posicion);
      }
    });

    Future<bool> _onWillPop() async {
      Navigator.pushReplacementNamed(context, 'loginPage');
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        /* appBar: AppBar(
          centerTitle: false,
          brightness: Brightness.light,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {}),
          title: const Text('Go back', style: TextStyle(color: Colors.black)),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ), */
        body: AnimatedContainer(
          color: Colors.transparent,
          duration: const Duration(seconds: 1),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            restorationId: '3',
            onPageChanged: _onPageChanged,
            controller: providerBar.getpageController,
            children: <Widget>[
              PedidosPage(),
              HomePage(),
              CarritoPage(),
              CartaDigitalPage(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.0001),
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(1),
            ],
          )),
          child: SnakeNavigationBar.color(
            height: 60,
            elevation: 10,
            behaviour: SnakeBarBehaviour.floating,
            snakeShape: SnakeShape.circle,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            padding: EdgeInsets.only(left: 50, right: 50, bottom: 30),

            ///configuration for SnakeNavigationBar.color
            snakeViewColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            showSelectedLabels: true,

            currentIndex: providerBar.getPosicion,
            onTap: (index) => setState(() {
              providerBar.setPosicion(index);
              if (providerBar.getpageController.hasClients) {
                providerBar.getpageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.easeIn,
                );
              }
            }),
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Custom.list_bullet), label: 'Pedidos'),
              const BottomNavigationBarItem(
                  icon: Icon(Custom.home), label: 'Home'),
              const BottomNavigationBarItem(
                  icon: Icon(Custom.shopping_cart), label: 'Carrito'),
              const BottomNavigationBarItem(
                  icon: Icon(Custom.knife_fork), label: 'Carta'),
            ],
            selectedLabelStyle: const TextStyle(fontSize: 34),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    /*  final providerBar =Provider.of<BarProvider>(context, listen: false);
 */

    switch (page) {
      case 0:
        /*  setState(() {
           providerBar.setPosicion(0);
           
         
        }); */
        break;
      case 1:
        /* setState(() {
          providerBar.setPosicion(1);
       
        }); */
        break;

      case 2:
        /*  setState(() {
          providerBar.setPosicion(2);
         
        }); */
        break;
      case 3:
        /*   setState(() {
          providerBar.setPosicion(3);
         
        }); */
        break;
    }
  }
}

class PagerPageWidget extends StatelessWidget {
  final String? text;
  final String? description;
  final Image? image;
  final TextStyle titleStyle =
      const TextStyle(fontSize: 40, fontFamily: 'SourceSerifPro');
  final TextStyle subtitleStyle = const TextStyle(
    fontSize: 20,
    fontFamily: 'Ubuntu',
    fontWeight: FontWeight.w200,
  );

  const PagerPageWidget({
    Key? key,
    this.text,
    this.description,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _portraitWidget()
              : _horizontalWidget(context);
        }),
      ),
    );
  }

  Widget _portraitWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(text!, style: titleStyle),
            const SizedBox(height: 16),
            Text(description!, style: subtitleStyle),
          ],
        ),
      ],
    );
  }

  Widget _horizontalWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(text!, style: titleStyle),
              Text(description!, style: subtitleStyle),
            ],
          ),
        ),
        Expanded(child: image!)
      ],
    );
  }
}
