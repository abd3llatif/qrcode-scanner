import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qrcodescanner/model/app.dart';
import 'package:qrcodescanner/model/offer.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:qrcodescanner/model/vcard.dart';
import 'package:qrcodescanner/utils/app_utils.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget button(BuildContext context, String label, Function() onTap,
    {colors = const [Color(0xFF003366), Color.fromARGB(255, 1, 84, 167)]}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 54,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

Widget sbutton(
    BuildContext context, String label, IconData icon, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.width / 2.5,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color(0x55003366),
                blurStyle: BlurStyle.outer,
                blurRadius: 12)
          ]),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.black,
            ),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget offerTile(BuildContext context, Offer offer, {onClaim}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(.9),
          boxShadow: const [
            BoxShadow(
                color: Color(0x55003366),
                blurStyle: BlurStyle.outer,
                blurRadius: 20)
          ]),

    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Constants.COLOR_PRIMARY.withOpacity(0.8),
          ),

            child: Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${offer.points}",  style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),),
                       const Text(" pts",  style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(offer.title ?? "", textAlign: TextAlign.start, style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.bold), ),
            Text(offer.desc ?? "", style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.normal), textAlign: TextAlign.start,),
          ],
        )),
        if(offer.canClaim == true)  Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextButton(onPressed: onClaim, child: Text(AppLocalizations.of(context)!.claim)),
        )
      ],
    ),
        
  );
}



Widget appbutton(
    BuildContext context, App app) {
  return GestureDetector(
    onTap: () {
      if(Platform.isAndroid) {
        AppUtils.openLink(app.android ?? "");
      } else if (Platform.isIOS) {
        AppUtils.openLink(app.ios ?? "");
      }
    },
    child: Container(
      margin: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.width / 2.5,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color(0x55003366),
                blurStyle: BlurStyle.outer,
                blurRadius: 40)
          ]),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(app.icon ?? "", height:  MediaQuery.of(context).size.width / 4, width:  MediaQuery.of(context).size.width / 4,),
            ),
            Text(
              app.name ?? "",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget lbutton(
    BuildContext context, String label, IconData icon, Function() onTap, {iconWidget, bgcolor = Colors.white}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.width / 2.5,
      width: MediaQuery.of(context).size.width - 48,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgcolor,
          boxShadow: const [
            BoxShadow(
                color: Color(0x55003366),
                blurStyle: BlurStyle.outer,
                blurRadius: 12)
          ]),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconWidget ?? Icon(
              icon,
              size: 48,
              color: Colors.black,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget scanItem(BuildContext context, Scan scan,
    {Function(BuildContext)? onDelete,
    Function(BuildContext)? onShare,
    Function(BuildContext)? onSave,
    Function(BuildContext)? onGenQR,
    onTap,
    opened = false}) {
  String txt = scan.text ?? "";

  if (scan.isVCard ?? false) {
    Map<String, dynamic> vc = vcard(scan);

    txt = """
${vc['FN']}
${vc['EMAIL']}
${vc['TEL']}
${vc['URL'] ?? ''}""";
  }

  if (scan.isWifi ?? false) {
    Map<String, String> params = wifi(scan);
    txt = """
SSID: ${params['ssid']}
${AppLocalizations.of(context)!.password}: ${params['password']}""";
  }

  if (scan.isSMS ?? false) {
    txt = """
Phone: ${txt.split(':')[1]}
Message: ${txt.split(':')[2]}""";
  }
  return Slidable(
    endActionPane: ActionPane(
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          onPressed: onDelete,
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: AppLocalizations.of(context)!.del,
        ),
        SlidableAction(
          onPressed: onShare,
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.share,
          label: AppLocalizations.of(context)!.share,
        ),
        if (onSave != null)
          SlidableAction(
            onPressed: onSave,
            backgroundColor: const Color.fromARGB(255, 139, 90, 196),
            foregroundColor: Colors.white,
            icon: scan.isFav == true ? Icons.favorite : Icons.favorite_border,
            label: AppLocalizations.of(context)!.save,
          ),
        if (onGenQR != null)
         SlidableAction(
            onPressed: onGenQR,
            backgroundColor: const Color.fromARGB(255, 68, 40, 194),
            foregroundColor: Colors.white,
            icon: Icons.qr_code_rounded,
            label: 'QR',
          ),
      ],
    ),
    child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 16, top: 16, bottom: 16, right: 16),
                margin: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x55003366),
                          blurStyle: BlurStyle.outer,
                          blurRadius: 12)
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        txt,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Icon(type(scan), size: 30, color: Constants.COLOR_PRIMARY),
                  ],
                ),
              ),
              if (opened) actions(context, scan),
            ],
          ),
        ),
        
  );
}

IconData? type(Scan? scan) {
  if (scan?.isLink ?? false) return Icons.open_in_browser;
  if (scan?.isVCard ?? false) return Icons.contact_phone_outlined;
  if (scan?.isWifi ?? false) return Icons.wifi;
  if (scan?.isSMS ?? false) return Icons.sms_outlined;

  return Icons.text_fields_outlined;
}

Map<String, String> wifi(Scan scan) {
  Map<String, String> wifi = <String, String>{};
  List<String> params = (scan.text?.substring(5) ?? '').split(';');
  print("$params");
  for (String param in params) {
    if (param.startsWith('S:')) {
      wifi['ssid'] = param.substring(2);
    }
    if (param.startsWith('P:')) {
      wifi['password'] = param.substring(2);
    }
    if (param.startsWith('T:')) {
      wifi['type'] = param.substring(2);
    }
  }
  return wifi;
}

Map<String, dynamic> vcard(Scan scan) {
  Map<String, dynamic> vcard = VcardParser(scan.text ?? "").parse();
  Map<String, dynamic> map = {};
  
  try {
    map.addAll({'FN': vcard['FN'] ?? vcard['N']});
    map.addAll({'EMAIL': vcard['EMAIL'] ?? vcard['EMAIL;WORK;INTERNET']['value']});
    map.addAll({'TEL': vcard['TEL;WORK;VOICE']['value']});
    map.addAll({'URL': vcard['URL']});
  } catch (err) {
    print("$err");
  }

  return map;
}

Widget actions(BuildContext context, Scan scan) {
  if (scan.isLink ?? false) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          listButton(Icons.open_in_browser, () async {
            if (await canLaunch(scan.text ?? "")) {
              await launch(scan.text ?? "");
            }
          }),
          listButton(Icons.share, () async {
            AppUtils.shareScan(scan.text ?? "");
          }),
          listButton(Icons.copy, () async {
            await Clipboard.setData(ClipboardData(text: scan.text!));

            Toast.show(AppLocalizations.of(context)!.copied, context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.BOTTOM,
                backgroundColor: const Color(0xFF003366));
          }),
        ],
      ),
    );
  } else if (scan.isVCard ?? false) {
    Map<String, dynamic> vc = vcard(scan);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          listButton(Icons.person_add_alt, () {
            AppUtils.addContact(Contact(
                emails: [Item(label: 'EMAIL', value: vc['EMAIL'] ?? '')],
                displayName: vc['FN'] ?? "",
                familyName: vc['FN'].split("")[1] ?? "",
                phones: [Item(label: 'PHONE', value: vc['TEL'] ?? "")]));
          }),
          if (vc['EMAIL'] != null)
            listButton(Icons.mail_outline, () {
              AppUtils.sendEmail(vc['EMAIL']);
            }),
          if (vc['TEL'] != null)
            listButton(Icons.phone, () async {
              AppUtils.call(vc['TEL']);
            }),
          if (vc['URL'] != null)
            listButton(Icons.open_in_browser, () async {
              AppUtils.openLink(vc['URL']);
            }),
          listButton(Icons.share, () async {
            AppUtils.shareScan("""
${vc['FN']}
${vc['EMAIL']}
${vc['TEL']}
${vc['URL'] ?? ''}""");
          }),
          listButton(Icons.copy, () async {
            await Clipboard.setData(ClipboardData(text: """
${vc['FN']}
${vc['EMAIL']}
${vc['TEL']}
${vc['URL'] ?? ''}"""));

            Toast.show("Copied to clipboard!", context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.BOTTOM,
                backgroundColor: const Color(0xFF003366));
          }),
        ],
      ),
    );
  } else if (scan.isWifi ?? false) {
    Map<String, String> params = wifi(scan);
    String txt = """
SSID: ${params['ssid']}
${AppLocalizations.of(context)!.password}: ${params['password']}
TYPE: ${params['type']}""";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // listButton(Icons.wifi, () async {
          //   print("${[params['ssid'], params['password'], params['type']]}");
          //   bool state = await AppUtils.connectToWifi(params['ssid'], params['password'], params['type']);
          // }),
          listButton(Icons.share, () async {
            AppUtils.shareScan(txt);
          }),
          listButton(Icons.copy, () async {
            await Clipboard.setData(ClipboardData(text: "${params['password']}"));
            Toast.show(AppLocalizations.of(context)!.copied, context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.BOTTOM,
                backgroundColor: const Color(0xFF003366));
          }),
        ],
      ),
    );
  } else if (scan.isSMS ?? false) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          listButton(Icons.sms_outlined, () async {
            AppUtils.iSendSMS(
                scan.text?.split(':')[1], scan.text?.split(':')[2]);
          }),
          listButton(Icons.share, () async {
            AppUtils.shareScan(scan.text!);
          }),
          listButton(Icons.copy, () async {
            await Clipboard.setData(ClipboardData(text: scan.text!));
            Toast.show(AppLocalizations.of(context)!.copied, context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.BOTTOM,
                backgroundColor: const Color(0xFF003366));
          }),
        ],
      ),
    );
  } else {
    return Container();
  }
}

Widget listButton(IconData icon, onTap) {
  return Expanded(
    child: Center(
      child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Color(0x55003366),
                    blurStyle: BlurStyle.outer,
                    blurRadius: 6)
              ]),
          child: IconButton(
            icon: Icon(
              icon,
              size: 28,
              color: Constants.COLOR_PRIMARY,
            ),
            onPressed: onTap,
          )),
    ),
  );
}
