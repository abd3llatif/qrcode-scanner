import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:qrcodescanner/provider/progress_indicator.dart';
import 'package:qrcodescanner/provider/store_bloc_provider.dart';
import 'package:qrcodescanner/utils/ad_helper.dart';
import 'package:qrcodescanner/utils/app_utils.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:qrcodescanner/widgets/app_widgets.dart';
import 'package:qrcodescanner/widgets/progress.dart';

class FavoritesPage extends StatefulWidget {
  final String title;

  const FavoritesPage({Key? key, this.title = "Favorites"}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  int openCount = 0;

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

  int? open = 0;

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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: StoreBlocProvider.of(context)
                          .store
                          ?.scannerBloc
                          .getMyFavorites(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          List<Scan> scans = snapshot.data!.docs
                              .map((doc) => Scan.fromDoc(doc))
                              .toList();
            
                          if (scans.isEmpty) {
                            return Center(
                              child: Lottie.asset(
                                  'assets/animations/empty.json'),
                            );
                          }
                          return ListView(
                            children: scans
                                .map((scan) => scanItem(context, scan,
                                        opened: open == scans.indexOf(scan),
                                        onTap: () {
                                      openCount++;
            
                                      if (Constants.SHOW_INTERSTITIAL &&
                                          _isInterstitialAdReady &&
                                          openCount %
                                                  Constants
                                                      .REPEAT_INTERSTITIAL ==
                                              0) {
                                        _interstitialAd?.show();
                                        _loadInterstitialAd();
                                      }
                                      setState(() {
                                        if (open == scans.indexOf(scan)) {
                                          open = null;
                                        } else {
                                          open = scans.indexOf(scan);
                                        }
                                      });
                                    }, onDelete: (context) async {
                                      try {
                                        scan.isFav = false;
                                        await StoreBlocProvider.of(context)
                                            .store
                                            ?.scannerBloc
                                            .updateScan(scan);
                                      } catch (err) {
                                        print('$err');
                                      }
                                    }, onShare: (context) {
                                      AppUtils.shareScan(scan.text!);
                                    }))
                                .toList(),
                          );
                        } else {
                          return Center(
                            child:
                                Lottie.asset('assets/animations/empty.json'),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
          ProgressDialog(),
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
