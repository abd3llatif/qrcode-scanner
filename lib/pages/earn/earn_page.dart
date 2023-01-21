import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qrcodescanner/model/offer.dart';
import 'package:qrcodescanner/provider/progress_indicator.dart';
import 'package:qrcodescanner/provider/store_bloc_provider.dart';
import 'package:qrcodescanner/widgets/app_widgets.dart';
import 'package:qrcodescanner/widgets/progress.dart';

class EarnPage extends StatefulWidget {
  final String title;

  const EarnPage({Key? key, this.title = "Earn & Offers"}) : super(key: key);

  @override
  State<EarnPage> createState() => _EarnPageState();
}

class _EarnPageState extends State<EarnPage> {
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
                          ?.offersBloc
                          .getOffers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          List<Offer> offers = snapshot.data!.docs
                              .map((doc) => Offer.fromDoc(doc))
                              .toList();

                          if (offers.isEmpty) {
                            return Center(
                              child:
                                  Lottie.asset('assets/animations/empty.json'),
                            );
                          }

                          List<Widget> items = [];

                          for (int i = 0; i < offers.length; i++) {
                            items.add(offerTile(context, offers[i],
                                onClaim: offers[i].canClaim == true
                                    ? () async {
                                        ProgressProvider.of(context)
                                            .dialog
                                            ?.showProgress();
                                        await StoreBlocProvider.of(context)
                                            .store
                                            ?.offersBloc
                                            .claimOffer(offers[i]);
                                        ProgressProvider.of(context)
                                            .dialog
                                            ?.hideProgress();
                                      }
                                    : null));
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
