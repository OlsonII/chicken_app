import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/application/charge_bloc.dart';
import 'package:chicken_app/src/application/charge_event.dart';
import 'package:chicken_app/src/infraestructure/charge_repository_firebase.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  static GlobalKey<FormState> formVerificationKey = new GlobalKey<FormState>();
  static const String _ACCESS_CODE = '1065843800';
  String _codeRegister;

  final provider = new ChargeProviderFirebase();

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    chargeBloc.sendChargeEvent.add(GetCharges());

    return Scaffold(
      body: Container(
          color: Color.fromRGBO(254, 206, 46,  1),
          child: StreamBuilder(
            stream: chargeBloc.chargeStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return _buildForm(_screenSize, context);
              }else{
                //_showAlert(context, 'Sin conexion', 'Por favor, revise su conexion e intente nuevamente');
              return Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Intentando conectar con el servidor', style: TextStyle(fontSize: 15.0),),
                  SizedBox(height: _screenSize.height*0.05),
                  CircularProgressIndicator(),
                ],
              )
              );
              }
            },
          )
      ),
    );
  }

  Column _buildForm(Size _screenSize, BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 170.0,
              height: 170.0,
              image: AssetImage('assets/img/chicken.png'),
            ),
            Center(
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Form(
                    key: SplashScreen.formVerificationKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Codigo de acceso',
                          labelText: 'Codigo de acceso*'
                      ),
                      onSaved: (value) => _codeRegister = value,
                    ),
                  ),
                )
            ),
            SizedBox(height: _screenSize.height*0.1,),
            Center(
                child: ButtonTheme(
                  minWidth: _screenSize.width*0.3,
                  height: _screenSize.height*0.05,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)
                  ),
                  child: RaisedButton(
                    color: Colors.white,
                    textColor: Colors.blue,
                    child: Text("Ingresar", style: TextStyle(fontSize: 15.0),),
                    onPressed: () => _submit(context),
                  ),
                )
            )
          ],
        );
  }

  _submit(BuildContext context){
    SplashScreen.formVerificationKey.currentState.save();
    _codeRegister == SplashScreen._ACCESS_CODE?
    Navigator.pushReplacementNamed(context, '/home') : _showAlert(context, 'Credenciales incorrectas', 'Por favor ingrese la credencial correcta');
  }

  _showAlert(BuildContext context, String tittle, String content){
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        tittle: tittle,
        desc: content,
        btnOkOnPress: () {}
    ).show();
  }
}
