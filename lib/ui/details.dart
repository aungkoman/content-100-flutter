import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:classic_flutter_news/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../podo/category.dart';
import '../providers/details_provider.dart';
import '../widgets/book_list_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: must_be_immutable
class Details extends StatelessWidget {
  final Entry entry;
  final String imgTag;
  final String titleTag;
  final String authorTag;

  AdmobBannerSize bannerSize  = AdmobBannerSize.FULL_BANNER;
  AdmobInterstitial interstitialAd;


  String getInterstitialAdUnitId(){
    // real android interstitial : ca-app-pub-7499955469448445/1089367570
    // test interstitial : ca-app-pub-3940256099942544/1033173712
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7499955469448445/1089367570';
    }
    return null;
  }

  void handleEventInter( AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
      //showSnackBar('New Admob $adType Ad loaded!');
        interstitialAd.show();
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
      //showSnackBar('Admob $adType Ad opened!');
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
      //showSnackBar('Admob $adType Ad closed!');
        print('Admob $adType Ad closed!');
        // _loadInterstitialAd();
        break;
      case AdmobAdEvent.failedToLoad:
      //showSnackBar('Admob $adType failed to load. :(');
        print('Admob $adType failed to load. :(');
        break;
      default:
    }
  }
  void _loadInterstitialAd(){
    print("loadInterstitialAd");
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        //if (event == AdmobAdEvent.closed) interstitialAd.load();
        print("interstitialAd event "+event.toString());
        handleEventInter(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
  }
  void showInterstitialAd() async{
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    } else {
      _loadInterstitialAd();
    }
  }

  String getBannerAdUnitId() {
    // test ca-app-pub-3940256099942544/6300978111
    // us ca-app-pub-7499955469448445/7990229562
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7499955469448445/7990229562';
    }
    return null;
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        //showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        //showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        //showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        //showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        print('Admob rewared');
        break;
      default:
    }
  }


  Widget getBanner(){

    if(kIsWeb) return Container();
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: bannerSize,
      listener: (AdmobAdEvent event,Map<String, dynamic> args) {
        print("listener AdmobAdEvent");
        handleEvent(event, args, 'Banner');
      },
      onBannerCreated:(AdmobBannerController controller) {
        print("onBannerCreated");
      },
    );
  }

  Details({
    Key key,
    @required this.entry,
    @required this.imgTag,
    @required this.titleTag,
    @required this.authorTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("internalWidgetBuild");
    _loadInterstitialAd();
    return Consumer<DetailsProvider>(
      builder: (BuildContext context, DetailsProvider detailsProvider,
          Widget child) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  if (detailsProvider.faved) {
                    detailsProvider.removeFav();
                  } else {
                    detailsProvider.addFav();
                  }
                },
                icon: Icon(
                  detailsProvider.faved
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: detailsProvider.faved
                      ? Colors.red
                      : Theme.of(context).iconTheme.color,
                ),
              ),

              IconButton(
                onPressed: () {
                  Share.share(
                    "I am Reading ${entry.title}. on ${Constants.appName}. \n\n Download App @ https://play.google.com/store/apps/details?id=${Constants.appPackage}",
                    subject:'${entry.title}',

                  );
                },
                icon: Icon(
                  Icons.share,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: Hero(
                          tag: imgTag,
                          child: CachedNetworkImage(
                            imageUrl: "${entry.coverImage}",
                            placeholder: (context, url) => Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.close),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: titleTag,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              "${entry.title.replaceAll(r"\", "")}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Container(
                                  child: Icon(
                                Icons.date_range,
                                color: Theme.of(context).accentColor,
                                size: 12.0,
                              )),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("${entry.published}",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.visibility,
                                  color: Theme.of(context).accentColor,
                                  size: 12.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("${entry.newsViews}",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        entry.category == null
                            ? SizedBox()
                            : Container(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: entry.category.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    String cat = entry.category[index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      margin: EdgeInsets.only(right: 5.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Theme.of(context).accentColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$cat',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  Html(
                    data: "${entry.summary}",
                    backgroundColor: Theme.of(context).backgroundColor,
                    linkStyle: const TextStyle(
                      color: Colors.redAccent,
                    ),
                    onLinkTap: (url) {
                    },
                    onImageTap: (src) {
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Related News!",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0.015, 0.015],
                        colors: [
                          Color.fromRGBO(209, 2, 99, 1),
                          Theme.of(context).backgroundColor
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  detailsProvider.loading
                      ? Container(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: detailsProvider.related.feed.entry.length,
                          itemBuilder: (BuildContext context, int index) {
                            Entry entry = detailsProvider.related.feed.entry[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: BookListItem(
                                img: entry.coverImage,
                                title: entry.title,
                                author: entry.category[0],
                                desc: entry.summary.replaceAll(RegExp(r"<[^>]*>"), ''),
                                entry: entry,
                              ),
                            );
                          },
                        ),
                ],
            ),
              ),
              getBanner()
        ]
          ),
        );
      },
    );
  }
}
