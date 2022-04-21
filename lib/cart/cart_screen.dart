import 'dart:convert';

import 'package:alsadhan/allcategories/allcategories_screen.dart';
import 'package:alsadhan/home/FlutterExample.dart';
import 'package:alsadhan/home/ProfileScreen.dart';
import 'package:alsadhan/home/home_screen.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/models/CartModel_data.dart';
import 'package:alsadhan/models/PostCartModel.dart';
import 'package:alsadhan/models/ProductsModel.dart';
import 'package:alsadhan/services/api_service.dart';
import 'package:alsadhan/store/stores_screen.dart';
import 'package:alsadhan/widgets/RaisedGradientButton.dart';
import 'package:alsadhan/widgets/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:toast/toast.dart';

bool isArabic = false;
class CartItemsScreen extends StatefulWidget {
  String catid;
  String searachstring;
  bool fromproducts;

  CartItemsScreen({Key key, this.catid, this.searachstring, this.fromproducts})
      : super(key: key);
  @override
  _CartItemsScreenState createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  BuildContext ctx;
  String strcartInfo = isArabic == true ? "جلب البيانات" : 'Fetching Data';
  double totalcost = 0.0;
  LocalData localData = new LocalData();
  ApiConnector api;
  CartModel cart;
  @override
  void initState() {
    super.initState();
    api = new ApiConnector();
    double productCost = 0.0;
    cart=new CartModel();
    localData.getIntToSF(LocalData.USERID).then((userid) {
      api.getCartInfo(userid).then((cartinfo) {
        setState(() {
          cart = cartinfo;
          if (cartinfo.result == null) {
            strcartInfo = isArabic == true
                ? "لا توجد منتجات متاحة /n  ابدأ التسوق "
                : 'No Products Available \n    Start Shopping';
          } else if (cartinfo.result != null) {
            for (int i = 0; i < cartinfo.result.productsList.length; i++) {
              double item = cartinfo.result.productsList[i].discountedPrice *
                  cartinfo.result.productsList[i].quantity;

              productCost += item;
            }
            totalcost = productCost;
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
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(isArabic == true ? "إلغاء" : "Cancel"),
      onPressed: () {
        // Navigator.pop(ctx);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => HomeScreen()));
      },
    );
    Widget continueButton = FlatButton(
      child: Text(isArabic == true ? "استمر" : "Continue"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (context) => HomeScreen()));
        // Navigator.pop(ctx);        
        api.deleteCart(cart.result.cart.userId).then((deletecartCode) {
          if (deletecartCode == 200) {
            setState(() {
              strcartInfo = isArabic == true
                  ? "لا توجد منتجات متاحة"
                  : 'No Products Avaialble';
              cart = new CartModel();
              totalcost = 0;
            });
            
          } else {
            Toast.show(
                isArabic == true ? "تعذر مسح السلة" : 'Unable To Clear Cart',
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.CENTER);
            localData.addStringToSF(LocalData.CARTINFO, null);
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(isArabic == true ? "إنذار" : "Alert"),
      content: Text(isArabic == true
          ? "هل ترغب في الاستمرار؟"
          : "Would you like to continue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: WillPopScope(
          onWillPop: () {
            print('********* call Home Screen ***********');
            print("**** From Products :" + this.widget.fromproducts.toString());

            if (this.widget.fromproducts) {
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (context) => Example(
                      from: null,
                      catids: this.widget.catid,
                      searchtext: this.widget.searachstring)));
            } else {
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(builder: (context) => HomeScreen()));
            }

            return Future.value(false);
          },
          child: Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(
              title: Text(
                isArabic == true ? 'عربة التسوق' : 'My Cart',
                style: TextStyle(fontSize: 16.0),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                      Colors.indigo[900],
                      Colors.indigo[900],
                      Colors.indigo[900]
                    ])),
              ),
              actions: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    // child: Text(isArabic == true
                    //     ? "مجموع :" + totalcost.toStringAsFixed(2) + ' SAR'
                    //     : 'Total :' + totalcost.toStringAsFixed(2) + ' SAR')
                        ),
                Card(
                    shape: RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.blueGrey[100]),
                        borderRadius: BorderRadius.circular(15.0)),
                    margin: EdgeInsets.all(10),
                    color: Colors.white,
                    child: InkWell(
                        onTap: () {
                          if (cart.result != null) {
                            showAlertDialog(ctx);
                          }
                        },
                        child: Container(
                            height: 10,
                            width: 70,
                            margin: EdgeInsets.all(8),
                            child: Text(
                              isArabic == true ? 'عربة واضحة' : 'Clear Cart',
                              style: TextStyle(color: Colors.indigo[900]),
                            ))))
              ],
            ),
            body: Directionality(
              textDirection:
                  isArabic == true ? TextDirection.rtl : TextDirection.ltr,
              child: Container(
                color: Colors.white,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Container(
                    //   // margin: EdgeInsets.all(1.0),
                    //   child: Card(
                    //       shape: RoundedRectangleBorder(
                    //           side: new BorderSide(color: Colors.blueGrey[100]),
                    //           borderRadius: BorderRadius.circular(15.0)),
                    //       margin: EdgeInsets.all(8),
                    //       color: Colors.white,
                    //       child: Column(
                    //         children: <Widget>[
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: <Widget>[
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Column(
                    //                   children: <Widget>[
                    //                     Row(
                    //                       children: <Widget>[
                    //                         Icon(Icons.store),
                    //                         Text('Store: '),                                            
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Padding(
                    //                   padding: const EdgeInsets.all(8.0),
                    //                   child: RaisedButton(
                    //                     shape: new RoundedRectangleBorder(
                    //                         side: new BorderSide(
                    //                           color: Colors.blueGrey[100],
                    //                         ),
                    //                         borderRadius:
                    //                             new BorderRadius.circular(
                    //                                 18.0)),
                    //                     color: Colors.white,
                    //                     onPressed: () {},
                    //                     child: Text(
                    //                       isArabic == true
                    //                           ? "تم التوصيل"
                    //                           : 'Change',
                    //                       style: TextStyle(
                    //                           color: Colors.indigo[900]),
                    //                     ),
                    //                   )),
                    //             ],
                    //           ),
                    //         ],
                    //       )),
                    // ),
                  
                    Container(
                      child: Expanded(
                        child: cart == null || cart.result == null
                            ? Center(child: Text(strcartInfo))
                            : ListView.builder(
                                itemCount: cart.result == null
                                    ? 0
                                    : cart.result.productsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    margin: EdgeInsets.all(8.0),
                                    elevation: 1.0,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: new BorderSide(
                                        color: Colors.blueGrey[100],
                                      ),
                                    ),
                                    child: ListTile(
                                      title:Column(                                        
                                        // crossAxisAlignment: CrossAxisAlignment.cen,
                                        children: <Widget>[
                                          GradientText(
                                              isArabic == true
                                                  ? cart.result.productsList[index]
                                                      .name2
                                                  : cart.result.productsList[index]
                                                      .name1,
                                              gradient: LinearGradient(colors: [                                            
                                                Colors.grey[700],
                                                Colors.grey[700]
                                              ]),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.indigo[900]),
                                              textAlign: TextAlign.center),
                                           Text(
                                              isArabic == true
                                                  ? "السعر :" +
                                                      cart
                                                          .result
                                                          .productsList[index]
                                                          .discountedPrice
                                                          .toString() +
                                                      ' SAR'
                                                  : '' +
                                                      cart
                                                          .result
                                                          .productsList[index]
                                                          .discountedPrice
                                                          .toStringAsFixed(2) +
                                                      ' SAR',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.indigo[900])),
                                             
                                        ],
                                      ),
                                      subtitle: Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),                                                                                 
                                          Container(
                                            // padding: EdgeInsets.only(left:1.0, top:6, right: 15.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          cart
                                                              .result
                                                              .productsList[
                                                                  index]
                                                              .quantity--;
                                                          _removeItem(cart
                                                                  .result
                                                                  .productsList[
                                                              index]);
                                                        },
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 45.0,
                                                                    right:
                                                                        45.0),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                        .grey,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0)
                                                                            ),
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.indigo,size:20.0 ,
                                                            )))),
                                                Text(cart
                                                    .result
                                                    .productsList[index]
                                                    .quantity
                                                    .toString()),
                                                Expanded(
                                                    child: GestureDetector(
                                                  onTap: () {
                                                    cart
                                                        .result
                                                        .productsList[index]
                                                        .quantity++;

                                                    _additem(cart.result
                                                        .productsList[index]);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 45.0,
                                                        right: 45.0),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.indigo[900],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(13.0)),
                                                    child: Icon(Icons.add,
                                                        color: Colors.white, size: 20.0,),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                       SizedBox(
                                            height: 8,
                                          ), 
                                        ],
                                      ),
                                       
                                      trailing: Image(
                                        width: 100,
                                        height: 250,
                                        image: NetworkImage(cart.result
                                            .productsList[index].filepath),
                                      ),
                                      
                                    ),
                                  );
                                }),
                      ),
                    ),
                   Divider(color: Colors.white,),
                    cart.result == null?Container():
                     Container(
                      color: Colors.blueGrey[50],
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(isArabic==true?'المجموع الفرعي': 'Sub Total '),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(totalcost.toStringAsFixed(2) + ' SAR'),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(isArabic==true?'رسوم التوصيل ':'Delivery Fee '),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(isArabic==true?'مجانا ':'Free'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(isArabic==true?'مجموع (شامل ضريبة القيمة المضافة) ':'Total (Inclusive of VAT) '),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(totalcost.toStringAsFixed(2) + ' SAR'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ) ,
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
                            onPressed: () {
                              if (totalcost == 0) {
                                Toast.show(
                                    isArabic == true
                                        ? "الرجاء تحديد منتج واحد على الأقل"
                                        : 'Please Select Atleast One Product',
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.CENTER);
                                localData.addStringToSF(
                                    LocalData.CARTINFO, null);

                                Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              } else {
                                PostCartModel cartModel = new PostCartModel();

                                if (cart.result != null) {
                                  cartModel.cart = new CartPostInfo(
                                      id: cart.result.cart.id,
                                      userId: cart.result.cart.userId,
                                      name: cart.result.cart.name);
                                }
                                List<ProductsListModelCart> productsforpost =
                                    [];

                                for (int i = 0;
                                    i < cart.result.productsList.length;
                                    i++) {
                                  productsforpost.add(new ProductsListModelCart(
                                      productId:
                                          cart.result.productsList[i].productId,
                                      quantity: cart
                                          .result.productsList[i].quantity));
                                }
                                cartModel.productsList = productsforpost;
                                api
                                    .postCartUpdate(cartModel)
                                    .then((cartResponce) {
                                  if (cartResponce == 200) {
                                    Navigator.of(context)
                                        .push(new MaterialPageRoute(
                                            builder: (context) => StoreScreen(
                                                  items: null,
                                                  totalprice: totalcost,
                                                )));
                                  } else {
                                    Toast.show(
                                        isArabic == true
                                            ? "غير قادر على المضي قدما"
                                            : 'Unable to Proceed',
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                });
                              }
                            },
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
                        Icon(Icons.home, size: 20, color: Colors.grey[700],),
                        Text(isArabic == true ? "الصفحة الرئيسية" : "Home",
                            style: TextStyle(fontSize: 10, color: Colors.grey[700]))
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
                        Text(isArabic == true ? "التصنيفات" : "Categories",
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
                  //       Text(isArabic == true ? "صفقات" : "Deals",
                  //           style: TextStyle(fontSize: 10))
                  //     ],
                  //   ),
                  // ),
                  Tab(
                    icon: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(1.0)),
                        Icon(Icons.person_outline,
                            color: Colors.grey[700], size: 20),
                        Text(isArabic == true ? "حسابي" : "My account",
                            style: TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                  Tab(
                    icon: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(1.0)),
                        Icon(Icons.shopping_cart,
                            color: Colors.blue, size: 20,),
                        Text(isArabic == true ? "عربة التسوق" : "Cart",
                            style: TextStyle(fontSize: 10,color: Colors.blue))
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
                        builder: (context) => ProfileScreen()));
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
          ),
        ),
      ),
    );
  }

  void saveallproductsincart(List<ListResultProduct> data) {
    String dataString = placeOrdermodelToJson(data);
    print('------> orders String :' + dataString);
    localData.addStringToSF(LocalData.CARTINFO, dataString);
  }

  String placeOrdermodelToJson(List<ListResultProduct> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  void _removeItem(ProductsList fromlist) {
    setState(() {
      var items = cart.result.productsList
          .where((p) => p.productId == fromlist.productId)
          .toList();
      if (items != null && items.length > 0) {
        int index = cart.result.productsList
            .indexWhere((pro) => pro.productId == fromlist.productId);
        cart.result.productsList
            .removeWhere((pro) => pro.productId == fromlist.productId);
        if (fromlist.quantity > 0) {
          cart.result.productsList.insert(index, fromlist);
        } else {
          print("not more than One");
        }

        print('Removed item ');
      } else {
        print('Not exist in list  ');
      }

      double productCost = 0.0;
      for (int i = 0; i < cart.result.productsList.length; i++) {
        double item = cart.result.productsList[i].discountedPrice *
            cart.result.productsList[i].quantity;

        productCost += item;
      }
      totalcost = productCost;
    });
  }

  void _additem(ProductsList additem) {
    setState(() {
      var items = cart.result.productsList
          .where((p) => p.productId == additem.productId)
          .toList();

      if (items != null && items.length > 0) {
        int index = cart.result.productsList
            .indexWhere((pro) => pro.productId == additem.productId);
        cart.result.productsList
            .removeWhere((item) => item.productId == additem.productId);
        cart.result.productsList.insert(index, additem);
        print('Item Update   (+++)**************************** ID :' +
            additem.productId.toString());
      } else {
        cart.result.productsList.add(additem);
        print('Item Added   (+++)**************************** ID :' +
            additem.productId.toString());
      }

      // cartitemcount = cartProducts.length;
      double productCost = 0.0;
      for (int i = 0; i < cart.result.productsList.length; i++) {
        double item = cart.result.productsList[i].discountedPrice *
            cart.result.productsList[i].quantity;

        productCost += item;
      }
      totalcost = productCost;
    });
  }
}
