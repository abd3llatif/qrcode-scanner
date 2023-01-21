import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qrcodescanner/model/profile.dart';
import 'package:qrcodescanner/model/settings.dart';
import 'package:qrcodescanner/pages/apps/apps_page.dart';
import 'package:qrcodescanner/pages/earn/earn_page.dart';
import 'package:qrcodescanner/pages/favorites/favorites_page.dart';
import 'package:qrcodescanner/pages/home/op_item.dart';
import 'package:qrcodescanner/pages/myqrcodes/myqrcodes_page.dart';
import 'package:qrcodescanner/pages/scanner/scanner_page.dart';
import 'package:qrcodescanner/provider/auth_bloc_provider.dart';
import 'package:qrcodescanner/provider/store_bloc_provider.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:qrcodescanner/widgets/app_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../generateqrcode/generator_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool runned = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // setup settings
    initSettings();

    //invited by
    if (runned == false) {
      Future.delayed(const Duration(seconds: 5), () {
        isFirstTimeRegister();
      });
    }

    runned = true;
  }

  initSettings() async {
    AppSettings? settings =
        await StoreBlocProvider.of(context).store?.settingsBloc.getSettings();

    Profile profile = Profile.fromDoc(await StoreBlocProvider.of(context)
        .store
        ?.profileBloc
        .getMyProfileOnce());

    if (settings != null) {
      Constants.ANDROID_BANNER_AD_ID =
          settings.android_banner_ad_id ?? Constants.ANDROID_BANNER_AD_ID;
      Constants.ANDROID_INTERSTITIAL_AD_ID =
          settings.android_banner_ad_id ?? Constants.ANDROID_INTERSTITIAL_AD_ID;
      Constants.IOS_BANNER_AD_ID =
          settings.android_banner_ad_id ?? Constants.IOS_BANNER_AD_ID;
      Constants.IOS_INTERSTITIAL_AD_ID =
          settings.android_banner_ad_id ?? Constants.IOS_INTERSTITIAL_AD_ID;

      Constants.REPEAT_INTERSTITIAL =
          settings.repeat_interstitial ?? Constants.REPEAT_INTERSTITIAL;

      Constants.SHOW_BANNER = settings.show_banner ?? Constants.SHOW_BANNER;
      Constants.SHOW_INTERSTITIAL =
          settings.show_interstitial ?? Constants.SHOW_INTERSTITIAL;

      Constants.SHOW_FREEADS_OFFER =
          settings.show_freeads_offer ?? Constants.SHOW_FREEADS_OFFER;

      Constants.SHARE_WITH = settings.share_with ?? Constants.SHARE_WITH;

      // profile settings
      Constants.SHOW_BANNER = profile.isPro == true ? false : true;
      Constants.SHOW_INTERSTITIAL = profile.isPro == true ? false : true;

      Constants.ANNOUNCEMENTS = settings.announcements;

      setState(() {});
    }
  }

  // First time to register
  isFirstTimeRegister() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getBool('FT') == true) {
      List<String>? referral = await showTextInputDialog(
        context: context,
        title: AppLocalizations.of(context)!.referral,
        message:
            AppLocalizations.of(context)!.referraltxt,
        barrierDismissible: false,
        textFields: [
          DialogTextField(
              hintText: AppLocalizations.of(context)!.yourreferral,
              initialText: "",
              maxLines: 1,
              validator: (value) {
                if (value?.isNotEmpty == true) {
                  return null;
                }
                return 'Length should be 8 caracters';
              })
        ],
      );

      if (referral != null) {
        await StoreBlocProvider.of(context)
            .store
            ?.profileBloc
            .addInvitedBy(referral[0]);
      }

      await sp.setBool('FT', false);
    }
  }

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
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 36,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  FutureBuilder<Stream<DocumentSnapshot>>(
                future: StoreBlocProvider.of(context)
                    .store
                    ?.profileBloc
                    .getMyProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return StreamBuilder<DocumentSnapshot>(
                        stream: snapshot.data,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            Profile profile = Profile.fromDoc(snapshot.data);
                          if (profile.isPro == true) {
                            return Container(
                              height: 36,
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 207, 181, 59),
                                  )),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 207, 181, 59),
                                    size: 22,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.premium,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 207, 181, 59),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            );
                          }
                          return OutlinedButton.icon(
                              onPressed: () async {
                                showRemoveAdsDialog(
                                    context, profile.referral, 100);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white38),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white38),
                              ),
                              label: Text(
                                AppLocalizations.of(context)!.removeads,
                                style: const TextStyle(
                                    color: Constants.COLOR_PRIMARY,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              icon: const Icon(
                                Icons.ad_units_rounded,
                                color: Constants.COLOR_PRIMARY,
                                size: 28,
                              ));
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return Container();
                  }
                }),
                  const Spacer(),
                  IconButton(
                      onPressed: () async {
                        await AuthBlocProvider.of(context).signOut();
                      },
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: Colors.black,
                        size: 42,
                      )),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0, top: 16),
              child: Text(
                "iScanner",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.w900),
              ),
            ),
            FutureBuilder<Stream<DocumentSnapshot>>(
                future: StoreBlocProvider.of(context)
                    .store
                    ?.profileBloc
                    .getMyProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return StreamBuilder<DocumentSnapshot>(
                        stream: snapshot.data,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            Profile profile = Profile.fromDoc(snapshot.data);
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, bottom: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.score.replaceAll("%s", "${profile.points}"),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(width: 16,),
                                  const Text("•"),
                                  TextButton(onPressed: () {
                                    showAnnouncementsDialog(context, Constants.ANNOUNCEMENTS);
                                  }, child: const Text("Help"),)
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return Container();
                  }
                }),
            OpItem(
                title: AppLocalizations.of(context)!.scan,
                img: "assets/images/barcode.jpg",
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.fade, child:  ScannerPage(title:  AppLocalizations.of(context)!.scan,), curve: Curves.easeInOut));
                }),
            OpItem(
                title: AppLocalizations.of(context)!.favorites,
                img: "assets/images/favorites.jpg",
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.fade, child:  FavoritesPage(title: AppLocalizations.of(context)!.favorites,), curve: Curves.easeInOut));
                }),
            OpItem(
                title: AppLocalizations.of(context)!.createqr,
                img: "assets/images/qrcode.jpg",
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.fade, child: GeneratorPage(title: AppLocalizations.of(context)!.createqr,), curve: Curves.easeInOut));
                }),
            OpItem(
                title: AppLocalizations.of(context)!.myqrcodes,
                img: "assets/images/myqrs.jpg",
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.fade, child: MyQRcodesPage(title: AppLocalizations.of(context)!.myqrcodes,), curve: Curves.easeInOut));
                }),
            OpItem(
                title: AppLocalizations.of(context)!.ourapps,
                img: "assets/images/apps.jpg",
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.fade, child: AppsPage(title: AppLocalizations.of(context)!.ourapps,), curve: Curves.easeInOut));
                }),
            OpItem(
                title: AppLocalizations.of(context)!.earn,
                img: "assets/images/earn.jpg",
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.fade, child: EarnPage(title: AppLocalizations.of(context)!.earn,), curve: Curves.easeInOut));
                
                 }),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text("${Constants.APP_NAME} - ${Constants.APP_VERSION}", style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }

  reviewOnStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("open_count ${prefs.getInt('open_count')}");
    if (prefs.getInt('open_count') == 3 ||
        prefs.getInt('open_count') == 10 ||
        prefs.getInt('open_count') == 15) {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }
}
