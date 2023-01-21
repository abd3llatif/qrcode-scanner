import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qrcodescanner/model/app.dart';
import 'package:qrcodescanner/provider/store_bloc_provider.dart';
import 'package:qrcodescanner/widgets/app_widgets.dart';
import 'package:qrcodescanner/widgets/progress.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppsPage extends StatefulWidget {
  final String title;

  const AppsPage({Key? key, this.title = "Our Apps"}) : super(key: key);

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  @override
  void initState() {
    super.initState();
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
                  StreamBuilder<QuerySnapshot>(
                      stream: StoreBlocProvider.of(context)
                          .store
                          ?.appsBloc
                          .getApps(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          List<App> apps = snapshot.data!.docs
                              .map((doc) => App.fromDoc(doc))
                              .toList();

                          if (apps.isEmpty) {
                              return Center(
                                child: Lottie.asset(
                                    'assets/animations/empty.json'),
                              );
                            }
            
                          List<Widget> items = [];
            
                          for(int i = 0; i < apps.length; i += 2) {
                            items.add(Row(
                              children: [
                                appbutton(context, apps[i]),
                                if(i < (apps.length - 1)) appbutton(context, apps[i+1])
                              ],
                            ));
                          }

                          return Column(
                            children: items,
                          );
                          
                        } else {
                          return Center(
                            child: Lottie.asset('assets/animations/empty.json'),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
          ProgressDialog(),
        ],
      ),
    );
  }
}
