import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, List<String> errors) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Errors"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: errors.map((e) => Text("• $e")).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ],
    ),
  );
}
