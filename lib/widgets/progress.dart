import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcodescanner/provider/progress_indicator.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<bool>(
        stream: ProgressProvider.of(context).dialog?.show,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.data ?? false,
            child: Container(
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
              color: Colors.black54,
            )
          );
        });
  }
}
