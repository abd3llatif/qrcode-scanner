import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcodescanner/bloc/auth_bloc.dart';
import 'package:qrcodescanner/pages/home/home_page.dart';
import 'package:qrcodescanner/pages/login/login_page.dart';
import 'package:qrcodescanner/provider/auth_bloc_provider.dart';
import 'package:qrcodescanner/provider/progress_indicator.dart';
import 'package:qrcodescanner/provider/store_bloc_provider.dart';
import 'package:qrcodescanner/utils/app_utils.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:qrcodescanner/utils/firebase_config.dart';
import 'package:qrcodescanner/widgets/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

  // Production code
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();

  // open count
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('open_count', ((prefs.getInt('open_count') ?? 0) + 1));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _progressBloc = ProgressBloc();
  final _authBloc = AuthBloc();

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _initGoogleMobileAds();

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));

    AppUtils.updateFCMToken();

    return ProgressProvider(
      dialog: _progressBloc,
      child: AuthBlocProvider(
        bloc: _authBloc,
        child: StoreBlocProvider(
          store: Store(),
          child: MaterialApp(
            title: Constants.APP_NAME,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
              Locale('fr', ''), // English, no country code
              Locale('es', ''), // Spanish, no country code
            ],
            theme: ThemeData.dark().copyWith(
                textTheme: GoogleFonts.latoTextTheme(
                  Theme.of(context)
                      .textTheme,
                ),
                cardColor: Colors.white,
                backgroundColor: Colors.white,
                dialogBackgroundColor: Colors.white,
                brightness: Brightness.light,
                sliderTheme: const SliderThemeData(
                  thumbColor: Colors.white,
                  overlayColor: Colors.white60,
                  activeTrackColor: Colors.white,
                )),
            debugShowCheckedModeBanner: false,
            home: buildRoot(context),
          ),
        ),
      ),
    );
  }

  Widget buildRoot(BuildContext context) {
    return Stack(children: <Widget>[
      StreamBuilder(
          stream: _authBloc.user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data is User) {
                return const HomePage();
              } else {
                return LoginPage(_authBloc);
              }
            } else {
              return LoginPage(_authBloc);
            }
          }),
      ProgressDialog(),
    ]);
  }
}
