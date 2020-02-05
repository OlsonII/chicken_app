import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/pages/home_page.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

//TODO: IMPLEMENT DIALOGS: https://flutterawesome.com/a-new-flutter-package-project-for-simple-and-awesome-dialogs/

class ChargeForm extends StatelessWidget {

  static GlobalKey<FormState> formChargeKey = new GlobalKey<FormState>();

  final chargeModel = new ChargeModel();
  final chargeProvider = new ChargeProvider();

  @override
  Widget build(BuildContext context) {

    final _deviceData = MediaQuery.of(context);
    final _screenHeight = _deviceData.size.height;
    final _screenWidth = _deviceData.size.width;

    return Positioned(
      top: _screenHeight*0.18,
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
              _buildDestinationfield(),
              SizedBox(height: _screenHeight*0.02),
              _buildClientField(),
              SizedBox(height: _screenHeight*0.02),
              _buildQuantityField(),
              SizedBox(height: _screenHeight*0.05),
              _buildButton(context, _screenWidth)
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildQuantityField() {
    return TextFormField(
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.dialpad),
        labelText: 'Cantidad*',
        hintText: 'Digite la cantidad de cajas',
      ),
      keyboardType: TextInputType.number,
      onSaved: (value) => chargeModel.quantity = int.parse(value),
    );
  }

  TextFormField _buildClientField() {
    return TextFormField(
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.perm_identity),
        labelText: 'Cliente*',
        hintText: 'Ingrese el cliente aqui',
      ),
      keyboardType: TextInputType.text,
      onSaved: (value) => chargeModel.client = value,
    );
  }

  TextFormField _buildDestinationfield() {
    return TextFormField(
      cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.flight_takeoff),
        labelText: 'Destino*',
        hintText: 'Escoja destino',
      ),
      keyboardType: TextInputType.text,
      onSaved: (value) => chargeModel.destination = value,
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

  _showAlert(BuildContext context){
    formChargeKey.currentState.save();
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      tittle: 'Desea completar este registro?',
      desc: '${chargeModel.quantity} cajas para ${chargeModel.client} en ${chargeModel.destination}',
      btnCancelOnPress: (){},
      btnOkOnPress: () => _submitForm()
    ).show();
  }

  _submitForm(){
    print('registro completado');
    chargeModel.state = 'Generado';
    chargeModel.date = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    chargeProvider.addCharge(chargeModel);
    formChargeKey.currentState.reset();
  }
}