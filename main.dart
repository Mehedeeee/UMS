import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'firebase_options.dart';
import 'notification_services.dart';
import 'error.dart';
import 'package:flutter/services.dart';

@pragma('vm:entry_point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationServices().showNotification(message);
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization with Error Handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebviewContainer(),
    );
  }
}

class WebviewContainer extends StatefulWidget {
  @override
  _WebviewContainerState createState() => _WebviewContainerState();
}

class _WebviewContainerState extends State<WebviewContainer> {
  final Completer<WebViewController> _webViewController = Completer<WebViewController>();
  late NotificationServices notificationServices;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  Timer? _timer;
  bool isUsernameFound = false; // Flag to indicate if username is found
  String? _deviceToken; // To store the device token

  @override
  void initState() {
    super.initState();
    notificationServices = NotificationServices();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.initLocalNotifications(context);

    // Get the device token and store it in _deviceToken
    notificationServices.getDeviceToken().then((value) {
      setState(() {
        _deviceToken = value;
      });
      debugPrint('Device token: $value');
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _clearCache(); // Clear cache when app starts

    // Start the timer when the widget is initialized
    _startTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController.complete(webViewController);
            webViewController.loadUrl('https://ums.seu.edu.bd/');
          },

          onWebResourceError: (error) {
            _handleLoadError(error);
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://file-server') ||
                request.url.startsWith('https://ums-local.seu.edu.bd') ||
                request.url.startsWith('https://ums-api-service.seu.edu.bd')) {
              final link = Uri.decodeComponent(request.url);
              debugPrint("Blocked link ==> " + link);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final controller = await _webViewController.future;
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    }
    return true;
  }

  Future<void> _handleLoadError(WebResourceError error) async {
    Navigator.pop(context);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NoConnectionScreen()));
  }

  Future<void> _clearCache() async {
    final controller = await _webViewController.future;
    await controller.clearCache();
    debugPrint('Cache cleared');
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      myFunction();
      checkLocalStorageValue();
    });
  }

  void myFunction() {
    print("Function called at: ${DateTime.now()}");
  }

  Future<void> checkLocalStorageValue() async {
    final controller = await _webViewController.future;
    const String jsCode = '''
      (function() {
        return localStorage.getItem('username');
      })();
    ''';

    final result = await controller.runJavascriptReturningResult(jsCode);
    debugPrint("Local Storage Value for 'username': $result");

    // Check if the username value is not null or empty
    if (result != 'null' && result != '""') {
      if (!isUsernameFound) {
        debugPrint("Username found, stopping further checks temporarily.");
        isUsernameFound = true; // Set flag to true to stop checks

        // Call the function to store username and device token in Firestore
        saveUsernameAndDeviceTokenToFirestore(result, _deviceToken);
      }
    } else {
      if (isUsernameFound) {
        debugPrint("Username cleared, resuming checks.");
        isUsernameFound = false; // Set flag to false to resume checks
      }
    }
  }

  Future<void> saveUsernameAndDeviceTokenToFirestore(String username, String? deviceToken) async {
    try {
      debugPrint('Calling API');
      // Get a reference to the Firestore collection (e.g., 'users')
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Add or update a document with the username and device token
      await users.doc(username).set({
        'username': username,
        'deviceToken': deviceToken, // Store device token here
        'timestamp': FieldValue.serverTimestamp(), // Optional: store when this was added
      });

      debugPrint('Username and device token saved to Firestore: $username, $deviceToken');
    } catch (e) {
      debugPrint('Failed to save username and device token to Firestore: $e');
    }
  }
}
