import 'package:flutter/material.dart';

/// Returns a friendly readable URL, like
/// bbc.co.uk/path1/path2/... instead of
/// the full thing.
Text getReadableUrlWidget(final String url) {
  if (url == null) {
    return null;
  }

  // Build the readable URL, remove www.
  // subdomain and remove trailing slash
  final Uri temp = Uri.parse(url);
  final String parsedUrl =
    temp.host.replaceAll('www.', '')
    + (temp.path == '/' ? '' : temp.path);

    // Construct widget and set overflow behavior
  return Text(
    parsedUrl,
    overflow: TextOverflow.ellipsis,
  );
}
