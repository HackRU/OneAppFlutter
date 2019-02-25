import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:HackRU/colors.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => new _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String qr;
  bool camState = false;
//  final ValueChanged<String> qrCodeCallback;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: bluegrey_dark,
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: camState ? new Center(
                  child: new SizedBox(
                    width: 800.0, height: 1000.0,      //400-550
                    child: new QrCamera(
                      onError: (context, error) => Text(error.toString(), style: TextStyle(color: pink_light, fontSize: 25),),
                      qrCodeCallback: (code) {
                        setState(() async {
                          qr = code;
                          try{
                            var cred = await login('test@ment.or', 'test');
                            var user = await getUser(cred, '$qr');
                            if(await user.alreadyDid('fake_event109') == false){
                              await updateUserDayOf(cred, user, "fake_event109");
                              var user2 = await getUser(cred, '$qr');
                              print("************* update user day_of *************");
                              print(user);
                              print(user2);
                              await showDialog<void>(context: context, barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(backgroundColor: transp,
                                    title: Text("Successfull Login!", style: TextStyle(fontSize: 16, color: mintgreen_light),),
                                    actions: <Widget>[FlatButton(child: Text('OK', style: TextStyle(fontSize: 16, color: mintgreen_dark),), onPressed: () {Navigator.pop(context, 'Ok');},),],
                                  );
                                },
                              );
                            }
                            else{
                              await showDialog<void>(context: context, barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(backgroundColor: transp,
                                    title: Text("ERROR: Already Scanned!", style: TextStyle(fontSize: 16, color: pink_light),),
                                    actions: <Widget>[FlatButton(child: Text('OK', style: TextStyle(fontSize: 16, color: mintgreen_dark),), onPressed: () {Navigator.pop(context, 'Ok');},),],
                                  );
                                },
                              );
                            }
                          } on LcsLoginFailed catch (e){
                            print('ERROR!!');
                            showDialog<void>(context: context, barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(backgroundColor: bluegrey_dark,
                                  title: Text("ERROR: \n'"+LcsLoginFailed().toString()+"'", style: TextStyle(fontSize: 16, color: pink_light),),
                                  actions: <Widget>[FlatButton(child: Text('OK', style: TextStyle(fontSize: 16, color: mintgreen_dark),), onPressed: () {Navigator.pop(context, 'Ok');},),],
                                );
                              },
                            );
                          }

                        });
                      },
                      child: new Container(
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: mintgreen_light, width: 2.0, style: BorderStyle.solid),
                        ),
                      ),
                    ),
                  ),
                ) : new Center(child: Padding(
                  padding: const EdgeInsets.only(top:220.0), child: Column(children: <Widget>[new Text("Camera Inactive!", style: TextStyle(fontSize: 25, color:  white),), new Text("Click Camera Icon Below to Scan QR Codes!", style: TextStyle(fontSize: 18, color:  white),), SizedBox(height: 15,), Icon(GroovinMaterialIcons.arrow_bottom_right, color: mintgreen_light, size: 50,),],),))
            ),
            new Text("QRCODE: $qr", style: TextStyle(color: white, fontSize: 15),),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: bluegrey,
          foregroundColor: mintgreen_light,
          child: new Icon(FontAwesomeIcons.camera),
          onPressed: () { camState ? setState(() {camState = !camState;}) :
            showModalBottomSheet<Null>(
              context: context,
              builder: (BuildContext context) => _getDemoDrawer(),
            );
          }),
    );
  }

  Widget _getDemoDrawer() {
    return Drawer(
      child: ListView(
      children: <Widget>[
        SizedBox(height: 10,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.check_circle, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Check-In', style: TextStyle(fontWeight: FontWeight.bold, color: mintgreen_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food_fork_drink, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Lunch-1', style: TextStyle(fontWeight: FontWeight.bold, color: pink_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food_fork_drink, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Dinner', style: TextStyle(fontWeight: FontWeight.bold, color: mintgreen_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.tshirt_crew, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('T-Shirts', style: TextStyle(fontWeight: FontWeight.bold, color: pink_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Midnight-Meal', style: TextStyle(fontWeight: FontWeight.bold, color: mintgreen_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.star, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Midnight-Surprise', style: TextStyle(fontWeight: FontWeight.bold, color: pink_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Breakfast', style: TextStyle(fontWeight: FontWeight.bold, color: mintgreen_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food_fork_drink, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Lunch-2', style: TextStyle(fontWeight: FontWeight.bold, color: pink_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),

      ],
      ),
    );
  }

  void _open() async {
    setState(() {camState = !camState;});
    Navigator.pop(context);
  }

}