import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:qrcodescanner/provider/progress_indicator.dart';
import 'package:qrcodescanner/provider/store_bloc_provider.dart';
import 'package:qrcodescanner/utils/ad_helper.dart';
import 'package:qrcodescanner/utils/app_utils.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:qrcodescanner/widgets/app_dialogs.dart';
import 'package:qrcodescanner/widgets/app_widgets.dart';
import 'package:qrcodescanner/widgets/progress.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerPage extends StatefulWidget {
  final String title;

  const ScannerPage({Key? key, this.title = "Scan"}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  int scanCount = 0;

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
                Center(
                  child: lbutton(context, "Scan", Icons.qr_code_scanner,
                      () async {
                    ProgressProvider.of(context).dialog?.showProgress();
                    try {
                      String barcodeScanRes =
                          await FlutterBarcodeScanner.scanBarcode(
                              '#FF003366', 'Cancel', true, ScanMode.QR);

                      if (barcodeScanRes == '-1') {
                        ProgressProvider.of(context).dialog?.hideProgress();
                        return;
                      }

                      scanCount++;

                      if (Constants.SHOW_INTERSTITIAL &&
                          _isInterstitialAdReady &&
                          scanCount % Constants.REPEAT_INTERSTITIAL == 0) {

                        _interstitialAd?.show();
                        _loadInterstitialAd();

                      }

                      Scan scan = Scan(text: barcodeScanRes);

                      if (barcodeScanRes.contains("BEGIN:VCARD")) {
                        scan.isVCard = true;
                      }

                      if (barcodeScanRes.contains("WIFI:") &&
                          barcodeScanRes.contains("T:") &&
                          barcodeScanRes.contains("S:") &&
                          barcodeScanRes.contains("P:")) {
                        scan.isWifi = true;
                      }

                      if (barcodeScanRes.startsWith("SMSTO:")) {
                        scan.isSMS = true;
                      }

                      // maybe we want to wait for this
                      StoreBlocProvider.of(context)
                          .store
                          ?.scannerBloc
                          .addMyScan(scan);
                      if (await canLaunch(barcodeScanRes)) {
                        await showScanDialog(context, barcodeScanRes);
                      }
                    } catch (err) {
                      print("Error : $err");
                    }
                    ProgressProvider.of(context).dialog?.hideProgress();
                  },
                  iconWidget: Lottie.asset('assets/animations/scan.json', width: 81),
                  bgcolor: Constants.COLOR_PRIMARY.withAlpha(0)),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: StoreBlocProvider.of(context)
                          .store
                          ?.scannerBloc
                          .getMyScans(),
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
                                      setState(() {
                                        if (open == scans.indexOf(scan)) {
                                          open = null;
                                        } else {
                                          open = scans.indexOf(scan);
                                        }
                                      });
                                    }, onDelete: (context) async {
                                      try {
                                        scan.visible = false;
                                        await StoreBlocProvider.of(context)
                                            .store
                                            ?.scannerBloc
                                            .updateScan(scan);
                                      } catch (err) {
                                        print('$err');
                                      }
                                    }, onShare: (context) {
                                      AppUtils.shareScan(scan.text!);
                                    }, onSave: (context) async {
                                      if (scan.isFav ?? false) {
                                        scan.isFav = false;
                                      } else {
                                        scan.isFav = true;
                                      }
                                      await StoreBlocProvider.of(context)
                                          .store
                                          ?.scannerBloc
                                          .updateScan(scan);
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

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
}
