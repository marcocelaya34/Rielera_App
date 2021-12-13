import 'package:flutter/material.dart';
/* import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart'; */

class WebviewPage extends StatefulWidget {
  const WebviewPage({Key? key}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  /* InAppWebViewController _webViewController; */

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, 'detallesProd');
        return;
      } as Future<bool> Function()?,
      child: Scaffold(
        body: Column(
          children: [
           /*  FutureBuilder(
              future: permisos(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: double.maxFinite,
                    height: 600,
                    /* child:   InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.https('ra-gif.web.app', '/index.html')),
                      initialOptions: InAppWebViewGroupOptions(
                        
                        crossPlatform: InAppWebViewOptions(
                          mediaPlaybackRequiresUserGesture: false,
                          
                        
                        ),
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        _webViewController = controller;
                      },
                      androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                        return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                      }
                  ), */
                  );
                } else {
                  return Text('Concede Permisos');
                }
              },
            ), */
            InkWell(
              onTap: () async {
               /*  await Permission.camera.request();
                await Permission.microphone.request(); */
                print('Helo');
                setState(() {});
              },
              child: Container(
                width: double.maxFinite,
                height: 100,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

 /*  Future permisos() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    return Permission.camera.isGranted;
  } */
}
