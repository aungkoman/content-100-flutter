import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../podo/category.dart';
import '../providers/home_provider.dart';
import '../helper/constants.dart';
import '../helper/api.dart';
import '../ui/genre.dart';

import '../widgets/book_list_item.dart';
import '../widgets/book_card.dart';
import '../widgets/spotlight.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class Home extends StatelessWidget {
  AdmobBannerSize bannerSize  = AdmobBannerSize.FULL_BANNER;
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, Widget child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "${Constants.appName}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ), // Add this,
          body: homeProvider.loading
              ? Column(
                children: [
                  getBanner(),
                  Expanded(
                    child: Center(
                        child: CircularProgressIndicator(),
                      ),
                  ),
                ],
              )
              : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                        onRefresh: () => homeProvider.getFeeds(),
                        child: ListView(
                          children: <Widget>[
                            getSearchBarUI(context),
                            Container(
                              height: 250,
                              child: Center(
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: homeProvider.top.feed?.entry.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    Entry entry = homeProvider.top.feed.entry[index];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: BookCard(
                                        img: entry.coverImage,
                                        entry: entry,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  stops: [0.015, 0.015],
                                  colors: [
                                    Color.fromRGBO(209, 2, 99, 1),
                                    Theme.of(context).backgroundColor
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Categories",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 60,
                              child: Center(
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: homeProvider.top.feed.link.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    Link link = homeProvider.top.feed.link[index];

                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.rightToLeft,
                                                child: Genre(
                                                  title: "${link.title}",
                                                  url: link.href,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                "${link.title}",
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Trending!",
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
                            SizedBox(
                              height: 5,
                            ),
                            GridView.builder(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              shrinkWrap: true,
                              physics: new NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                Entry entry = homeProvider.trends.feed.entry[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: SpotLight(
                                    img: entry.coverImage,
                                    title: entry.title,
                                    entry: entry,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  stops: [0.015, 0.015],
                                  colors: [
                                    Color.fromRGBO(209, 2, 99, 1),
                                    Theme.of(context).backgroundColor
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Breaking News",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: homeProvider.recent.feed.entry.length,
                              itemBuilder: (BuildContext context, int index) {
                                Entry entry = homeProvider.recent.feed.entry[index];

                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: BookListItem(
                                    img: entry.coverImage,
                                    title: entry.title,
                                    author: entry.category[0],
                                    desc: entry.summary
                                        .replaceAll(RegExp(r"<[^>]*>"), ''),
                                    entry: entry,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ),
                  getBanner()
                ],
              ),
        );
      },
    );
  }

  Widget getSearchBarUI(BuildContext context) {
    // Create a text controller and use it to retrieve the current value
    // of the TextField.
    final _txtSearch  = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 3, bottom: 3),
                  child: TextField(
                    controller: _txtSearch,
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search News...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _txtSearch.text.isEmpty ? Fluttertoast.showToast(
                    msg: "You just perform an empty search so we had nothing to show you.",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 5,
                  )
                      : Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: Genre(
                        title: "Search Result",
                        url: Api.searchUrl+_txtSearch.text,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,
                      size: 25,
                      color: Theme.of(context).backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
}
