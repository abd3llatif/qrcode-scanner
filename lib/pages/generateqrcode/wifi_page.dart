import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:qrcodescanner/utils/ad_helper.dart';
import 'package:qrcodescanner/widgets/app_dialogs.dart';
import 'package:qrcodescanner/widgets/app_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/constants.dart';

class WifiPage extends StatefulWidget {
  final String title;

  const WifiPage({Key? key, this.title = "WIFI"}) : super(key: key);

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  int genCount = 0;
  

  @override
  void initState() {
    super.initState();

     _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    if (Constants.SHOW_BANNER) {
      //load banner
      _bannerAd.load();
    }

    if (Constants.SHOW_INTERSTITIAL) {
      // load interstitial
      _loadInterstitialAd();
    }
  }

  TextEditingController ssidController = TextEditingController();
  TextEditingController pController = TextEditingController();

  FocusNode ssidNode = FocusNode();
  FocusNode pNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
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
                      if (_isBannerAdReady)
                        SizedBox(
                          height: _bannerAd.size.height.toDouble(),
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
                  txtField(ssidController, "SSID", Icons.wifi,
                      TextInputType.name, focusNode: ssidNode, nextNode: pNode,),
                  txtField(pController, AppLocalizations.of(context)!.password, Icons.password,
                      TextInputType.name, focusNode: pNode),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                    child: button(context, AppLocalizations.of(context)!.createqr, () {
                      genCount++;

                      if (Constants.SHOW_INTERSTITIAL &&
                          _isInterstitialAdReady &&
                          genCount % Constants.REPEAT_INTERSTITIAL == 0) {
                        _interstitialAd?.show();
                        _loadInterstitialAd();
                      }

                      Scan scan = Scan(text: "WIFI:T:WPA;S:${ssidController.text};P:${pController.text};H:;", type: 'generated', isWifi: true);
                      generateQR(
                        context,
                        scan,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        if (_isBannerAdReady)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 36),
                child: SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget txtField(TextEditingController controller, String label, IconData icon,
          TextInputType? keyBoardType, {focusNode, nextNode}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x55003366),
                    blurStyle: BlurStyle.outer,
                    blurRadius: 12)
              ]),
          child: TextFormField(
            focusNode: focusNode,
            textInputAction: nextNode != null ? TextInputAction.next : TextInputAction.done,
            onFieldSubmitted: (v){
                FocusScope.of(context).requestFocus(nextNode);
              },
            keyboardType: keyBoardType ?? TextInputType.text,
            controller: controller,
            style: const TextStyle(color: Color(0xFF003366)),
            minLines: 1,
            maxLines: 1,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: label,
                icon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    icon,
                    color: const Color(0xFF003366),
                  ),
                ),
                iconColor: const Color(0xFF003366),
                hintStyle: const TextStyle(color: Color(0x88003366))),
          ),
        ),
      );

      void _loadInterstitialAd() {
    print("******** load interstitial ad ********");
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // _moveToHome();
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }
}
