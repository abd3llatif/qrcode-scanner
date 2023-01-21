import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qrcodescanner/pages/generateqrcode/btc_page.dart';
import 'package:qrcodescanner/pages/generateqrcode/sms_page.dart';
import 'package:qrcodescanner/pages/generateqrcode/url_page.dart';
import 'package:qrcodescanner/pages/generateqrcode/vcard_page.dart';
import 'package:qrcodescanner/pages/generateqrcode/wifi_page.dart';
import 'package:qrcodescanner/widgets/app_widgets.dart';

import 'txt_page.dart';

class GeneratorPage extends StatefulWidget {
  final String title;

  const GeneratorPage({Key? key, this.title = "Create QR"}) : super(key: key);

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  @override
  void initState() {
    super.initState();
  }

  int? open = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset('assets/images/img5.jpg').image,
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 36,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                      size: 42,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        sbutton(
                          context,
                          "Text",
                          Icons.text_fields_outlined,
                          () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const TxtPage(),
                                curve: Curves.easeInOut));
                          },
                        ),
                        sbutton(
                          context,
                          "vCard",
                          Icons.contact_phone_outlined,
                          () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const VCardPage(),
                                curve: Curves.easeInOut));
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        sbutton(
                          context,
                          "URL",
                          Icons.open_in_browser,
                          () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const URLPage(),
                                curve: Curves.easeInOut));
                          },
                        ),
                        sbutton(
                          context,
                          "WIFI",
                          Icons.wifi,
                          () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const WifiPage(),
                                curve: Curves.easeInOut));
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        sbutton(
                          context,
                          "Bitcoin",
                          Icons.currency_bitcoin_outlined,
                          () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const BTCPage(),
                                curve: Curves.easeInOut));
                          },
                        ),
                        sbutton(
                          context,
                          "SMS",
                          Icons.sms_outlined,
                          () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const SMSPage(),
                                curve: Curves.easeInOut));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
