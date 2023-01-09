import 'package:flutter/material.dart';

class SnackBarService {
  static SnackBarService instance = SnackBarService();
  late BuildContext _context;

  SnackBarService();

  set context(BuildContext context) {
    _context = context;
  }

  void showSuccessSnackBar(String message) {
    final SnackBar snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Theme.of(_context).primaryColor,
    );
    ScaffoldMessenger.of(_context).showSnackBar(snackbar);
  }

  void showFailureSnackBar(String message) {
    final SnackBar snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Theme.of(_context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    ScaffoldMessenger.of(_context).showSnackBar(snackbar);
  }
}
