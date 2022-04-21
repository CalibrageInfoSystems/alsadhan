import 'dart:convert';
import 'package:alsadhan/SignUp/SignUpScreen.dart';
import 'package:alsadhan/address.dart';
import 'package:alsadhan/allcategories/allcategories_screen.dart';
import 'package:alsadhan/cart/cart_screen.dart';
import 'package:alsadhan/delivery/settings.dart';
import 'package:alsadhan/home/DealsScreen.dart';
import 'package:alsadhan/home/home_screen.dart';
import 'package:alsadhan/localdb/LocalDb.dart';
import 'package:alsadhan/login/login.dart';
import 'package:alsadhan/models/UserInfoModel.dart';
import 'package:alsadhan/myorders/myorder_screen.dart';
import 'package:alsadhan/password/changepassword.dart';
import 'package:alsadhan/services/api_constants.dart';
import 'package:alsadhan/services/api_service.dart';
import 'package:alsadhan/widgets/RaisedGradientButton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';

TextEditingController userNameController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController landmarkController = TextEditingController();
TextEditingController surnameController = TextEditingController();
TextEditingController mobileNumberController = TextEditingController();
TextEditingController addressController = TextEditingController();
// TextEditingController oldpasswordController = TextEditingController();
// TextEditingController newpasswordController = TextEditingController();
String firstName;
String mobileNumber;
String lastName;
String email;
String roleID;
String userID;
String userName;
String id;

LocalData localData = new LocalData();
bool isArabic = false;
bool isUserLogin = false;

bool isSwitched = true;
ApiConnector api = new ApiConnector();

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfoModel userInfoModel = new UserInfoModel();
  final formKey = GlobalKey<FormState>();
  bool autovalidate = false;
  @override
  void initState() {
    super.initState();
    
    localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });
    getUserInformation();

    localData.getBoolValuesSF(LocalData.ISLOGIN).then((islogindata) {
      isUserLogin = islogindata;
    });

    // userNameController.text = "Abcd@gmail.com";
    // genderController.text = "Mr";
    // languageController.text = "English";

    localData.getStringValueSF(LocalData.USER_NAME).then((value) {
      userName = value;
      setState(() {
        // userNameController.text = value;
        print("==============" + value);
      });
    });

    // localData.getStringValueSF(LocalData.USER_FIRSTNAME).then((value) {
    //    firstName = value;
    //   setState(() {
    //     nameController.text = value;
    //     print("+++++++++++++++++++ firstname " + firstName);
    //   });
    // });

    // localData.getStringValueSF(LocalData.USER_LASTNAME).then((value) {
    //   // print("---->>>" + lastName);
    //   setState(() {
    //     surnameController.text = value;
    //     // print("---->>>" + mobileNumber);
    //   });
    // });

    // localData.getStringValueSF(LocalData.USER_MOBILENUMBER).then((value) {
    //   setState(() {
    //     mobileNumberController.text = value;
    //   });
    // });

    // localData.getStringValueSF(LocalData.USER_PASSWARD).then((value) {
    //   passward = value;
    //   setState(() {
    //     print("---->>> Password" + passward);
    //   });
    // });

    // localData.getStringValueSF(LocalData.USER_ROLEID).then((value) {
    //   roleID = value;
    //   print("---->>>" + roleID);

    //   setState(() {
    //     print("---->>>" + roleID);
    //   });
    // });

    // localData.getIntToSF(LocalData.USERID).then((value) {
    //   userID = value.toString();
    //   print("---->>>" + userID);

    //   setState(() {
    //     print("---->>>" + userID);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:DefaultTabController(
          length: 4,
      child: new Scaffold(
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
          title: Text(isArabic == true ? "الملف الشخصي" : "My Profile"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => HomeScreen())),
          )
          ),
      body: Directionality(
          textDirection:
              isArabic == true ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(
                  height: 200.0,
                  color: Colors.indigo[900],
                  child: Center(
                      child: Row(
                    children: <Widget>[
                      isArabic == true ?Container(               
                       padding: EdgeInsets.only(right: 140.0),
                        child: Row(
                          children: <Widget>[
                            Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    userInfoModel.listResult==null?" ":                                                                       
                                      userInfoModel.listResult[0].fullName
                                          .toString(),
                                      style: TextStyle(color: Colors.white)),
                                  Text(
                                    userInfoModel.listResult==null?" ":                                                                       
                                      userInfoModel.listResult[0].email
                                          .toString(),
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),                         
                          ],
                        ),
                      )
                      :Container(               
                       padding: EdgeInsets.only(left: 140.0),
                        child: Row(
                          children: <Widget>[
                            Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    userInfoModel.listResult==null?" ":                                                                       
                                      userInfoModel.listResult[0].fullName
                                          .toString(),
                                      style: TextStyle(color: Colors.white)),
                                  Text(
                                    userInfoModel.listResult==null?" ":                                                                       
                                      userInfoModel.listResult[0].email
                                          .toString(),
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                           
                            // Column(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceEvenly,
                            //     children: <Widget>[
                            //       Icon(
                            //         Icons.edit,
                            //         color: Colors.white,
                            //       ),
                            //     ])
                          ],
                        ),
                      ),
                    ],
                  ))),
              // Card(
              //   margin: EdgeInsets.all(8),
              //   elevation: 3.0,
              //   shape: new RoundedRectangleBorder(
              //     borderRadius: new BorderRadius.circular(18.0),
              //     side: new BorderSide(
              //       color: Colors.blueGrey[100],
              //     ),
              //   ),
              //   child: Column(
              //     children: <Widget>[
              //       Padding(
              //         padding: const EdgeInsets.all(12.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Column(
              //               children: <Widget>[
              //                 Icon(Icons.store),
              //                 GestureDetector(
              //                   onTap: () {
              //                     Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                           builder: (context) => MyOrders()),
              //                     );
              //                   },
              //                   child: Text(
              //                       isArabic == true
              //                           ? "طلب "
              //                           : 'Orders ',
              //                       style: TextStyle(
              //                           color: Colors.black45,
              //                           fontWeight: FontWeight.bold)),
              //                 )
              //               ],
              //             ),
              //             Column(
              //               children: <Widget>[
              //                 Icon(Icons.bookmark),
              //                 Text(
              //                     isArabic == true
              //                         ? "قائمة الرغبات "
              //                         : 'Wishlist ',
              //                     style: TextStyle(
              //                         color: Colors.black45,
              //                         fontWeight: FontWeight.bold)),
              //               ],
              //             ),
              //             Column(
              //               children: <Widget>[
              //                 Icon(Icons.notifications),
              //                 Text(
              //                     isArabic == true
              //                         ? " إشعارات "
              //                         : 'Notifications ',
              //                     style: TextStyle(
              //                         color: Colors.black45,
              //                         fontWeight: FontWeight.bold)),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
             
              Card(
                margin: EdgeInsets.all(8),
                elevation: 3.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: new BorderSide(
                    color: Colors.blueGrey[100],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                  isArabic == true
                                      ? " عنواني"
                                      : 'My Address ',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[                               
                                Text(userInfoModel.listResult==null?" ":
                                  userInfoModel.listResult[0].address
                                          .toString() +
                                      ','  +
                                      userInfoModel.listResult[0].landmark
                                          .toString() +
                                      ',\n' +
                                      userInfoModel.listResult[0].locationName1
                                          .toString() +
                                      ',' +
                                      userInfoModel.listResult[0].countryName1
                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(
                            color: Colors.blueGrey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  isUserLogin == true?
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddressScreen()),
                                  ):
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text(
                                  isArabic == true
                                      ? "تعديل العنوان"
                                      : "Edit Address",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[900],
                                      fontSize: 17.0),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.all(8),
                elevation: 3.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: new BorderSide(
                    color: Colors.blueGrey[100],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                  isArabic == true
                                      ? " رقم الهاتف المحمول "
                                      : 'My Mobile No ',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(userInfoModel.listResult==null?" ":
                                  userInfoModel.listResult[0].contactNumber
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // Divider(
                          //   color: Colors.blueGrey,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: <Widget>[
                          //     MaterialButton(
                          //       onPressed: () {},
                          //       color: Colors.white,
                          //       child: Text(
                          //         isArabic == true
                          //             ? "اسم المتجر : "
                          //             : 'Edit Address ',
                          //         style: TextStyle(
                          //             color: Colors.grey,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),

            //     child:
            // Column(
            //   children: <Widget>[
            //     Form(
            //       key: formKey,
            //       autovalidate: autovalidate,
            //       child: Container(
            //               padding: EdgeInsets.only(left: 30, right: 30),
            //               child: Column(children: <Widget>[
            //                 SizedBox(height: 50),
            //                 emailTextField(),
            //                 SizedBox(height: 15),
            //                 nameTextField(),
            //                 SizedBox(height: 15),
            //                 surNameTextField(),
            //                 SizedBox(height: 15),
            //                 mobileNumberTextField(),
            //                 SizedBox(height: 15),
            //                 // oldpasswordTextField(),
            //                 // SizedBox(height: 15),
            //                 // newpasswordTextField(),
            //                 // SizedBox(height: 15),
            //                 updateButton(context),
            //                 SizedBox(height: 15),
            //                 changePasswordButton(context),
            //               ])),
            // )
            //   ],
            // ),
          )),
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.transparent,
      //   child: updateButton(context),
      // ),
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
                        Icon(Icons.home, size: 20, color: Colors.grey[700]),
                        Text(isArabic == true?"الصفحة الرئيسية":"Home",
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
                            color: Colors.blue, size: 20),
                        Text(isArabic == true?"حسابي":"My account",
                         style: TextStyle(fontSize: 10, color: Colors.blue))
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
           
    )
      )
    );
  }

  emailTextField() {
    final username = TextFormField(
      keyboardType: TextInputType.text,
      controller: userNameController,
      autofocus: false,
      enabled: false,
      decoration: InputDecoration(
        hintText: isArabic == true ? "اسم المستخدم *" : "Username *",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.account_circle),
      ),
    );

    return username;
  }

  nameTextField() {
    final name = TextFormField(
      keyboardType: TextInputType.text,
      controller: nameController,
      autofocus: false,
      validator: validateName,
      //enabled: false,
      decoration: InputDecoration(
        hintText: isArabic == true ? firstname : "First name *",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.account_circle),
      ),
    );

    return name;
  }

  surNameTextField() {
    final surName = TextFormField(
      keyboardType: TextInputType.text,
      controller: surnameController,
      autofocus: false,
      validator: validateName,
      // (value) => value.isEmpty ? 'Last name is required' : null,
      //enabled: false,
      decoration: InputDecoration(
        hintText: isArabic == true ? "الكنية *" : "Last name *",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.account_circle),
      ),
    );
    return surName;
  }

  landmarkTextField() {
    final gender = TextFormField(
      keyboardType: TextInputType.text,
      controller: landmarkController,
      autofocus: false,
      //enabled: false,
      decoration: InputDecoration(
        hintText: isArabic == true ? "معلم معروف" : 'Landmark',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.group),
      ),
    );
    return gender;
  }

  mobileNumberTextField() {
    final mobileNumber = TextFormField(
      keyboardType: TextInputType.number,
      controller: mobileNumberController,
      autofocus: false,
      //enabled: false,
      validator: validateMobile,
      decoration: InputDecoration(
        hintText:
            isArabic == true ? "رقم الجوال مطلوب" : 'Mobile number is required',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.call),
      ),
    );
    return mobileNumber;
  }

  // oldpasswordTextField() {
  //   final oldpassword = TextFormField(
  //     keyboardType: TextInputType.text,
  //     controller: oldpasswordController,
  //     autofocus: false,
  //     //enabled: false,
  //     validator: (value) => value.isEmpty ? 'Old Password is required' : null,
  //     decoration: InputDecoration(
  //       hintText: 'Old password',
  //       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
  //       prefixIcon: Icon(Icons.vpn_key),
  //     ),
  //   );
  //   return oldpassword;
  // }

  // newpasswordTextField() {
  //   final newpassword = TextFormField(
  //     keyboardType: TextInputType.text,
  //     controller: newpasswordController,
  //     autofocus: false,
  //     //enabled: false,
  //     validator: (value) => value.isEmpty ? 'New Password is required' : null,
  //     decoration: InputDecoration(
  //       hintText: 'New Password',
  //       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
  //       prefixIcon: Icon(Icons.vpn_key),
  //     ),
  //   );
  //   return newpassword;
  // }

  addressTextField() {
    final language = TextFormField(
      keyboardType: TextInputType.text,
      controller: addressController,
      autofocus: false,
      // enabled: false,
      decoration: InputDecoration(
        hintText: isArabic == true ? "عنوان" : 'Address',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.language),
      ),
    );
    return language;
  }

  subscribeemail() {
    bool isSwitched = true;
    Switch(
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
        });
      },
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );
  }

  changePasswordButton(BuildContext context) {
    return Container(
      child: FlatButton(
        color: Colors.transparent,
        child: Text(
          isArabic == true ? "تغيير كلمة السر" : 'Change Password',
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.blueAccent,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
          );
        },
      ),
    );
  }

  updateButton(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(8),
      child: RaisedGradientButton(
        // padding: EdgeInsets.all(12),
        gradient: LinearGradient(
          colors: <Color>[Colors.lightBlueAccent, Colors.blue[900]],
        ),
        child: Text(isArabic == true ? "تحديث" : 'Update',
            style: TextStyle(color: Colors.white)),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            //Navigator.of(context).pop();
            // if(oldpasswordController.text==userInfoModel.listResult[0].password)
            // {
            // updateProfileAPICAlling(context);s
            //   oldpasswordController.clear();
            //   newpasswordController.clear();
            // }
            // else {
            //          Toast.show("Please Enter Correct Old Password", context,
            //          duration: Toast.LENGTH_LONG,
            //          gravity: Toast.BOTTOM);
            //          }
          } else {
            autovalidate = true;
          }
        },
      ),
    );
  }

  Future<void> getUserInformation() async {
    await localData.getIntToSF(LocalData.USERID).then((userID) {
      setState(() {
        api.getUserInfo(userID).then((response) {
          setState(() {
            if (response != null) {
              userInfoModel = response;
              print('::: Useinformation :::: ' +
                  userInfoModel.listResult.toString());
              userNameController.text = userInfoModel.listResult[0].userName;
              nameController.text = userInfoModel.listResult[0].firstName;
              surnameController.text = userInfoModel.listResult[0].lastName;
              mobileNumberController.text =
                  userInfoModel.listResult[0].contactNumber;
              surnameController.text = userInfoModel.listResult[0].lastName;
              // mobileNumberController.text = userInfoModel.listResult[0].contactNumber;
              // passward = userInfoModel.listResult[0].password;

              // selectedcity = areaNamesArray.firstWhere((are)=> are.cityId == userInfoModel.listResult[0].cityId);
            }
          });
        });
      });
    });
  }
}

// Future<void> updateProfileAPICAlling(BuildContext context) async {
//   final updateprofileURL = BASEURL + SIGNUPURL;

//   //MyordersModel productsModel = new MyordersModel();
//   print('*************API CALL :' + updateprofileURL);

//   final headers = {'Content-Type': 'application/json'};

//   Map<String, dynamic> body = {
//     "Id": userInfoModel.listResult[0].id,
//     "UserId": userInfoModel.listResult[0].userId,
//     "FirstName": nameController.value.text,
//     "MiddleName": null,
//     "LastName": surnameController.value.text,
//     "FullName": userInfoModel.listResult[0].fullName,
//     "UserName": userInfoModel.listResult[0].userName,
//     "ContactNumber": mobileNumberController.value.text,
//     "Password": userInfoModel.listResult[0].password,
//     "RoleId": userInfoModel.listResult[0].roleId,
//     "RoleName": userInfoModel.listResult[0].roleName,
//     "Email": null,
//     "CreatedByUserId": null,
//     "CreatedDate": userInfoModel.listResult[0].createdDate.toString(),
//     "UpdatedByUserId": null,
//     "UpdatedDate": DateTime.now().toString(),
//     "Address": userInfoModel.listResult[0].address,
//     "Landmark": userInfoModel.listResult[0].landmark,
//     "CountryId": userInfoModel.listResult[0].countryId,
//     "CityId": userInfoModel.listResult[0].cityId,
//     "LocationId": userInfoModel.listResult[0].locationId
//   };

//   print('*************API CALL :' + body.toString());

//   String jsonBody = json.encode(body);
//   print('*************API CALL :' + updateprofileURL);
//   print('*************API CALL :' + jsonBody);
//   final encoding = Encoding.getByName('utf-8');

//   Response response = await post(
//     updateprofileURL,
//     headers: headers,
//     body: jsonBody,
//     encoding: encoding,
//   );

//   int statusCode = response.statusCode;
//   String responseBody = response.body;

//   if (statusCode == 200) {
//     var userresponce = json.decode(responseBody);
//     //productsModel = MyordersModel.fromJson(userresponce);

//     print('::: User Profile Status :::: Success : 200');
//     print('::: User Profile Response :::: ' + userresponce.toString());
//     Toast.show(userresponce["EndUserMessage"], context,
//         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//     // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//     Navigator.pop(context);

//     //return productsModel;
//   } else {
//     print('::: placeOrder Response :::: error : ');
//     return null;
//   }
// }

String validateName(String value) {
  if (value.isEmpty) {
    return isArabic == true ? "مطلوب اسم" : 'Name is required';
  } else if (value.length < 3)
    return isArabic == true
        ? "يجب أن يكون الاسم أكثر من 3 أحرف"
        : 'Name must be more than 3 character';
  else
    return null;
}

String validateMobile(String value) {
  if (value.isEmpty) {
    return isArabic == true
        ? "مطلوب رقم الهاتف المحمول"
        : 'Mobile Number is required';
  } else if ((value.length < 10) || (value.length > 15)) {
    return isArabic == true
        ? "يجب أن يتراوح رقم الهاتف بين 10 إلى 15 رقمًا"
        : 'Mobile Number must between 10 to 15 digits';
  } else
    return null;
}
