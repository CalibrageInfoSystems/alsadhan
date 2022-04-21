import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/models/DeliveryOrder.dart';
import 'package:alsadhan/models/MyordersModel.dart';
import 'package:alsadhan/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as Datetime;

bool isArabic = false;

class OrderDetailViewScreen extends StatefulWidget {
  ListResultMyorder order;
  OrderDetailViewScreen({this.order});

  @override
  _OrderDetailViewScreenState createState() => _OrderDetailViewScreenState();
}

class _OrderDetailViewScreenState extends State<OrderDetailViewScreen> {
  LocalData localData = new LocalData();
  ApiConnector apiConnector;
  DeliveryOrder orderDetails;
  var formatter = new Datetime.DateFormat('dd-MM-yyyy HH:mm aa');

  @override
  void initState() {
    super.initState();
    apiConnector = new ApiConnector();
    apiConnector
        .getOrderDetails(this.widget.order.id.toString())
        .then((orderDetailsfromapi) {
      setState(() {
        orderDetails = orderDetailsfromapi;
      });
    });

    localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: new Text(isArabic == true ? "تفاصيل الطلب " : 'Order Details'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Directionality(
        textDirection: isArabic == true ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    // Text(isArabic == true ?"معلومات الطلب " :'Order Info ', style: TextStyle(color: Colors.blue)),
                    Card(
                      margin: EdgeInsets.all(8),
                      elevation: 3.0,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: new BorderSide(
                          color: Colors.blueGrey[100],
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                    isArabic == true
                                        ? "رقم التعريف الخاص بالطلب :  "
                                        : 'Order ID : ',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    this.widget.order.code,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Text(
                                  isArabic == true
                                      ? "اسم المتجر : "
                                      : 'Store Name  : ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    this.widget.order.storeName1,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Text(
                                    isArabic == true
                                        ? "عنوان :   "
                                        : 'Address  : ',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      this.widget.order.shippingAddress,
                                      style: TextStyle(color: Colors.black),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Text(
                                    isArabic == true
                                        ? "تاريخ التسليم او الوصول : "
                                        : 'Delivery Date  : ',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    mainDate(this.widget.order.deliveryDate) +
                                        "   " +
                                        widget.order.timeSlot,
                                    // formatter
                                    //     .format(this.widget.order.deliveryDate),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Text(
                                    isArabic == true
                                        ? "السعر الكلي : "
                                        : 'Total Price  : ',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    this
                                            .widget
                                            .order
                                            .totalPrice
                                            .toStringAsFixed(2) +
                                        ' SAR',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        child: this.widget.order.deliveryAgentName == null
                            ? Divider()
                            : Card(
                                margin: EdgeInsets.all(8),
                                elevation: 3.0,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: new BorderSide(
                                    color: Colors.blueGrey[100],
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(isArabic == true
                                              ? 'اسم الوكيل :'
                                              : 'Delivery AgentName : '),
                                          Text(
                                            this.widget.order.deliveryAgentName,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: <Widget>[
                                          Text(isArabic == true
                                              ? 'رقم الاتصال :'
                                              : 'ContactNumber : '),
                                          Text(
                                            this
                                                .widget
                                                .order
                                                .deliveryAgentContactNumber,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                  ],
                ),
              ),

              //  SizedBox(
              //               child: Text(isArabic == true ?"معلومات المنتجات " :
              //                 'Products Info',
              //                 style: TextStyle(color: Colors.blue),
              //               ),
              //             ),

              Container(
                child: Expanded(
                  child: ListView.builder(
                      itemCount: orderDetails == null
                          ? 0
                          : orderDetails.listResult.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Container(
                          child: Card(
                            margin: EdgeInsets.all(8),
                            // elevation: 3.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: new BorderSide(
                                color: Colors.blueGrey[50],
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  // Text(
                                  //   orderDetails.listResult[index].name1,
                                  //   style: TextStyle(color: Colors.blue),
                                  // ),
                                  // Divider(),
                                  Column(
                                    children: <Widget>[
                                      Row(
                                         mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            orderDetails.listResult[index].name1,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                            //  Text(isArabic == true
                                            //   ? "مجموع : "
                                            //   : 'Total : ' ),
                                          Text(
                                            (orderDetails.listResult[index]
                                                            .quantity *
                                                        orderDetails
                                                            .listResult[index]
                                                            .price)
                                                    .toStringAsFixed(2) +
                                                ' SAR',
                                            style: TextStyle(color: Colors.black),
                                          )                             
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[                                        
                                          Text(isArabic == true
                                              ? "السعر : "
                                              : 'Price : ' +
                                                  orderDetails
                                                      .listResult[index].price
                                                      .toStringAsFixed(2)),
                                                                                  
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text((isArabic == true
                                                  ? "كمية : "
                                                  : 'Qty : ') +
                                              orderDetails
                                                  .listResult[index].quantity
                                                  .toString()),                                       
                                        ],
                                      ),
                                    
                                   
                                    ],
                                  ),

                                  // SizedBox(height: 10)
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            
            ],
          ),
        ),
      ),
    );
  }

  mainDate(DateTime date) {
    var formatter = new Datetime.DateFormat('d MMMM y');
    String dates = formatter.format(date);
    print(dates); // something like 2013-04-20
    return dates;
  }
}
