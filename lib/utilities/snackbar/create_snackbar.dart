import 'package:flutter/material.dart';
import 'custom_snackbar.dart';

SnackBar create_snackbar(String errorText) {
  SnackBar snackbar = SnackBar(
      content: CustomSnackBar(
        errorText: errorText,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0);

  return snackbar;
}
