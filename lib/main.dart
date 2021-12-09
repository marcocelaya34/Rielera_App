import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
/* import 'package:permission_handler/permission_handler.dart'; */
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:rielera_app/pages/bottonBar_page.dart';
import 'package:rielera_app/pages/carrito_page.dart';
import 'package:rielera_app/pages/carta_page.dart';
import 'package:rielera_app/pages/detallesProd_%20copy%202.dart';
import 'package:rielera_app/pages/detallesProd_%20copy%203.dart';
import 'package:rielera_app/pages/detallesProd_%20RA.dart';
import 'package:rielera_app/pages/detallesProd_.dart';
import 'package:rielera_app/pages/home_page.dart';
import 'package:rielera_app/pages/infoNutri_RA_page.dart';
import 'package:rielera_app/pages/infoNutri_page.dart';
import 'package:rielera_app/pages/login_page.dart';
import 'package:rielera_app/pages/pedidos_page.dart';
import 'package:rielera_app/pages/webview_page.dart';
import 'package:rielera_app/providers/carritoProvider.dart';
import 'package:rielera_app/providers/barProvider.dart';
import 'package:rielera_app/providers/platilloProvider.dart';

Future main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await Firebase?.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BarProvider()),
          ChangeNotifierProvider(create: (context) => CarritoProvider()),
          ChangeNotifierProvider(create: (context) => PlatilloProvider())
        ],
        child: MaterialApp(
          builder: (context, widget) => ResponsiveWrapper.builder(
            MainApp(),
            maxWidth: double.maxFinite,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(300, name: MOBILE, scaleFactor: 1),
              ResponsiveBreakpoint.resize(500, name: MOBILE, scaleFactor: 1),
              ResponsiveBreakpoint.resize(750, name: TABLET, scaleFactor: 1),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP, scaleFactor: 1),
            ],
          ),
          debugShowCheckedModeBanner: false,
        ));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'loginPage',
      routes: {
        'loginPage': (BuildContext context) => LoginPage(),
        'bottomBar': (BuildContext context) => BottomBarPage(),
        'homePage': (BuildContext context) => HomePage(),
        'cartaPage': (BuildContext context) => CartaDigitalPage(),
        'detallesProd': (BuildContext context) => DetallesProdPage(),
        'detallesProdRA': (BuildContext context) => DetallesProdPageRA(),
        'detallesProd2': (BuildContext context) => DetallesProdPage2(),
        'detallesProd3': (BuildContext context) => DetallesProdPage3(),
        'infoNutri': (BuildContext context) => InfoNutriPage(),
        'infoNutriRA': (BuildContext context) => InfoNutriPageRA(),
        'carrito': (BuildContext context) => CarritoPage(),
        'pedidos': (BuildContext context) => PedidosPage(),
        'webview': (BuildContext context) => WebviewPage(),
      },
    );
  }
}
