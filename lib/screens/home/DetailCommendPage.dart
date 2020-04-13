import 'package:flutter/material.dart';
import 'package:emenu_covid/models/foods.dart';
import 'package:emenu_covid/models/order.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/screens/home/FirstPage.dart';
import 'package:emenu_covid/screens/home/OrderHeader.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/models/restaurant.dart';
import 'package:emenu_covid/sqlite/db_helper.dart';
import 'package:emenu_covid/screens/home/MyOrder.dart';
import 'package:emenu_covid/globals.dart';
import 'package:flutter/services.dart';
import 'package:emenu_covid/services/AlertForm.dart';

String _mImage;
String _mRestaurantName;
Future<Menu> _menuPage1;
Future<Restaurant> _rest;

void main() {
  runApp(DetailCommendPage());
}

class DetailCommendPage extends StatelessWidget {
  final String restaurantID;

  DetailCommendPage({
    this.restaurantID,
  });

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'รายละเอียด',
      debugShowCheckedModeBanner: false,
      home: new HomePage(
        restaurantID: restaurantID,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String restaurantID;

  HomePage({
    this.restaurantID,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Future<List<Order>> orders;
  int foodID;

  String foodsName;
  double price;
  double priceS;
  double priceM;
  double priceL;
  String size;
  String description;
  String images;
  int qty;
  double totalPrice;
  String taste;
  String comment = '';

  List<Order> HaveData;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;

////// ALL FUNCTION

  _showAlertLogout(String strLogOut) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('ยังไม่สามารถ Logout ได้ ' + strLogOut),
            content: Text(""),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => null),
                  );
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final titleString = "";

  void refreshRestaurant() async {
    String strBody = '{"restaurantID":"${widget.restaurantID}"}';

    var feed = await NetworkFoods.loadRestaurantByID(strBody: strBody);
    var data = DataFeed(feed: feed);
    if (data.feed.ResultOk.toString() == "true") {
      if (data.feed.data.length > 0) {
        _mImage = data.feed.data[0].images;
        _mRestaurantName = data.feed.data[0].restaurantName;
      }
    } else {}
  }

  refreshPage1() {
    String strBody = '{"restaurantID":"${widget.restaurantID}"}';
    setState(() {
      _menuPage1 = NetworkFoods.loadFoodsAsset(
          RestaurantID: widget.restaurantID, Recommend: '0');
    });
  }

  refreshRestCover() {
    String strBody = '{"restaurantID":"${widget.restaurantID}"}';
    setState(() {
      _rest = NetworkFoods.loadRestaurantByID(strBody: strBody);
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 1, vsync: this);
    super.initState();
    dbHelper = DatabaseHelper();
    refreshRestaurant();
    refreshPage1();
    refreshRestCover();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: Text(globals.restaurantName.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
//        bottom: TabBar(
//          indicator: UnderlineTabIndicator(
//            borderSide: BorderSide(width: 1.0),
//            insets: EdgeInsets.only(left: 0.0, right: 8.0, bottom: 4.0),
//          ),
//          //  isScrollable: true,
//          labelPadding: EdgeInsets.only(left: 0, right: 0),
//
//          tabs: [
//            Padding(
//              padding: const EdgeInsets.only(right: 0),
//
//              child: new Tab(
//
//                child: Text(
//                  'รายการอาหาร',
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontFamily: 'Kanit',
//                  ),
//
//                ),
//              ),
//            ),
//          ],
//          controller: _tabController,
////          indicatorColor: Colors.white,
////          indicatorSize: TabBarIndicatorSize.tab,
//        ),
//        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [Page1()],
        controller: _tabController,
      ),
      bottomNavigationBar: new BottomAppBar(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
                icon: new Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstPage()),
                  );
                }),
            //   new IconButton(icon: new Text('SAVE'), onPressed: null),

            new IconButton(
                icon: new Icon(Icons.restaurant),
                onPressed: () {
                  if (globals.restaurantID != null) {
                    if (globals.restaurantID != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailCommendPage(
                                  restaurantID: globals.restaurantID,
                                )),
                      );
                    } else {}
                  } else {}
                }),

            new IconButton(
                icon: new Icon(Icons.add_shopping_cart),
                onPressed: () {
                  if (globals.restaurantID != null) {
                    if (globals.restaurantID != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyOrder()),
                      );
                    } else {}
                  } else {}
                }),

            new IconButton(
                icon: new Icon(Icons.list),
                onPressed: () {
                  if (globals.restaurantID != null) {
                    if (globals.restaurantID != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderHeader()),
                      );
                    } else {}
                  } else {}
                }),

            new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){

              showAlert(context);
              // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }),
          ],
        ),
      ),
    );
  }

  // ALL WIDGET

  List<detailFood> detailFoods = [];

  Widget Page1() {
    return CustomScrollView(
      slivers: <Widget>[
//        SliverAppBar(
//          expandedHeight: 100,
//          pinned: true,
//          floating: false,
//          flexibleSpace: new FlexibleSpaceBar(
//              title: FutureBuilder<Restaurant>(
//                  future: _rest,
//                  builder: (context, snapshot) {
//                    if (snapshot.hasData) {
//                      return new Text(
//                        snapshot.data.data[0].restaurantName,
//                        style: TextStyle(
//                          color: Colors.red,
//                          fontWeight: FontWeight.normal,
//                          fontFamily: 'kanit',
//                        ),
//                      );
//                    } else if (snapshot.hasError) {
//                      return Text("${snapshot.error}");
//                    }
//                    return Container(
//                      child: Center(
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            SizedBox(
//                              child: CircularProgressIndicator(),
//                              height: 10.0,
//                              width: 10.0,
//                            )
//                          ],
//                        ),
//                      ),
//                    );
//                  }),
//              background: Container(
//                height: 100.0,
//                width: 420.0,
//                decoration: BoxDecoration(
//                  gradient: LinearGradient(
//                      colors: [Colors.black.withOpacity(0.1), Colors.black],
//                      begin: Alignment.topCenter,
//                      end: Alignment.bottomCenter),
//                ),
//                child: FutureBuilder<Restaurant>(
//                    future: _rest,
//                    builder: (context, snapshot) {
//                      if (snapshot.hasData) {
//                        return new Image.network(
//                          snapshot.data.data[0].images,
//                          fit: BoxFit.cover,
//                        );
//                      } else if (snapshot.hasError) {
//                        return Text("${snapshot.error}");
//                      }
//                      return Container(
//                        child: Center(
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              SizedBox(
//                                child: CircularProgressIndicator(),
//                                height: 10.0,
//                                width: 10.0,
//                              )
//                            ],
//                          ),
//                        ),
//                      );
//                    }),
//              )),
//        ),
        SliverFillRemaining(
          child: FutureBuilder<Menu>(
              future: _menuPage1,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return new Container(
                      child: _ListSection(menu: snapshot.data),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              child: CircularProgressIndicator(),
                              height: 10.0,
                              width: 10.0,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(),
                            height: 10.0,
                            width: 10.0,
                          )
                        ],
                      ),
                    ),
                  );
                }
              }),
        )
      ],
    );
  }

  void _foo({String m_foodID, String m_foodName, String m_price}) async {
    foodID = int.parse(m_foodID);
    HaveData = await dbHelper.getByID(foodID);

    if (HaveData.length == 0) {
      foodsName = m_foodName;
      price = double.parse(m_price);
      size = "";
      description = "";
      images = "";
      qty = 1;
      totalPrice = qty * price;
      taste = "";

      Order e = Order(foodID, foodsName, price, size, description, images, qty,
          totalPrice, taste, comment);

      dbHelper.save(e);
      globals.hasMyOrder = "1";
      globals.restaurantID = widget.restaurantID;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyOrder()),
      );
    } else {
      dbHelper.updateBySQL(foodsID: foodID);
      globals.restaurantID = widget.restaurantID;
      // showSnak();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyOrder()),
      );
    }
  }

  Widget _ListSection({Menu menu}) => ListView.builder(
        itemBuilder: (context, int idx) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: new ListTile(
                    leading: Text(menu.data[idx].foodsTypeNameLevel2,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit',
                        )),

                    // title: Text(menu.data[idx].foodsTypeNameLevel2),
                    trailing: Text(
                      'ทั้งหมด (${menu.data[idx].foodsItems.length})',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit'),
                    ),
                  ),
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: new Container(
                          child: ListTile(
                            leading: Icon(
                              Icons.fastfood,
                              color: Colors.redAccent,
                              size: 20.0,
                            ),
                            title: Text(
                              menu.data[idx].foodsItems[index].foodName,
                              style: TextStyle(fontFamily: 'Kanit'),
                            ),
//                          subtitle: Text(
//                            menu.data[idx].foodsItems[index].price.toString(),
//                            style: TextStyle(
//                              fontFamily: 'Kanit',
//                            ),
//                          ),
                            trailing: FlatButton(
                                color: Colors.deepOrange,
                                textColor: Colors.white,
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                                child: Text(
                                  menu.data[idx].foodsItems[index].price
                                          .toString() +
                                      " บาท",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onPressed: () => _foo(
                                      m_foodID: menu
                                          .data[idx].foodsItems[index].foodID
                                          .toString(),
                                      m_foodName: menu
                                          .data[idx].foodsItems[index].foodName,
                                      m_price: menu
                                          .data[idx].foodsItems[index].price,
                                    )),
                          ),
                          decoration: new BoxDecoration(
                              border: Border(
                                  bottom: new BorderSide(
                            color: Colors.grey[350],
                            width: 0.5,
                            style: BorderStyle.solid,
                          ))),
                        ));
                  },
                  itemCount: menu.data[idx].foodsItems.length,
                  shrinkWrap: true,
                  // todo comment this out and check the result
                  physics:
                      ClampingScrollPhysics(), // todo comment this out and check the result
                )
              ],
            ),
          );
        },
        itemCount: menu.data.length,
      );
}

class DataFeed {
  Restaurant feed;

  DataFeed({this.feed});
}
