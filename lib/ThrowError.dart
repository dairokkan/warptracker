import 'package:flutter/material.dart';
import './main.dart';

void throwError(String message) {
	scaffoldKey.currentState?.showSnackBar(
		SnackBar(
			content: Text(message),
			action: SnackBarAction(
				label: 'Dismiss',
				onPressed: () {
					scaffoldKey.currentState?.hideCurrentSnackBar();
				},
			),
		)
	);
}