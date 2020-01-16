import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ChargeForm extends StatelessWidget {

  static GlobalKey<FormState> formChargeKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final _deviceData = MediaQuery.of(context);
    final _screenHeight = _deviceData.size.height;
    final _screenWidth = _deviceData.size.width;

    return Positioned(
      top: _screenHeight*0.25,
      //bottom: _screenHeight*0.15,
      right: 0,
      left: 0,
      bottom: 10,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Form(
              key: formChargeKey,
              autovalidate: false,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Text('Registrar Encargo', style: TextStyle(color: Colors.black, fontSize: 22.0),),
                      ),
                      SizedBox(height: _screenHeight*0.02),
                      TextFormField(
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          filled: true,
                          icon: Icon(Icons.flight_takeoff),
                          labelText: 'Destino*',
                          hintText: 'Escoja destino',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: _screenHeight*0.02),
                      TextFormField(
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          filled: true,
                          icon: Icon(Icons.perm_identity),
                          labelText: 'Cliente*',
                          hintText: 'Ingrese el cliente aqui',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: _screenHeight*0.02),
                      TextFormField(
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          filled: true,
                          icon: Icon(FontAwesome.truck),
                          labelText: 'Conductor*',
                          hintText: 'Digite el nombre del conductor',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: _screenHeight*0.02),
                      TextFormField(
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          filled: true,
                          icon: Icon(Icons.dialpad),
                          labelText: 'Cantidad*',
                          hintText: 'Digite la cantidad de cajas',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: _screenHeight*0.05),
                      Center(
                          child: ButtonTheme(
                            minWidth: _screenWidth*0.4,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Color.fromRGBO(254, 206, 46,  1))
                            ),
                            child: RaisedButton(
                              color: Color.fromRGBO(254, 206, 46,  1),
                              textColor: Colors.black,
                              child: Text("Registrar", style: TextStyle(fontSize: 15.0),),
                              onPressed: () {},
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}