import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:qrcodescanner/utils/ad_helper.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:qrcodescanner/widgets/app_dialogs.dart';
import 'package:qrcodescanner/widgets/app_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TxtPage extends StatefulWidget {
  final String title;

  const TxtPage({Key? key, this.title = "Text"}) : super(key: key);

  @override
  State<TxtPage> createState() => _TxtPageState();
}

class _TxtPageState extends State<TxtPage> {
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

  TextEditingController tController = TextEditingController();

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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
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
                        controller: tController,
                        style: const TextStyle(color: Color(0xFF003366)),
                        minLines: 4,
                        maxLines: 4,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.lbltxt,
                            icon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                Icons.text_fields_outlined,
                                color: Color(0xFF003366),
                              ),
                            ),
                            iconColor: Color(0xFF003366),
                            hintStyle: TextStyle(color: Color(0x88003366))),
                      ),
                    ),
                  ),
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

                      Scan scan = Scan(text: tController.text, type: 'generated');
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
