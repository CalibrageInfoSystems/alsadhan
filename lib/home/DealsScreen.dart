import 'dart:convert';

import 'package:alsadhan/allcategories/allcategories_screen.dart';
import 'package:alsadhan/cart/PlaceOrdermodelLocalModel.dart';
import 'package:alsadhan/cart/cart_screen.dart';
import 'package:alsadhan/delivery/settings.dart';
import 'package:alsadhan/home/DealsScreen.dart';
import 'package:alsadhan/home/ProfileScreen.dart';
import 'package:alsadhan/home/home_screen.dart';

import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/login/login.dart';
import 'package:alsadhan/models/CartModel_data.dart';
import 'package:alsadhan/models/PostCartModel.dart';
import 'package:alsadhan/models/homecategoryitemsmodel.dart';
import 'package:alsadhan/services/api_service.dart';
import 'package:alsadhan/store/stores_screen.dart';
import 'package:alsadhan/widgets/appDrawer.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'FlutterExample.dart';
import 'catogory_list_screen.dart';

bool isUserLogin = false;
bool isArabic = false;
int offlineProducts = 0;

PostCartModel cartModel = new PostCartModel();

class DealScreen extends StatefulWidget {
  @override
  _DealScreenState createState() => _DealScreenState();
}

class _DealScreenState extends State<DealScreen> {
  List<ItemModel> items = new List<ItemModel>();
  List<String> bannerslist = new List<String>();
  TextEditingController controller = new TextEditingController();
  LocalData localData = new LocalData();
  ApiConnector api;
  int productsCount = 0;

  @override
  void initState() {
    super.initState();

    localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });
    api = new ApiConnector();
    items.add(new ItemModel(id: 0, name: 'Hot Deals', bannerurl: 'url'));
    items.add(new ItemModel(id: 1, name: 'FRESH', bannerurl: 'url'));
    items
        .add(new ItemModel(id: 38, name: 'Food & Beverages', bannerurl: 'url'));
    items.add(new ItemModel(id: 97, name: 'Healthy Living', bannerurl: 'url'));
    items
        .add(new ItemModel(id: 115, name: 'Health & Beauty', bannerurl: 'url'));
    items.add(new ItemModel(id: 164, name: 'HouseHold', bannerurl: 'url'));
    items.add(new ItemModel(id: 217, name: 'Baby', bannerurl: 'url'));
    items.add(new ItemModel(id: 228, name: 'Pets', bannerurl: 'url'));

    // bannersInit(); //others
    //  bannerslist.add('images/others.jpg');  //others

    List<PlaceOrdermodelLocalModel> placeorderlist =
        new List<PlaceOrdermodelLocalModel>();
    placeorderlist.add(new PlaceOrdermodelLocalModel(
        productId: 123, price: 25.5, quantity: 10));
    placeorderlist.add(new PlaceOrdermodelLocalModel(
        productId: 124, price: 20.5, quantity: 12));
    placeorderlist.add(new PlaceOrdermodelLocalModel(
        productId: 125, price: 29.5, quantity: 7));

    localData.getBoolValuesSF(LocalData.ISLOGIN).then((islogindata) {
      isUserLogin = islogindata;
      localData.getIntToSF(LocalData.USERID).then((userid) {
        api.getCartInfo(userid).then((cartinfo) {
          if (cartinfo.result != null) {
            setState(() {
              productsCount = cartinfo.result.productsList.length;
            });

            //  getOfflineCart(userid, cartinfo.result.cart.id,
            //   cartinfo.result.cart.name, cartinfo);
          } else {
            print('************ LocalData.USERID : ' + userid.toString());

            // getOfflineCart(userid, null, "cart", null);
          }
        });
      });
    });

    localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });

    // List<PostCartModel> placeOrdermodelFromJson(String str) =>
    // List<PostCartModel>.from(
    //     json.decode(str).map((x) => PostCartModel.fromJson(x)));
  }

  void bannersInit() {
    setState(() {
      bannerslist = [];
      //bannerslist.add(isArabic == true ? 'images/ar_fresh_food.jpg': 'images/fresh_food.jpg');
      bannerslist.add(isArabic == true
          ? 'images/ar_food_Beverages_ar.jpg'
          : 'images/frozen_food.jpg');
      bannerslist.add(isArabic == true
          ? 'images/ar_non_food_ar.jpg'
          : 'images/non_food.jpg');
    });
  }

  @override
  Widget build(BuildContext context) {
    bannersInit();
    
    return new MaterialApp(
        theme: ThemeData(
            primaryIconTheme: IconThemeData(color: Colors.indigo[900])),
        color: Colors.yellow,
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 5,
          child: new Scaffold(
            appBar: AppBar(
              // leading: Text("data", style: TextStyle(color: Colors.white)),              
              iconTheme: new IconThemeData(color: Colors.white),
              backgroundColor: Colors.indigo[900],
              title: Text("Deals", style: TextStyle(color: Colors.white),),
              actions: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(11.0),
                   child: Text(
                          "Items ($productsCount)",
                           style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                 )
                    
              ],
            ),
            drawer: AppDrawer(),
            floatingActionButton: isUserLogin == true
                ? Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20),
                    child: FloatingActionButton(
                        elevation: 8,
                        backgroundColor: Colors.blue[800],
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => CartItemsScreen()));
                        },
                        child: Badge(
                          badgeColor: Colors.red,
                          badgeContent: Text(
                            productsCount.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                          child: Icon(
                            Icons.add_shopping_cart,
                            size: 30,
                          ),
                        )),
                  )
                : Text(""),
            body: Directionality(
              textDirection:
                  isArabic == true ? TextDirection.rtl : TextDirection.ltr,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[                   
                    Container(
                      margin: new EdgeInsets.all(5.0),
                      //padding: new EdgeInsets.only(left: 25, top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              new Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blueGrey[100]),
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  height: 200,
                                  width: 170,
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                       Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      children: <Widget>[
                                        // Padding(padding: EdgeInsets.only(right: 50.0)),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.favorite_border),
                                        ),
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/ar_fruits-vegetables_ar.jpg'
                                              : 'images/fruits_vegs.jpg'),
                                        ),
                                        SizedBox(height: 30),
                                        Text('Values'),
                                        SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          18.0)),
                                              textColor: Colors.white,
                                              color: Colors.blue[800],
                                              child: Row(
                                                children: <Widget>[
                                                  Text(isArabic == true
                                                      ? "أضف"
                                                      : 'Add to cart'),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 12.0)),
                                                  Container(
                                                      color: Colors.indigo,
                                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                                      child: Icon(Icons.add))
                                                ],
                                              ),
                                              onPressed: () {
                                                 Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              new Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blueGrey[100]),
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  height: 200,
                                  width: 170,
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                       Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      children: <Widget>[
                                        // Padding(padding: EdgeInsets.only(right: 50.0)),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.favorite_border),
                                        ),
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/ar_fruits-vegetables_ar.jpg'
                                              : 'images/fruits_vegs.jpg'),
                                        ),
                                        SizedBox(height: 30),
                                        Text('Values'),
                                        SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          18.0)),
                                              textColor: Colors.white,
                                              color: Colors.blue[800],
                                              child: Row(
                                                children: <Widget>[
                                                  Text(isArabic == true
                                                      ? "أضف"
                                                      : 'Add to cart'),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 12.0)),
                                                  Container(
                                                      color: Colors.indigo,
                                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                                      child: Icon(Icons.add))
                                                ],
                                              ),
                                              onPressed: () {
                                                 Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.all(5.0),
                      //padding: new EdgeInsets.only(left: 25, top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              new Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blueGrey[100]),
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  height: 200,
                                  width: 170,
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                       Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      children: <Widget>[
                                        // Padding(padding: EdgeInsets.only(right: 50.0)),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.favorite_border),
                                        ),
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/ar_fruits-vegetables_ar.jpg'
                                              : 'images/fruits_vegs.jpg'),
                                        ),
                                        SizedBox(height: 30),
                                        Text('Values'),
                                        SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          18.0)),
                                              textColor: Colors.white,
                                              color: Colors.blue[800],
                                              child: Row(
                                                children: <Widget>[
                                                  Text(isArabic == true
                                                      ? "أضف"
                                                      : 'Add to cart'),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 12.0)),
                                                  Container(
                                                      color: Colors.indigo,
                                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                                      child: Icon(Icons.add))
                                                ],
                                              ),
                                              onPressed: () {
                                                 Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              new Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blueGrey[100]),
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  height: 200,
                                  width: 170,
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                       Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      children: <Widget>[
                                        // Padding(padding: EdgeInsets.only(right: 50.0)),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.favorite_border),
                                        ),
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/ar_fruits-vegetables_ar.jpg'
                                              : 'images/fruits_vegs.jpg'),
                                        ),
                                        SizedBox(height: 30),
                                        Text('Values'),
                                        SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          18.0)),
                                              textColor: Colors.white,
                                              color: Colors.blue[800],
                                              child: Row(
                                                children: <Widget>[
                                                  Text(isArabic == true
                                                      ? "أضف"
                                                      : 'Add to cart'),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 12.0)),
                                                  Container(
                                                      color: Colors.indigo,
                                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                                      child: Icon(Icons.add))
                                                ],
                                              ),
                                              onPressed: () {
                                                 Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.all(5.0),
                      //padding: new EdgeInsets.only(left: 25, top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              new Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blueGrey[100]),
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  height: 200,
                                  width: 170,
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                       Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      children: <Widget>[
                                        // Padding(padding: EdgeInsets.only(right: 50.0)),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.favorite_border),
                                        ),
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/ar_fruits-vegetables_ar.jpg'
                                              : 'images/fruits_vegs.jpg'),
                                        ),
                                        SizedBox(height: 30),
                                        Text('Values'),
                                        SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          18.0)),
                                              textColor: Colors.white,
                                              color: Colors.blue[800],
                                              child: Row(
                                                children: <Widget>[
                                                  Text(isArabic == true
                                                      ? "أضف"
                                                      : 'Add to cart'),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 12.0)),
                                                  Container(
                                                      color: Colors.indigo,
                                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                                      child: Icon(Icons.add))
                                                ],
                                              ),
                                              onPressed: () {
                                                 Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              new Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blueGrey[100]),
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  height: 200,
                                  width: 170,
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                       Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      children: <Widget>[
                                        // Padding(padding: EdgeInsets.only(right: 50.0)),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.favorite_border),
                                        ),
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/ar_fruits-vegetables_ar.jpg'
                                              : 'images/fruits_vegs.jpg'),
                                        ),
                                        SizedBox(height: 30),
                                        Text('Values'),
                                        SizedBox(height: 14),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          18.0)),
                                              textColor: Colors.white,
                                              color: Colors.blue[800],
                                              child: Row(
                                                children: <Widget>[
                                                  Text(isArabic == true
                                                      ? "أضف"
                                                      : 'Add to cart'),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 12.0)),
                                                  Container(
                                                      color: Colors.indigo,
                                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                                      child: Icon(Icons.add))
                                                ],
                                              ),
                                              onPressed: () {
                                                 Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                          margin: EdgeInsets.all(5),
                          child: RaisedButton( 
                            color: Colors.indigo[900],                            
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[                         
                                     Padding(
                                        padding: const EdgeInsets.all(8.0),                                                                             
                                           child: Text(
                                              isArabic == true
                                                  ? "إرسال"
                                                  : 'Proceed',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0),
                                            ), 
                                      ),
                                     Padding(
                                        padding: const EdgeInsets.all(8.0),                                                                             
                                        child: Icon(Icons.arrow_forward, color: Colors.white) 
                                      ),
                                    ],
                                  ),
                                  onPressed: (){},
                            // onPressed: () {
                            //   if (totalcost == 0) {
                            //     Toast.show(
                            //         isArabic == true
                            //             ? "الرجاء تحديد منتج واحد على الأقل"
                            //             : 'Please Select Atleast One Product',
                            //         context,
                            //         duration: Toast.LENGTH_LONG,
                            //         gravity: Toast.CENTER);
                            //     localData.addStringToSF(
                            //         LocalData.CARTINFO, null);

                            //     Navigator.of(context).pushReplacement(
                            //         new MaterialPageRoute(
                            //             builder: (context) => HomeScreen()));
                            //   } else {
                            //     PostCartModel cartModel = new PostCartModel();

                            //     if (cart.result != null) {
                            //       cartModel.cart = new CartPostInfo(
                            //           id: cart.result.cart.id,
                            //           userId: cart.result.cart.userId,
                            //           name: cart.result.cart.name);
                            //     }
                            //     List<ProductsListModelCart> productsforpost =
                            //         [];

                            //     for (int i = 0;
                            //         i < cart.result.productsList.length;
                            //         i++) {
                            //       productsforpost.add(new ProductsListModelCart(
                            //           productId:
                            //               cart.result.productsList[i].productId,
                            //           quantity: cart
                            //               .result.productsList[i].quantity));
                            //     }
                            //     cartModel.productsList = productsforpost;
                            //     api
                            //         .postCartUpdate(cartModel)
                            //         .then((cartResponce) {
                            //       if (cartResponce == 200) {
                            //         Navigator.of(context)
                            //             .push(new MaterialPageRoute(
                            //                 builder: (context) => StoreScreen(
                            //                       items: null,
                            //                       totalprice: totalcost,
                            //                     )));
                            //       } else {
                            //         Toast.show(
                            //             isArabic == true
                            //                 ? "غير قادر على المضي قدما"
                            //                 : 'Unable to Proceed',
                            //             context,
                            //             duration: Toast.LENGTH_LONG,
                            //             gravity: Toast.BOTTOM);
                            //       }
                            //     });
                            //   }
                            // },
                         
                          )
                          ),
                    )
                    
                  
                  ],
                ),
              ),
            ),

            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1.0)),
              ),
              child: TabBar(
                labelPadding: EdgeInsets.all(2.0),
                tabs: [
                  Tab(
                    icon: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(1.0)),
                        Icon(Icons.home, size: 20,color: Colors.grey[700]),
                        Text(isArabic == true?"الصفحة الرئيسية":"Home",
                         style: TextStyle(fontSize: 10,color: Colors.grey[700]))
                      ],
                    ),                    
                  ),
                  Tab(
                    icon: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(1.0)),
                        Icon(
                          Icons.table_chart,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        Text(isArabic == true?"التصنيفات":"Categories",
                         style: TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                  Tab(
                    icon: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(1.0)),
                        Icon(Icons.shopping_basket,
                            color: Colors.blue, size: 20),
                        Text(isArabic == true?"صفقات":"Deals", 
                        style: TextStyle(fontSize: 10,color: Colors.blue))
                      ],
                    ),
                  ),
                  Tab(
                    icon: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(1.0)),
                        Icon(Icons.person_outline,
                            color: Colors.grey[700], size: 20),
                        Text(isArabic == true?"حسابي":"My account",
                         style: TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                  Tab(
                    icon: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(1.0)),
                        Icon(Icons.shopping_cart,
                            color: Colors.grey[700], size: 20),
                        Text(isArabic == true?"عربة التسوق":"Cart", 
                        style: TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                ],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                // indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.white,
                onTap: (tabIndex) {
                  if (tabIndex == 0) {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => HomeScreen()));
                  } else if (tabIndex == 1) {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => AllCategoriesScreennew()));
                  } else if (tabIndex == 2) {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => DealScreen()));
                  } else if (tabIndex == 3) {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => ProfileScreen()));
                  } else if (tabIndex == 4) {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => CartItemsScreen()));
                  }

                  print("---tabIndex ----- " + tabIndex.toString());
                },
              ),
            ),
           
            // backgroundColor: Colors.white,
          ),
        )
        );
    // body: Container(
    // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),

    // child: buildListViewHoriental(items),));
  }
  

  ListView listBanners(List<String> banners) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Center(
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: GestureDetector(
                    child: Container(
                        child: Material(
                            elevation: 4,
                            child: Image(
                              image: AssetImage(banners[index]),
                            ))),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) =>
                              CategoryListScreen(focusposition: index)));
                    },
                  )));
        });
  }

  ListView buildListViewHoriental(List<ItemModel> numbers) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          return Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.grey[200], width: 2.0)),
                child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      numbers[index].name,
                    ))),
          ));
        });
  }



  getOfflineCart(int userid, int id, String cartName, CartModel cartinfo) {
    localData.getStringValueSF(LocalData.CART_MODEL).then((offlineCart) {
      //CartModel cartinfo;
      if (offlineCart != "") {
        print("--- >> CART_MODEL >> " + offlineCart.toString());
        Map userMap = jsonDecode(offlineCart);
        cartModel = PostCartModel.fromJson(userMap);

        print("--- >> CART_MODEL >> " +
            cartModel.productsList[0].productId.toString());

        cartModel.cart.userId = userid;
        cartModel.cart.id = id;
        cartModel.cart.name = cartName;

        if (cartinfo != null) {
          for (int i = 0; i < cartinfo.result.productsList.length; i++) {
            cartModel.productsList.add(new ProductsListModelCart(
                productId: cartinfo.result.productsList[i].productId,
                quantity: cartinfo.result.productsList[i].quantity));
          }
        }

        if (userid == 0) {
          setState(() {
            productsCount = cartModel.productsList.length;
            print("--- >> offline CART_MODEL >> " + productsCount.toString());
          });
        } else {
          api.postCartUpdate(cartModel).then((cartResponce) {
            if (cartResponce == 200) {
              setState(() {
                productsCount = cartModel.productsList.length;

                localData.removeStringToSF(LocalData.CART_MODEL);
              });
            } else {
              setState(() {
                productsCount = cartModel.productsList.length;

                localData.removeStringToSF(LocalData.CART_MODEL);
              });
            }
          });
        }
        //offlineProducts = cartModel.productsList.length;

        // {Id: 1102, UserId: 25, Name: cart}
      }
    });
  }
}
