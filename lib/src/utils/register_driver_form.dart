import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DriverForm extends StatelessWidget {

  static GlobalKey<FormState> formDriverKey = new GlobalKey<FormState>();

  final driverModel = new DriverModel();
  final driverProvider = new DriverProvider();

  @override
  Widget build(BuildContext context) {

    final _deviceData = MediaQuery.of(context);
    final _screenHeight = _deviceData.size.height;
    final _screenWidth = _deviceData.size.width;

    return _buildPrincipalContainer(context, _screenHeight, _screenWidth);
  }

  Positioned _buildPrincipalContainer(BuildContext context, double _screenHeight, double _screenWidth) {
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
            child: _buildForm(context, _screenHeight, _screenWidth),
          ),
        ),
      ),
    );
  }

  Form _buildForm(BuildContext context, double _screenHeight, double _screenWidth) {
    return Form(
      key: formDriverKey,
      autovalidate: false,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text('Registrar Conductor', style: TextStyle(color: Colors.black, fontSize: 22.0),),
              ),
              SizedBox(height: _screenHeight*0.02),
              _buildIdentificationField(),
              SizedBox(height: _screenHeight*0.02),
              _buildFirstnameField(),
              SizedBox(height: _screenHeight*0.02),
              _buildLastnameField(),
              SizedBox(height: _screenHeight*0.02),
              _buildPhoneField(),
              SizedBox(height: _screenHeight*0.05),
              _buildButton(context, _screenWidth)
            ],
          ),
        ),
      ),
    );
  }

  Center _buildButton(BuildContext context, double _screenWidth) {
    return Center(
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
            onPressed: () => _showAlert(context),
          ),
        )
    );
  }

  TextFormField _buildPhoneField() {
    return TextFormField(
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.dialpad),
        labelText: 'Telefono*',
        hintText: 'Digite el telefono del conductor',
      ),
      keyboardType: TextInputType.number,
      onSaved: (value) => driverModel.phone = value,
    );
  }

  TextFormField _buildLastnameField() {
    return TextFormField(
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.perm_identity),
        labelText: 'Apellido*',
        hintText: 'Digite el apellido del conductor',
      ),
      keyboardType: TextInputType.text,
      onSaved: (value) => driverModel.lastname = value,
    );
  }

  TextFormField _buildFirstnameField() {
    return TextFormField(
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.perm_identity),
        labelText: 'Nombre*',
        hintText: 'Digite el nombre del conductor',
      ),
      keyboardType: TextInputType.text,
      onSaved: (value) => driverModel.firstname = value,
    );
  }

  TextFormField _buildIdentificationField() {
    return TextFormField(
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.contact_mail),
        labelText: 'Identificacion*',
        hintText: 'Digite la identificacion del conductor',
      ),
      keyboardType: TextInputType.text,
      onSaved: (value) => driverModel.identification = value,
    );
  }

  _showAlert(BuildContext context){
    formDriverKey.currentState.save();
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        tittle: 'Desea completar este registro?',
        desc: '${driverModel.firstname} ${driverModel.lastname} identificado con ${driverModel.identification}',
        btnCancelOnPress: (){},
        btnOkOnPress: () => _submitForm()
    ).show();
  }

  _submitForm(){
    print('driver register');
    driverModel.state = 'Inactivo';
    driverModel.charge = [];
    driverProvider.addDriver(driverModel);
    formDriverKey.currentState.reset();
  }
}