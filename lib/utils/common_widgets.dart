import 'package:flutter/cupertino.dart';

class CommonWidgets {
  Future showDialog(BuildContext context, message) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        // title: const Text("title"),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}
