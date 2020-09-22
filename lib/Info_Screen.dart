import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

void main() {
  runApp(GiftCardInfoApp());
}

class GiftCardInfoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Gift Card Info Screen',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Example Target Gift Card', style: TextStyle(color: Colors.green)), //giftcard.getName()?
            centerTitle: true,
            backgroundColor: Colors.greenAccent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );

              },
            ),
          ),

          body: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                child: Image(
                  image: NetworkImage('https://www.nicepng.com/png/full/11-112487_gift-card-target-target-gift-card-png.png'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    'Remaining Amount: 40.00', //giftcard.getRemainingAmount?
                    style: TextStyle(
                        fontSize: 25.0
                    )
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                  child: Text(
                    '#: 1234567890', //giftcard.getNumber?
                    style: TextStyle(
                        fontSize: 20.0
                    ),
                  )
              ),
              Container(
                  padding:EdgeInsets.all(10.0),
                  child: Text(
                      'SC: 123', //giftcard.getSecurityCode?
                      style: TextStyle(
                          fontSize: 20.0
                      )
                  )
              ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      'Expires: 01/01/20', //giftcard.getSecurityCode?
                      style: TextStyle(
                          fontSize: 20.0
                      )
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {print('Edited!');},
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 20.0),
                        ),
                        color: Colors.black54,
                      )
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {print('Deleted!');},
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              fontSize: 20.0),
                        ),
                        color: Colors.redAccent,
                      )
                  )
                ],
              )

            ],
          )

      ),
    );
  }
}