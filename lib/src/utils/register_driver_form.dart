import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DriverForm extends StatelessWidget {

  static GlobalKey<FormState> formDriverKey = new GlobalKey<FormState>();

  DriverBloc _driverBlocII;

  final driverModel = new DriverModel();
  final driverProvider = new DriverProvider();

  @override
  Widget build(BuildContext context) {

    _driverBlocII = BlocProvider.of<DriverBloc>(context);

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
              _buildNameField(),
              SizedBox(height: _screenHeight*0.02),
              _buildLicencePlateField(),
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
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.dialpad),
        labelText: 'Telefono*',
        hintText: 'Digite el telefono del conductor',
      ),
      autovalidate: false,
      keyboardType: TextInputType.number,
      onSaved: (value) => driverModel.phone = value,
      validator: (value) => _validatePhone(value),
    );
  }

  TextFormField _buildLicencePlateField() {
    return TextFormField(
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(AntDesign.car),
        labelText: 'Placa*',
        hintText: 'Digite la plca del vehiculo del conductor',
      ),
      autovalidate: false,
      keyboardType: TextInputType.text,
      onSaved: (value) => driverModel.licencePlate = value,
      validator: (value) => _validateLicencePlate(value),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.perm_identity),
        labelText: 'Nombre*',
        hintText: 'Digite el nombre del conductor',
      ),
      autovalidate: false,
      keyboardType: TextInputType.text,
      onSaved: (value) => driverModel.name = value,
      validator: (value) => _validateName(value),
    );
  }

  TextFormField _buildIdentificationField() {
    return TextFormField(
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(FontAwesome.address_card),
        labelText: 'Identificacion*',
        hintText: 'Digite la identificacion del conductor',
      ),
      autovalidate: false,
      keyboardType: TextInputType.number,
      onSaved: (value) => driverModel.identification = value,
      validator: (value) => _validateIdentification(value),
    );
  }

  _showAlert(BuildContext context){
    if(formDriverKey.currentState.validate()){
      formDriverKey.currentState.save();
      return AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          tittle: 'Desea completar este registro?',
          desc: '${driverModel.name} ${driverModel.licencePlate} identificado con ${driverModel.identification}',
          btnCancelOnPress: (){},
          btnOkOnPress: () => _submitForm(context)
      ).show();
    }
  }

  _submitForm(BuildContext context){
    driverModel.state = 'Inactivo';
    //driverProvider.addDriver(driverModel);
    _driverBlocII.add(AddDriver(driver: driverModel));
    formDriverKey.currentState.reset();
  }

  _validateIdentification(String value) {
    if(value.length < 8)
      return 'Por favor ingrese una identificacion valida';
    else
      return null;
  }

  _validatePhone(String value) {
    if(value.length < 10)
      return 'Por favor ingrese un telefono valido';
    else
      return null;
  }

  _validateName(String value) {
    if(value.length < 4)
      return 'Por favor ingrese un nombre valido';
    else
      return null;
  }

  _validateLicencePlate(String value) {
    if(value.length < 6 || value.length > 7)
      return 'Por favor ingrese una placa valida';
    else
      return null;
  }
}