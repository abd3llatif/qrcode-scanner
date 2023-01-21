import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:qrcodescanner/provider/store_bloc_provider.dart';
import 'package:qrcodescanner/utils/app_utils.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showSuccessDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/img/success.gif'),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Opération terminée avec succès",
          style: TextStyle(
              color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showWeWillTryLaterDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/img/no_internet.gif'),
        //\nNe t'inquiète pas! Vos données sont enregistrées localement.
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Quelque chose s'est passé dans le réseau !\nNous réessayerons plus tard",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showScanDialog(BuildContext context, String text) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //\nNe t'inquiète pas! Vos données sont enregistrées localement.
        const SizedBox(
          height: 12,
        ),
        Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        )
      ],
    ),
    actions: [
      TextButton(
          onPressed: () async {
            if (await canLaunch(text)) {
              await launch(text);
              Navigator.of(context).pop();
            }
          },
          child: FutureBuilder<bool>(
              future: canLaunch(text),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Text(AppLocalizations.of(context)!.open);
                } else {
                  return Text(AppLocalizations.of(context)!.ok);
                }
              }))
    ],
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAnnouncementsDialog(
    BuildContext context, Map? announcements) {
  String? content = "";

  for (String key in announcements?.keys ?? []) {
    if (AppLocalizations.of(context)!.lang == key) {
      content = announcements![key];
    }
  }

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    content: SizedBox(
      height: MediaQuery.of(context).size.height / 1.3,
      child: SingleChildScrollView(
        child: Html(
            data: content,
            onLinkTap: (String? url, RenderContext context,
                Map<String, String> attributes, element) {
              AppUtils.openLink(url ?? "");
            }),
      ),
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showRemoveAdsDialog(BuildContext context, referral, points) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.removeads,
          style: const TextStyle(
              color: Constants.COLOR_PRIMARY,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        Container(
          child: Lottie.asset('assets/animations/removeads.json'),
        ),
        Text(
          AppLocalizations.of(context)!
              .removeadstxt
              .replaceAll('%s', "$points"),
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$referral",
            style: const TextStyle(
                color: Constants.COLOR_PRIMARY,
                fontWeight: FontWeight.normal,
                fontSize: 24),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            AppUtils.shareApp(referral, points);
          },
          child: Text(
            AppLocalizations.of(context)!.shareapp,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 207, 181, 59)),
            foregroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 207, 181, 59)),
          ),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

generateQR(BuildContext context, Scan scan, {bool save = true}) async {
  final gKey = GlobalKey();

  // AlertDialog animation = AlertDialog(
  //   backgroundColor: Colors.white,
  //   content: Lottie.asset('assets/animations/generator.json', width: MediaQuery.of(context).size.width / 1.5),
  // );
  // showDialog(
  //   barrierDismissible: false,
  //   context: context,
  //   builder: (BuildContext context) {
  //     return animation;
  //   },
  // );

  // await Future.delayed(const Duration(seconds: 2), () {
  //   Navigator.of(context).pop();
  // },);

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.width / 1.5,
            child: RepaintBoundary(
                key: gKey,
                child: QrImage(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    data: scan.text ?? "Humm!",
                    version: QrVersions.auto,
                    size: MediaQuery.of(context).size.width / 1.5,
                    errorStateBuilder: (cxt, err) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.somthingwentworng,
                          textAlign: TextAlign.center,
                        ),
                      );
                    })),
          ),
        )
      ],
    ),
    actions: [
      TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel)),
      if (save)
        TextButton(
            onPressed: () async {
              await StoreBlocProvider.of(context)
                  .store
                  ?.scannerBloc
                  .addMyScan(scan);
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.save)),
      TextButton(
          onPressed: () async {
            captureAndShareQR(context, gKey);
          },
          child: Text(AppLocalizations.of(context)!.share)),
    ],
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<void> captureAndShareQR(context, gKey) async {
  try {
    RenderRepaintBoundary boundary = gKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();

    final tempDir = Platform.isIOS
        ? await path_provider.getDownloadsDirectory()
        : await path_provider.getExternalStorageDirectory();
    final file = await File('${tempDir?.path}/image.png').create();
    await file.writeAsBytes(pngBytes!);

    // Toast.show(file.path, context,
    //           duration: Toast.LENGTH_SHORT,
    //           gravity: Toast.BOTTOM,
    //           backgroundColor: const Color(0xFF003366));

    await Share.shareFiles([file.path]);
  } catch (e) {
    print(e.toString());
  }
}
