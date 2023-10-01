import 'package:flutter/material.dart';

void throwError(GlobalKey<ScaffoldMessengerState> k, String message) {
	k.currentState?.showSnackBar(
		SnackBar(
			content: Text(message),
			action: SnackBarAction(
				label: 'Dismiss',
				onPressed: () {
					k.currentState?.hideCurrentSnackBar();
				},
			),
		)
	);
}