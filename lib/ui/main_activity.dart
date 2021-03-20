import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_alert_dialog.dart';
import '../helper/Constants.dart';
import '../providers/favorites_provider.dart';

import 'home.dart';
import 'explore.dart';
import 'favorites.dart';
import 'settings.dart';
import 'package:admob_flutter/admob_flutter.dart';
// import 'package:admob_flutter_example/extensions.
class MainActivity extends StatefulWidget{
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MainActivity> {
  PageController _pageController;
  int _page = 0;

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
  void handleEvent( AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
      //showSnackBar('New Admob $adType Ad loaded!');
      print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
      //showSnackBar('Admob $adType Ad opened!');
      print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        //showSnackBar('Admob $adType Ad closed!');
        print('Admob $adType Ad closed!');
        _loadInterstitialAd();
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
        handleEvent(event, args, 'Interstitial');
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


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>exitDialog(context),
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Home(),
            Explore(),
            Favorites(),
            Profile(),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.grey[500],
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: SizedBox(),
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
              ),
              title: SizedBox(),
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              title: SizedBox(),
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              title: SizedBox(),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),

      ),
    );
  }

  exitDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                Constants.appName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              SizedBox(height: 25),

              Text(
                "Do you really want to quit?",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Container(
                    height: 40,
                    width: 130,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: ()=> exit(0),
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      borderSide: BorderSide(color: Theme.of(context).accentColor),
                      child: Text(
                        "No",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: ()=>Navigator.pop(context),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void navigationTapped(int page) {
    showInterstitialAd();
    if(page == 2.0){
      Provider.of<FavoritesProvider>(context, listen: false)
          .getFeed();
      _pageController.jumpToPage(page);

    }else{
    _pageController.jumpToPage(page);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
