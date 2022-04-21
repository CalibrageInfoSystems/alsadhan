import 'dart:convert';

import 'package:alsadhan/allcategories/allcategories_screen.dart';
import 'package:alsadhan/cart/PlaceOrdermodelLocalModel.dart';
import 'package:alsadhan/cart/cart_screen.dart';
import 'package:alsadhan/delivery/settings.dart';
import 'package:alsadhan/home/DealsScreen.dart';
import 'package:alsadhan/home/ProfileScreen.dart';

import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/login/login.dart';
import 'package:alsadhan/models/CartModel_data.dart';
import 'package:alsadhan/models/PostCartModel.dart';
import 'package:alsadhan/models/homecategoryitemsmodel.dart';
import 'package:alsadhan/services/api_service.dart';
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          length: 4,
          child: new Scaffold(
            appBar: AppBar(
              // leading: Image(
              //   height: 45,
              //   image: AssetImage("images/new/toggle-icon.png"),
              // ),
              iconTheme: new IconThemeData(color: Colors.blue[900],),
              backgroundColor: Colors.white,
              title: Image(
                height: 45,
                image: AssetImage("images/sadhan_land.png"),
              ),
              actions: <Widget>[
                isUserLogin == true
                    ? IconButton(
                        icon: Icon(
                          Icons.settings,
                          size: 25.0,
                          color: Colors.blue[800],
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen())),
                      )
                    : Text("")
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
                        margin: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey[400])),
                        height: 40,
                        child: new ListTile(
                          // leading: new Icon(Icons.search),
                          title: new TextField(
                            controller: controller,
                            decoration: new InputDecoration(                              
                                hintText: isArabic == true ? "عما تبحث؟" : 'What are you looking for?',
                                hintStyle: TextStyle(fontSize: 18),
                                border: InputBorder.none),
                            // onChanged: onSearchTextChanged,
                          ),
                          trailing: new 
                          IconButton(
                            padding: EdgeInsets.only(bottom: 10.0),
                            icon: new Icon(
                              Icons.search,
                              color: Colors.grey[500],
                            ),
                            onPressed: () {
                              // controller.clear();
                              // onSearchTextChanged('');
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => Example(
                                      from: 'SEARCH',
                                      catids: null,
                                      searchtext: controller.value.text,
                                      isFromHome: true)));
                            },
                          ),
                        )),
                    Column(
                      children: <Widget>[
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          margin: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              // side: new BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(18.0)),
                          elevation: 4,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryListScreen(focusposition: 0)));
                            },
                            child: Image(
                              height: 140,
                              width: 400,
                              fit: BoxFit.cover,
                              image: AssetImage(isArabic == true
                                  ? 'images/new/fresh-vegitables-ar.png'
                                  : "images/new/fresh-vegitables.jpg"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                     margin: EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                                              child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                new Card(
                                  // color: Colors.blueGrey[50,
                                  shape: RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: Colors.blueGrey[100]),
                                      borderRadius: BorderRadius.circular(15.0)),
                                  elevation: 2.0,
                                  // margin: new EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 40,
                                    width: 110,
                                    padding: new EdgeInsets.all(10.0),
                                    child: new GestureDetector(
                                      onTap: () {
                                      Navigator.of(context).push(
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoryListScreen(
                                                                  focusposition:
                                                                      0)));
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          new Column(
                                            children: <Widget>[
                                              Image(
                                          height: 20,
                                          width: 15,
                                          fit: BoxFit.cover,
                                          image: AssetImage(                                             
                                              'images/new/fresh-food.png'),
                                        ),
                                            ],
                                          ),
                                          new Column(
                                            children: <Widget>[
                                              new Text(isArabic == true? "طعام طازج":'Fresh Food',
                                    style: TextStyle(color: Colors.grey,fontSize: 12.0, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
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
                                  // color: Colors.blueGrey[50],
                                  shape: RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: Colors.blueGrey[100]),
                                      borderRadius: BorderRadius.circular(15.0)),
                                  elevation: 2.0,
                                  margin: new EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 40,
                                    width: 110,
                                    padding: new EdgeInsets.all(10.0),
                                    child: new GestureDetector(
                                      onTap: () {
                                     Navigator.of(context).push(
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                CategoryListScreen(
                                                                    focusposition:
                                                                        1)));
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          new Column(
                                            children: <Widget>[
                                              Image(
                                          height: 20,
                                          width: 15,
                                          fit: BoxFit.cover,
                                          image: AssetImage(                                             
                                              'images/new/beverages.png'),
                                        ),
                                            ],
                                          ),
                                          new Column(
                                            children: <Widget>[
                                              new Text(isArabic == true? "مشروبات":'Beverages',
                                              style: TextStyle(color: Colors.grey,fontSize: 12.0, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
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
                                  // color: Colors.blueGrey[50],
                                  shape: RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: Colors.blueGrey[100]),
                                      borderRadius: BorderRadius.circular(15.0)),
                                  elevation: 2.0,
                                  margin: new EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 40,
                                    width: 110,
                                    padding: new EdgeInsets.all(10.0),
                                    child: new GestureDetector(
                                      onTap: () {
                                      Navigator.of(context).push(
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoryListScreen(
                                                                  focusposition:
                                                                      3)));
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          new Column(
                                            children: <Widget>[
                                              Image(
                                          height: 20,
                                          width: 15,
                                          fit: BoxFit.cover,
                                          image: AssetImage(                                             
                                              'images/new/noon-food.png'),
                                        ),
                                            ],
                                          ),
                                          new Column(
                                            children: <Widget>[
                                              new Text(isArabic == true? "غير الغذائية":'Non Food',
                                               style: TextStyle(color: Colors.grey,fontSize: 12.0, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
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
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.only(left: 25.0),
                             child: Text(
                                isArabic == true
                                    ? "تسوق حسب الاقسام"
                                    : 'Shop by category',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                           ),
                          
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) =>
                              CategoryListScreen(focusposition: 0)));
                            },
                            child: Text(
                              isArabic == true
                                  ? "أكثر"
                                  : 'More',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: new EdgeInsets.only(
                        bottom: 5.0, left: 8.0, right: 8.0),
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
                                elevation: 3.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  height: 150,
                                  width: 160,
                                   padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (context) => Example(
                                                  from: null,
                                                  catids:
                                                      "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                                                  searchtext: null,
                                                  isFromHome: true)));
                                    },
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[                                        
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/new/fruits-vegs.png'
                                              : 'images/new/fruits-vegs.png'),
                                        ),
                                        // SizedBox(height: 10),                                        
                                       Text(isArabic == true
                                  ? "فواكه خضر"
                                  :'Fruit & \n Vegetables', 
                                       style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
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
                                  height: 150,
                                  width: 160,
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (context) => Example(
                                                  from: null,
                                                  catids:
                                                      "11,123,124,125,126,127,128,129",
                                                  searchtext: null,
                                                  isFromHome: true)));
                                    },
                                    child: new Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/new/bakery.png'
                                              : 'images/new/bakery.png'),
                                        ),
                                        SizedBox(height: 10),
                                         new Text(isArabic == true
                                                  ? "مخبز"
                                                  :'Bakery',
                                                    style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),),
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
                                  height: 150,
                                  width: 160,
                                  padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                     Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "318,328,329,330,331,332,333",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                             ? 'images/new/electronics.png'
                                             : 'images/new/electronics.png'),
                                        ),
                                        SizedBox(height: 10),
                                       new Text(isArabic == true
                                                  ? "إلكترونيات"
                                                  :'Electronics',
                                       style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
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
                                  height: 150,
                                  width: 160,
                                  padding: new EdgeInsets.all(5.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                    Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "318,328,329,330,331,332,333",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                               ? 'images/new/luggage.png'
                                               : 'images/new/luggage.png'),
                                        ),
                                        SizedBox(height: 10),
                                       new Text(isArabic == true
                                                  ? "أمتعة"
                                                  :'Luggage',
                                       style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
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
                        margin: new EdgeInsets.only(
                        bottom: 15.0, top: 8.0, left: 5.0, right: 8.0,),
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
                                elevation: 3.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  height: 150,
                                  width: 160,
                                 padding: new EdgeInsets.all(8.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                     Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "189,281,282,283,284,285,286,287,288",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));
                                    },
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                              ? 'images/new/snacks.png'
                                              : 'images/new/snacks.png'),
                                        ),
                                        SizedBox(height: 10),
                                         new Text(isArabic == true
                                                  ? "وجبات خفيفة"
                                                  :'Snacks',
                                         style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
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
                                  height: 150,
                                  width: 160,
                                  padding: new EdgeInsets.all(5.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                                            new MaterialPageRoute(
                                                                builder: (context) => Example(
                                                                    from: null,
                                                                    catids:
                                                                        "179,215,216,217,218,219,220",
                                                                    searchtext:
                                                                        null,
                                                                    isFromHome:
                                                                        true)));                                     
                                    },
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Image(
                                          // height: 140,
                                          // width: 130,
                                          fit: BoxFit.cover,
                                          image: AssetImage(isArabic == true
                                             ? 'images/new/breakfast.png'
                                             : 'images/new/breakfast.png'),
                                        ),
                                        SizedBox(height: 10),
                                         new Text(isArabic == true
                                                  ? "وجبة افطار"
                                                  :'Breakfast',
                                         style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
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
                                                         
                    // Container(
                    //   margin: new EdgeInsets.only(left: 5.0),
                    //   child: Row(
                    //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: <Widget>[
                    //       FlatButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           isArabic == true
                    //               ? "العناصر شاملة ضريبة القيمة المضافة"
                    //               : 'Fresh Deals',
                    //           style: TextStyle(
                    //               color: Colors.grey,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Container(
                    //   // margin: new EdgeInsets.only(5.0),
                    //   //padding: new EdgeInsets.only(left: 25, top: 50.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: <Widget>[
                    //       Column(
                    //         children: <Widget>[
                    //           new Card(
                    //             semanticContainer: true,
                    //             clipBehavior: Clip.antiAliasWithSaveLayer,
                    //             shape: RoundedRectangleBorder(
                    //                 side: new BorderSide(
                    //                     color: Colors.blueGrey[100]),
                    //                 borderRadius: BorderRadius.circular(15.0)),
                    //             elevation: 2.0,
                    //             // margin: new EdgeInsets.all(5.0),
                    //             child: Container(
                    //               height: 200,
                    //               width: 170,
                    //               padding: new EdgeInsets.all(8.0),
                    //               child: new GestureDetector(
                    //                 onTap: () {
                    //                    Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                 },
                    //                 child: new Column(
                    //                   children: <Widget>[
                    //                     // Padding(padding: EdgeInsets.only(right: 50.0)),
                    //                     Align(
                    //                       alignment: Alignment.topRight,
                    //                       child: Icon(Icons.favorite_border),
                    //                     ),
                    //                     Image(
                    //                       // height: 140,
                    //                       // width: 130,
                    //                       fit: BoxFit.cover,
                    //                       image: AssetImage(isArabic == true
                    //                           ? 'images/ar_fruits-vegetables_ar.jpg'
                    //                           : 'images/fruits_vegs.jpg'),
                    //                     ),
                    //                     SizedBox(height: 30),
                    //                     Text('Values'),
                    //                     SizedBox(height: 14),
                    //                     Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: <Widget>[
                    //                         RaisedButton(
                    //                           shape: new RoundedRectangleBorder(
                    //                               borderRadius:
                    //                                   new BorderRadius.circular(
                    //                                       18.0)),
                    //                           textColor: Colors.white,
                    //                           color: Colors.blue[800],
                    //                           child: Row(
                    //                             children: <Widget>[
                    //                               Text(isArabic == true
                    //                                   ? "أضف"
                    //                                   : 'Add to cart'),
                    //                               Padding(
                    //                                   padding: EdgeInsets.only(
                    //                                       right: 12.0)),
                    //                               Container(
                    //                                   color: Colors.indigo,
                    //                                   // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    //                                   child: Icon(Icons.add))
                    //                             ],
                    //                           ),
                    //                           onPressed: () {
                    //                              Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                           },
                    //                         ),
                    //                       ],
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //       Column(
                    //         children: <Widget>[
                    //           new Card(
                    //             semanticContainer: true,
                    //             clipBehavior: Clip.antiAliasWithSaveLayer,
                    //             shape: RoundedRectangleBorder(
                    //                 side: new BorderSide(
                    //                     color: Colors.blueGrey[100]),
                    //                 borderRadius: BorderRadius.circular(15.0)),
                    //             elevation: 2.0,
                    //             // margin: new EdgeInsets.all(5.0),
                    //             child: Container(
                    //               height: 200,
                    //               width: 170,
                    //               padding: new EdgeInsets.all(8.0),
                    //               child: new GestureDetector(
                    //                 onTap: () {
                    //                    Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                 },
                    //                 child: new Column(
                    //                   children: <Widget>[
                    //                     // Padding(padding: EdgeInsets.only(right: 50.0)),
                    //                     Align(
                    //                       alignment: Alignment.topRight,
                    //                       child: Icon(Icons.favorite_border),
                    //                     ),
                    //                     Image(
                    //                       // height: 140,
                    //                       // width: 130,
                    //                       fit: BoxFit.cover,
                    //                       image: AssetImage(isArabic == true
                    //                           ? 'images/ar_fruits-vegetables_ar.jpg'
                    //                           : 'images/fruits_vegs.jpg'),
                    //                     ),
                    //                     SizedBox(height: 30),
                    //                     Text('Values'),
                    //                     SizedBox(height: 14),
                    //                     Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: <Widget>[
                    //                         RaisedButton(
                    //                           shape: new RoundedRectangleBorder(
                    //                               borderRadius:
                    //                                   new BorderRadius.circular(
                    //                                       18.0)),
                    //                           textColor: Colors.white,
                    //                           color: Colors.blue[800],
                    //                           child: Row(
                    //                             children: <Widget>[
                    //                               Text(isArabic == true
                    //                                   ? "أضف"
                    //                                   : 'Add to cart'),
                    //                               Padding(
                    //                                   padding: EdgeInsets.only(
                    //                                       right: 12.0)),
                    //                               Container(
                    //                                   color: Colors.indigo,
                    //                                   // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    //                                   child: Icon(Icons.add))
                    //                             ],
                    //                           ),
                    //                           onPressed: () {
                    //                              Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));                                              },
                    //                         ),
                    //                       ],
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Container(
                    //   width: 380,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue[900],
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(5.0),
                    //     child: Center(
                    //       child: Text(
                    //         isArabic == true
                    //             ? "العناصر شاملة ضريبة القيمة المضافة"
                    //             : 'Items are Inclusive VAT',
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(height: 120, child: listBanners(bannerslist)),
                    // Container(
                    //   height: 260,
                    //   child: DefaultTabController(
                    //     length: 3,
                    //     child: Column(
                    //       children: <Widget>[
                    //         Container(
                    //           constraints: BoxConstraints.expand(height: 50),
                    //           child: TabBar(
                    //               unselectedLabelColor: Colors.grey,
                    //               indicatorColor: Colors.blue[900],
                    //               labelColor: Colors.blue[900],
                    //               isScrollable: true,
                    //               tabs: [
                    //                 Tab(
                    //                     text: isArabic == true
                    //                         ? "     طازج     "
                    //                         : "       FRESH     "),
                    //                 Tab(
                    //                     text: isArabic == true
                    //                         ? "     FMCG     "
                    //                         : "     FMCG     "),
                    //                 Tab(
                    //                     text: isArabic == true
                    //                         ? "    غير الغذائية   "
                    //                         : "    NON Food   "),
                    //                 // Tab(text: "    OTHERS    "),
                    //               ]),
                    //         ),
                    //         Expanded(
                    //           child: Container(
                    //             child: TabBarView(children: [
                    //               Container(
                    //                   padding: EdgeInsets.all(4),
                    //                   child: Material(
                    //                       elevation: 3,
                    //                       child: Column(
                    //                         children: <Widget>[
                    //                           GestureDetector(
                    //                             onTap: () {
                    //                               Navigator.of(context).push(
                    //                                   new MaterialPageRoute(
                    //                                       builder: (context) =>
                    //                                           CategoryListScreen(
                    //                                               focusposition:
                    //                                                   0)));
                    //                             },
                    //                             child: Image(
                    //                               height: 120,
                    //                               image: AssetImage(isArabic ==
                    //                                       true
                    //                                   ? 'images/ar_fresh_food.jpg'
                    //                                   : 'images/fresh_food.jpg'),
                    //                             ),
                    //                           ),
                    //                           SingleChildScrollView(
                    //                             scrollDirection:
                    //                                 Axis.horizontal,
                    //                             child: Row(
                    //                               children: <Widget>[
                    //                                 GestureDetector(
                    //                                   child: Image(
                    //                                     height: 80,
                    //                                     image: AssetImage(isArabic ==
                    //                                             true
                    //                                         ? 'images/ar_fruits-vegetables_ar.jpg'
                    //                                         : 'images/fruits_vegs.jpg'),
                    //                                   ),
                    //                                   onTap: () {
                    //                                     Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "2,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43, 3,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                                   },
                    //                                 ),
                    //                                 Container(
                    //                                     height: 80,
                    //                                     child: VerticalDivider(
                    //                                         color: Colors
                    //                                             .blue[900])),
                    //                                 GestureDetector(
                    //                                   child: Image(
                    //                                     height: 80,
                    //                                     image: AssetImage(isArabic ==
                    //                                             true
                    //                                         ? 'images/ar_bakery.jpg'
                    //                                         : 'images/bakery.jpg'),
                    //                                   ),
                    //                                   onTap: () {
                    //                                     Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "11,123,124,125,126,127,128,129",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                                   },
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           )
                    //                         ],
                    //                       ))),
                    //               Container(
                    //                   padding: EdgeInsets.all(4),
                    //                   child: Material(
                    //                       elevation: 4,
                    //                       child: Column(
                    //                         children: <Widget>[
                    //                           GestureDetector(
                    //                               child: Image(
                    //                                 height: 120,
                    //                                 image: AssetImage(isArabic ==
                    //                                         true
                    //                                     ? 'images/ar_food_Beverages_ar.jpg'
                    //                                     : 'images/food-beverages.jpg'),
                    //                               ),
                    //                               onTap: () {
                    //                                 Navigator.of(context).push(
                    //                                     new MaterialPageRoute(
                    //                                         builder: (context) =>
                    //                                             CategoryListScreen(
                    //                                                 focusposition:
                    //                                                     1)));
                    //                               }),
                    //                           SingleChildScrollView(
                    //                             scrollDirection:
                    //                                 Axis.horizontal,
                    //                             child: Row(
                    //                               children: <Widget>[
                    //                                 GestureDetector(
                    //                                   child: Image(
                    //                                     height: 80,
                    //                                     image: AssetImage(isArabic ==
                    //                                             true
                    //                                         ? 'images/ar_breakfast_ar.jpg'
                    //                                         : 'images/breakfast.jpg'),
                    //                                   ),
                    //                                   onTap: () {
                    //                                     Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "179,215,216,217,218,219,220",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                                   },
                    //                                 ),
                    //                                 Container(
                    //                                     height: 80,
                    //                                     child: VerticalDivider(
                    //                                         color: Colors
                    //                                             .blue[900])),
                    //                                 GestureDetector(
                    //                                   child: Image(
                    //                                     height: 80,
                    //                                     image: AssetImage(isArabic ==
                    //                                             true
                    //                                         ? 'images/ar_snacks_ar.jpg'
                    //                                         : 'images/snacks.jpg'),
                    //                                   ),
                    //                                   onTap: () {
                    //                                     Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "189,281,282,283,284,285,286,287,288",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                                   },
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           )
                    //                         ],
                    //                       ))),
                    //               Container(
                    //                   padding: EdgeInsets.all(4),
                    //                   child: Material(
                    //                       elevation: 4,
                    //                       child: Column(
                    //                         children: <Widget>[
                    //                           GestureDetector(
                    //                             onTap: () {
                    //                               Navigator.of(context).push(
                    //                                   new MaterialPageRoute(
                    //                                       builder: (context) =>
                    //                                           CategoryListScreen(
                    //                                               focusposition:
                    //                                                   2)));
                    //                             },
                    //                             child: Image(
                    //                               height: 120,
                    //                               image: AssetImage(isArabic ==
                    //                                       true
                    //                                   ? 'images/ar_non_food_ar.jpg'
                    //                                   : 'images/non_food.jpg'),
                    //                             ),
                    //                           ),
                    //                           SingleChildScrollView(
                    //                             scrollDirection:
                    //                                 Axis.horizontal,
                    //                             child: Row(
                    //                               children: <Widget>[
                    //                                 GestureDetector(
                    //                                   child: Image(
                    //                                     height: 80,
                    //                                     image: AssetImage(isArabic ==
                    //                                             true
                    //                                         ? 'images/ar_electronics_ar.jpg'
                    //                                         : 'images/electronics.jpg'),
                    //                                   ),
                    //                                   onTap: () {
                    //                                     Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "318,328,329,330,331,332,333",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                                   },
                    //                                 ),
                    //                                 Container(
                    //                                     height: 80,
                    //                                     child: VerticalDivider(
                    //                                         color: Colors
                    //                                             .blue[900])),
                    //                                 GestureDetector(
                    //                                   child: Image(
                    //                                     height: 80,
                    //                                     image: AssetImage(isArabic ==
                    //                                             true
                    //                                         ? 'images/ar_luggage_ar.jpg'
                    //                                         : 'images/luggage.jpg'),
                    //                                   ),
                    //                                   onTap: () {
                    //                                     Navigator.of(context).push(
                    //                                         new MaterialPageRoute(
                    //                                             builder: (context) => Example(
                    //                                                 from: null,
                    //                                                 catids:
                    //                                                     "325,367",
                    //                                                 searchtext:
                    //                                                     null,
                    //                                                 isFromHome:
                    //                                                     true)));
                    //                                   },
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           )
                    //                         ],
                    //                       ))),
                    //             ]),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                   
                    // Container(
                    //     padding: EdgeInsets.all(5),
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         Navigator.of(context).push(new MaterialPageRoute(
                    //             builder: (context) =>
                    //                 AllCategoriesScreennew()));
                    //       },
                    //       child: Image(
                    //         image: AssetImage(isArabic == true
                    //             ? 'images/ar_all_categories.jpg'
                    //             : "images/all_categories.jpg"),
                    //       ),
                    //     )),
                  
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
                        Icon(Icons.home, size: 20),
                        Text(isArabic == true?"الصفحة الرئيسية":"Home",
                         style: TextStyle(fontSize: 10))
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
                  // Tab(
                  //   icon: Column(
                  //     children: <Widget>[
                  //       Padding(padding: EdgeInsets.all(1.0)),
                  //       Icon(Icons.shopping_basket,
                  //           color: Colors.grey[700], size: 20),
                  //       Text(isArabic == true?"صفقات":"Deals", 
                  //       style: TextStyle(fontSize: 10))
                  //     ],
                  //   ),
                  // ),
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
                      isUserLogin == true?
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen()),
                                  ):
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );                    
                  } else if (tabIndex == 3) {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => CartItemsScreen()));
                  } 
                  // else if (tabIndex == 4) {
                  //   Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  //       builder: (context) => DealScreen()));
                  // }

                  print("---tabIndex ----- " + tabIndex.toString());
                },
              ),
            ),
            // backgroundColor: Colors.white,
          ),
        ));
    // body: Container(
    // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),

    // child: buildListViewHoriental(items),));
  }

  // ListView listBanners(List<String> banners) {
  //   return ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: banners.length,
  //       itemBuilder: (context, index) {
  //         return Center(
  //             child: Padding(
  //                 padding: EdgeInsets.all(5.0),
  //                 child: GestureDetector(
  //                   child: Container(

  //                       child: Material(
  //                           elevation: 4,
  //                           child: Image(
  //                             image: AssetImage(banners[index]),
  //                           ))),
  //                   onTap: () {
  //                     Navigator.of(context).push(new MaterialPageRoute(
  //                         builder: (context) =>
  //                             CategoryListScreen(focusposition: index)));
  //                   },
  //                 )));
  //       });
  // }

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

  // Future<PostCartModel> getSavedInfo() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   Map userMap = jsonDecode(preferences.getString(LocalData.CART_MODEL));
  //   PostCartModel user = PostCartModel.fromJson(userMap);
  //   print(" ---- >>> Cart Details " + user.toString());
  //   return user;
  // }

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
