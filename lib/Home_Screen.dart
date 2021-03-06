import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/About_Page.dart';
import 'package:flutter_app/Gift_Card.dart';
import 'Databases/Database.dart';
import 'package:flutter_app/Notification_Plugin.dart';
import 'Card_Info_Screen.dart';
import 'package:flutter_app/Create_New_Card_Screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add or View Saved Cards',
      home: HomeScreenState(title: 'Add or View Saved Cards'),
    );
  }
}

class HomeScreenState extends StatefulWidget {
  HomeScreenState({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<HomeScreenState> {
  /// The list of the current gift cards.
  List<GiftCard> giftCards = [];



  /// The list of gift card widgets, created by calling the [seeGiftCardButton]
  /// method for each item in the [giftCards].
  List<Widget> get giftCardWidgets =>
      giftCards.map((item) => seeGiftCardButton(item)).toList();

  _MyHomeScreenState();

  /// Sets up the initial state for the [HomeScreen] widget.
  @override
  void initState() {
    //Retrieves the gift cards that are currently in the database when the user opens the app
    setUpGiftCards();

    //Sets the initial state of the widget
    super.initState();

    //Sets this page to be opened when any notification is clicked.


  }

  @override
  Widget build(BuildContext context) {
    if (giftCards.isNotEmpty) {
      return setUpNotEmptyList(context);
    } else {
      return setUpEmptyList(context);
    }
  }

  //Builds the home screen given there are no giftcards stored
  Widget setUpEmptyList(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add or View Saved Cards", style: TextStyle(color: Colors.white, fontSize: 20.0)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(CupertinoIcons.info, color: Colors.white,),
            onPressed: () {goToAbout(context);},
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: <Widget>[
              Expanded(
                child : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                      child: Image(
                          image: NetworkImage('https://i.pinimg.com/originals/04/05/f3/0405f352b0c0e76adfbced77465b0f9c.jpg')
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                        child: Text(
                          "You don't have any gift cards yet!",
                          style: TextStyle(fontSize: 30, color: Colors.black26), textAlign: TextAlign.center,
                        )
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                        child: Text(
                          "Press the add button to get started!",
                          style: TextStyle(fontSize: 30, color: Colors.black26), textAlign: TextAlign.center,
                        )
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    // label: Text("Add A Card",
                    //     style: TextStyle(
                    //       fontSize: 25.0,
                    //       color: Colors.green,
                    //    )
                    // ),
                    // icon: Icon(Icons.add_a_photo, color: Colors.green, size: 50.0),
                    //
                    // color: Colors.greenAccent,
                    // padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: Icon(Icons.add),
                    onPressed: (){
                      _getGiftCardInfo(context);
                    },
                  ),
                ],
              ),

            ]

        )
    );
  }


//Builds the home screen given there are gift cards stored
  Widget setUpNotEmptyList(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add or View Saved Cards",
              style: TextStyle(color: Colors.white, fontSize: 20.0)),
          centerTitle: true,
          backgroundColor: Colors.blue


        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: giftCardWidgets),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _getGiftCardInfo(context);
                    },
                  ),
                ],
              ),
            ]));
  }

  //Returns a button that when clicked, goes to the gift Card information page
  Widget seeGiftCardButton(GiftCard card) {
    return Card(
        child: ListTile(
      onTap: () {
        _modifyGiftCard(context, card);
      },
      title: Text(card.name,
          style: TextStyle(fontSize: 28, color: Colors.black38)),
      leading: Image.file(File(card.photo)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Balance: \$' + card.balance,
            style: TextStyle(fontSize: 16, color: Colors.black38),
          ),
          Text(
            'Exp: ' + card.expirationDate,
            style: TextStyle(fontSize: 16, color: Colors.black38),
          )
        ],
      ),
    ));
  }

  /// Updates the list of [giftCards] when there is a new card is added, or an
  /// existing card is edited or deleted.
  ///
  /// Gets all the cards currently stored in the [Database], and maps all of
  /// them to the [giftCards] list. After it, the notifications and the widget
  /// get updated.
  void setUpGiftCards() async {
    List<Map<String, dynamic>> _results = await DB.query(GiftCard.table);
    giftCards = _results.map((item) => GiftCard.fromMap(item)).toList();
    setUpNotifications();
    setState(() {});
  }

  /// Sets up the notifications, based on the current [giftCards].
  ///
  /// Cancels all the previous notifications, and then adds a weekly notification
  /// and a scheduled notification for each [giftCard]. Cancelling all previous
  /// notifications is necessary in order to handle changes when a gift card is
  /// edited or deleted.
  void setUpNotifications() async {
    await notificationPlugin.cancelAllNotifications();
    await notificationPlugin.setOnNotificationClick(onNotificationClick);;
    if(giftCards.length != 0){
      await notificationPlugin.sendWeeklyNotification();

      for (GiftCard giftCard in giftCards) {
        await notificationPlugin.sendScheduledNotifications(giftCard);
      }

    }
  }

  /// Handles changes in the screen when a [card] is deleted or edited in the
  /// [CardInfoScreen].
  _modifyGiftCard(BuildContext context, GiftCard card) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CardInfoScreen(card)));
    setUpGiftCards();
  }

  //Handles going to the About screen
  goToAbout(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutPageScreen()));
  }

  /// Manipulates the information the user entered in the [CreateNewCardScreen].
  ///
  /// Converts the [result] of the [CreateNewCardScreen] into a [GiftCard]
  /// object named [card], and, if the [card] is not null, it is added to the
  /// [Database]. Then, the [setUpGiftCards] method is called to update the
  /// contents of the [giftCards] list.
  _getGiftCardInfo(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateNewCardScreen()),
    );

    GiftCard card = result;

    if (card != null) {
      await DB.insert(GiftCard.table, card);
      setUpGiftCards();
    }
  }

  /// Opens the [HomeScreen] when a notification is clicked.
  onNotificationClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return build(context);
    }));
  }
}


