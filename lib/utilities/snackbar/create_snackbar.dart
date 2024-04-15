import 'package:flutter/material.dart';
import 'custom_snackbar.dart';

SnackBar createErrorSnackbar(String errorText) {
  SnackBar snackbar = SnackBar(
      content: CustomErrorSnackBar(
        errorText: errorText,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0);

  return snackbar;
}


SnackBar createSuccessSnackbar(String errorText) {
  SnackBar snackbar = SnackBar(
      content: CustomSuccessSnackBar(
        successText: errorText,
      ),

      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0);

  return snackbar;
}
