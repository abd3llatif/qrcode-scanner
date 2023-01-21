import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:qrcodescanner/bloc/auth_bloc.dart';
import 'package:qrcodescanner/provider/progress_indicator.dart';
import 'package:qrcodescanner/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  final AuthBloc authBloc;

  LoginPage(this.authBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: splash(context));
  }

  Widget splash(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset("assets/images/splash.jpg").image,
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.black.withOpacity(0.3)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Spacer(flex: 10),
              // Text(
              //   AppLocalizations.of(context)!.iintro,
              //   style: const TextStyle(
              //       color: Colors.white,
              //       fontSize: 24,
              //       fontWeight: FontWeight.w700),
              //   textAlign: TextAlign.center,
              // ),
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.intro,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: SignInButton(
                  Buttons.Facebook,
                  onPressed: () async {
                    ProgressProvider.of(context).dialog!.showProgress();
                    try {
                      await authBloc.signInWithFacebook();
                    } catch (err) {
                      print(err);
                    } finally {
                      ProgressProvider.of(context).dialog!.hideProgress();
                    }
                  },
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  text: AppLocalizations.of(context)!.loginwithfacebook,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    ProgressProvider.of(context).dialog!.showProgress();
                    try {
                      await authBloc.signInWithGoogle();
                    } catch (err) {
                      print(err);
                    } finally {
                      ProgressProvider.of(context).dialog!.hideProgress();
                    }
                  },
                  text: AppLocalizations.of(context)!.loginwithgoogle,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: button(context, "S'identifier", () {
              //     // setState(() {
              //     //   showSplash = false;
              //     // });
              //   }),
              // ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    AppUtils.openLink("https://goviral.ma");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.asset(
                      "assets/images/goviral.png",
                      height: 81,
                    ),
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.madeby,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
