import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
/* import 'package:permission_handler/permission_handler.dart'; */
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:rielera_app/pages/bottonBar.page.dart';
import 'package:rielera_app/pages/carrito.page.dart';
import 'package:rielera_app/pages/carta.page.dart';
import 'package:rielera_app/pages/detallesProd.page.dart';
import 'package:rielera_app/pages/home.page.dart';
import 'package:rielera_app/pages/infoNutri.page.dart';
import 'package:rielera_app/pages/login.page.dart';
import 'package:rielera_app/pages/pedidos.page.dart';
import 'package:rielera_app/pages/pedidos.page.dart';
import 'package:rielera_app/providers/carrito.provider.dart';
import 'package:rielera_app/providers/bar.provider.dart';
import 'package:rielera_app/providers/platillo.provider.dart';

Future main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await Firebase?.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            const MainApp(),
            maxWidth: double.maxFinite,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(300,
                  name: MOBILE, scaleFactor: 1),
              const ResponsiveBreakpoint.resize(500,
                  name: MOBILE, scaleFactor: 1),
              const ResponsiveBreakpoint.resize(750,
                  name: TABLET, scaleFactor: 1),
              const ResponsiveBreakpoint.resize(1000,
                  name: DESKTOP, scaleFactor: 1),
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
        'loginPage': (BuildContext context) => const LoginPage(),
        'bottomBar': (BuildContext context) => const BottomBarPage(),
        'homePage': (BuildContext context) => const HomePage(),
        'cartaPage': (BuildContext context) => const CartaDigitalPage(),
        'detallesProd': (BuildContext context) => const DetallesProdPage(),
        'infoNutri': (BuildContext context) => const InfoNutriPage(),
        'carrito': (BuildContext context) => const CarritoPage(),
        'pedidos': (BuildContext context) => const PedidosPage(),
      },
    );
  }
}
