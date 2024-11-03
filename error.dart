import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'main.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset('assets/error_image.png'), // Replace with your image path
            Html(
              data: 'Failed to load content. Please check your internet connection.</br>',
              style: {
                // Define the style for HTML elements
                'body': Style(
                  fontSize: FontSize(16.0),
                  textAlign: TextAlign.center
                ),
                'p': Style(
                  fontSize: FontSize(16.0),
                ),
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebviewContainer()));

              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}