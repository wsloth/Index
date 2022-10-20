import 'package:flutter/material.dart';

/// Generic error message that's centered on screen
/// TODO: Add link to appstore/contact form
Widget getGenericErrorWidget(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          "Something went wrong.",
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          "Please try again later, or contact the developer.",
          style: TextStyle(height: 2.5),
        ),
      ]),
    ),
  );
}
