import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:qrcodescanner/utils/ad_helper.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:qrcodescanner/widgets/app_dialogs.dart';
import 'package:qrcodescanner/widgets/app_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VCardPage extends StatefulWidget {
  final String title;

  const VCardPage({Key? key, this.title = "vCard"}) : super(key: key);

  @override
  State<VCardPage> createState() => _VCardPageState();
}

class _VCardPageState extends State<VCardPage> {

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

  TextEditingController fnController = TextEditingController();
  TextEditingController lnController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  FocusNode fnNode = FocusNode();
  FocusNode lnNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode companyNode = FocusNode();
  FocusNode jobNode = FocusNode();
  FocusNode countryNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode cityNode = FocusNode();
  FocusNode zipNode = FocusNode();
  FocusNode urlNode = FocusNode();

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
                  txtField(fnController, AppLocalizations.of(context)!.firstname, Icons.person_outline,
                      TextInputType.name, focusNode: fnNode, nextNode: lnNode,),
                  txtField(lnController, AppLocalizations.of(context)!.lastname, Icons.person_outline,
                      TextInputType.name, focusNode: lnNode, nextNode: phoneNode,),
                  txtField(
                      phoneController, AppLocalizations.of(context)!.phone, Icons.phone, TextInputType.phone, focusNode: phoneNode, nextNode: emailNode,),
                  txtField(emailController, AppLocalizations.of(context)!.email, Icons.email_outlined,
                      TextInputType.emailAddress, focusNode: emailNode, nextNode: companyNode,),
                  txtField(companyController, AppLocalizations.of(context)!.company, Icons.work_outline,
                      TextInputType.name, focusNode: companyNode, nextNode: jobNode,),
                  txtField(
                      jobController, AppLocalizations.of(context)!.job, Icons.work_outline, TextInputType.text, focusNode: jobNode, nextNode: addressNode,),
                  txtField(addressController, AppLocalizations.of(context)!.address, Icons.emoji_transportation,
                      TextInputType.streetAddress, focusNode: addressNode, nextNode: cityNode,),
                  txtField(cityController, AppLocalizations.of(context)!.city, Icons.emoji_transportation,
                      TextInputType.name, focusNode: cityNode, nextNode: zipNode,),
                  txtField(zipController, AppLocalizations.of(context)!.zip, Icons.emoji_transportation,
                      TextInputType.number, focusNode: zipNode, nextNode: countryNode,),
                  txtField(countryController, AppLocalizations.of(context)!.country, Icons.emoji_transportation,
                      TextInputType.name, focusNode: countryNode, nextNode: urlNode,),
                  txtField(urlController, AppLocalizations.of(context)!.website, Icons.open_in_browser,
                      TextInputType.url, focusNode: urlNode),
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
                      
                      String vcard = """BEGIN:VCARD
VERSION:3.0
N:${lnController.text};${fnController.text};
FN:${fnController.text} ${lnController.text}
ORG:${companyController.text}
ADR;TYPE#HOME:;;${addressController.text};${cityController.text};;${zipController.text};${countryController.text}
TEL;TYPE#WORK,VOICE:${phoneController.text}
TEL;TYPE#HOME,VOICE:${phoneController.text}
EMAIL:${emailController.text}
URL:${urlController.text}
END:VCARD""";
                        print(vcard);

                        Scan scan = Scan(text: vcard, type: 'generated', isVCard: true);
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
