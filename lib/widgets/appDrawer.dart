import 'package:alsadhan/allcategories/allcategories_screen.dart';
import 'package:alsadhan/cart/cart_screen.dart';
import 'package:alsadhan/home/home_screen.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/login/login.dart';
import 'package:alsadhan/myorders/myorder_screen.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog progressDialog;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  LocalData localData = new LocalData();

  bool islogin = false;
  String username = '';
  String mobilenumber = '';
  bool isArabic = false;
  @override
  void initState() {
    super.initState();
    localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });
    localData.getBoolValuesSF(LocalData.ISLOGIN).then((islogindata) {
      setState(() {
        if (islogindata != null) {
          islogin = islogindata;
          if (islogin) {
            localData.getStringValueSF(LocalData.USER_NAME).then((name) {
              setState(() {
                username = name;
              });
            });
            localData
                .getStringValueSF(LocalData.USER_MOBILENUMBER)
                .then((mobile) {
              setState(() {
                mobilenumber = mobile;
              });
            });
          }
        } else {
          islogindata = false;
        }
      });
    });

    progressDialog =
        new ProgressDialog(context, type: ProgressDialogType.Normal);

    progressDialog.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.black54,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInCubic,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.indigo[900]),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 25.0,
                ),
                Container(
                   margin:EdgeInsets.only(left: 15.0, top: 15.0),
                  height: 70.0,
                  width: 70.0,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    image: new DecorationImage(
                      image: AssetImage('images/alsadanlogo.png'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),                
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => AllCategoriesScreennew()));
                  },
                  child: Container(
                      // margin: EdgeInsets.all(10),
                      // decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(8),
                      // border: Border.all(width: 2, color: Colors.white)),
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              isArabic == true
                                  ? 'جميع الفئات'
                                  : 'All Categories',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Image(
                            height: 15,
                            color: Colors.white,
                            image: AssetImage('images/right.png'),
                          )
                        ],
                      )),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    isArabic == true ? 'الرئيسية' : 'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => HomeScreen()));
                  },
                  // onTap: () {
                  //   Navigator.of(context)
                  //       .pushReplacementNamed(Constants.HOME_SCREEN);
                  // },
                ),
                islogin == true
                    ? Column(
                        children: <Widget>[
                          // Divider(),
                          ListTile(
                            leading: Icon(Icons.add_shopping_cart,
                                color: Colors.white),
                            title: Text(
                              isArabic == true ? 'عربة التسوق' : 'Cart',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(new MaterialPageRoute(
                                      builder: (context) => CartItemsScreen(
                                            fromproducts: false,
                                          )));
                            }, // onTap: () {
                            //   Navigator.of(context)
                            //       .pushReplacementNamed(Constants.HOME_SCREEN);
                            // },
                          ),
                          // Divider(),
                        ],
                      )
                    : Text(''),
                Container(
                    child: islogin == true
                        ? ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(
                                      builder: (context) => MyOrders()));
                            },
                            title: Text(
                                isArabic == true ? 'طلباتي' : 'My Orders',
                                style: TextStyle(color: Colors.white)),
                            leading: Icon(Icons.assignment_turned_in,
                                color: Colors.white),
                          )
                        : Text('')),
                Container(
                  child: islogin == true ? Divider() : Text(''),
                ),
                Container(
                    child: islogin == true
                        ? ListTile(
                            onTap: () {
                              // Navigator.of(context).pushReplacement(
                              //     new MaterialPageRoute(
                              //         builder: (context) => ProfileScreen()));
                            },
                            title: Text(username,
                                style: TextStyle(color: Colors.white)),
                            leading: Icon(Icons.person, color: Colors.white),
                          )
                        : Text('')),
                Container(
                    child: islogin == true
                        ? ListTile(
                            title: Text(mobilenumber,
                                style: TextStyle(color: Colors.white)),
                            leading:
                                Icon(Icons.phone_android, color: Colors.white),
                          )
                        : Text('')),
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    title: Text(
                      isArabic != true ? "Language (لغة)" : 'لغة (Language)',
                      style: TextStyle(color: Colors.white),
                      //AppTranslations.of(context).text("key_Language"),
                    ),
                    onTap: () {
                      // Navigator.pop(context);
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
                              child: new Wrap(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            localData.addBoolToSF(
                                                LocalData.IS_ARABIC, false);
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()));
                                          });
                                        },
                                        child: Container(
                                          width: 300,
                                          child: Card(
                                              elevation: 5,
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  'English',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ))),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            localData.addBoolToSF(
                                                LocalData.IS_ARABIC, true);

                                            Navigator.of(context)
                                                .pushReplacement(
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()));
                                          });
                                        },
                                        child: Container(
                                          width: 300,
                                          child: Card(
                                              elevation: 5,
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text(
                                                  'Arabic(عربى)',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ))),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 300,
                                          child: Card(
                                              elevation: 5,
                                              child: Center(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                // isArabic == true ? 'Cancel': 'إلغاء'
                                                child: Text(
                                                  isArabic == true
                                                      ? 'إلغاء'
                                                      : 'Cancel',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.red),
                                                ),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   begin: Alignment.topRight,
                      //   end: Alignment.bottomLeft,
                      //   stops: [0.1, 0.5, 0.7, 0.9],
                      //   colors: [
                      //     Colors.blue,
                      //     Colors.blue[500],
                      //     Colors.blue[700],
                      //     Colors.blue[900],
                      //   ],
                      // ),
                      ),
                  child: ListTile(
                    leading: Icon(Icons.input, color: Colors.white),
                    title: Text(
                      islogin == false
                          ? (isArabic == true ? 'تسجيل الدخول' : 'Login')
                          : (isArabic == true ? 'تسجيل خروج' : 'LogOut'),
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      if (islogin) {
                        localData.addIntToSF(LocalData.USERID, 0);
                        localData.removeStringToSF(LocalData.CART_MODEL);
                        localData.addBoolToSF(LocalData.ISLOGIN, false);
                        // localData.clearLocalDta();
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      } else {
                        localData.addBoolToSF(LocalData.ISLOGIN, false);
                        // localData.clearLocalDta();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      }
                    },
                    // onTap: () {
                    //   Navigator.of(context)
                    //       .pushReplacementNamed(Constants.HOME_SCREEN);
                    // },
                  ),
                ),
                // Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
