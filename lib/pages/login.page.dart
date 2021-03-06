import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rielera_app/pages/bottonBar.page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: 'waiting',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == 'waiting') {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const BottomBarPage();
          }
        } else {
          return Scaffold(body: bodyWidget());
        }
      },
    );
  }

  Widget bodyWidget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return width > 1000
        ? SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  height: height - 15,
                  child: Container(
                    color: const Color(0xffEDEDED),
                    margin: const EdgeInsets.all(50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 10,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child:
                                        Image.asset('assets/facebook_logo.png'),
                                  )),
                              Flexible(
                                  flex: 4,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    child:
                                        Image.asset('assets/Logo_Sombra.png'),
                                    alignment: Alignment.center,
                                  )),
                              Flexible(
                                  flex: 8,
                                  fit: FlexFit.tight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: const [
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Text('BIENVENIDOS',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'Helvetica Nue',
                                                    color: Colors.black,
                                                    fontSize: 60,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Divider(
                                              color: Colors.black,
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 0,
                                      ),
                                      const Text(
                                          'Nueva Experiencia como Comensal',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: 'Helvetica Nue',
                                              color: Color(0xff767676),
                                              fontSize: 40,
                                              fontWeight: FontWeight.w300)),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      SizedBox(
                                        height: 70,
                                        child: InkWell(
                                            onTap: () async {
                                              signInWithGoogle(
                                                  context: context);
                                            },
                                            child: Image.asset(
                                                'assets/Login Google_Minimalist.png')),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: Divider(
                              color: Colors.black,
                              indent: width / 2,
                              thickness: 15,
                              height: 11),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Stack(
            children: [
              Container(
                color: Colors.black,
                width: double.maxFinite,
                height: double.maxFinite,
                child: Image.asset(
                  'assets/Fondo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  bottom: 100,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Text('BIENVENIDO',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w300)),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 70,
                        child: InkWell(
                            onTap: () async {
                              await signInWithGoogle(context: context);
                            },
                            child: Image.asset('assets/signGoogle.png')),
                      )
                    ],
                  ))
            ],
          );
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
        await guardarUser(user!.uid);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;

          await guardarUser(user!.uid);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }

  Future<http.Response> guardarUser(String uid) async {
    var response = await http.get(
      Uri.parse(
          'https://luisrojas24.pythonanywhere.com/set-usuario?id_Usuario=$uid'),
    );

    return response;
  }
}
