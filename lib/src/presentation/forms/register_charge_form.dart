
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/application/charge_bloc.dart';
import 'package:chicken_app/src/application/charge_event.dart';
import 'package:chicken_app/src/domain/charge.dart';
import 'package:chicken_app/src/infraestructure/charge_repository_api.dart';
import 'package:chicken_app/src/infraestructure/utils/global_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChargeForm extends StatefulWidget {

  static GlobalKey<FormState> formChargeKey = new GlobalKey<FormState>();

  @override
  _ChargeFormState createState() => _ChargeFormState();
}

class _ChargeFormState extends State<ChargeForm> {

  final chargeModel = new Charge();
  final chargeProvider = new ChargeProviderApi();

  FocusNode _destinationFocus;
  FocusNode _clientFocus;
  FocusNode _quantityFocus;

  @override
  void initState() {
    super.initState();

    _destinationFocus = FocusNode();
    _clientFocus = FocusNode();
    _quantityFocus = FocusNode();
  }

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
      key: ChargeForm.formChargeKey,
      autovalidate: false,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text('Registrar Encargo', style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: _screenHeight*0.02),
              _buildDestinationField(context),
              SizedBox(height: _screenHeight*0.02),
              _buildClientField(context),
              SizedBox(height: _screenHeight*0.02),
              _buildQuantityField(context),
              SizedBox(height: _screenHeight*0.05),
              _buildButton(context, _screenWidth)
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildQuantityField(BuildContext context) {
    return TextFormField(
      focusNode: _quantityFocus,
      cursorColor: Colors.blueGrey,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.dialpad),
        labelText: 'Cantidad*',
        hintText: 'Digite la cantidad de cajas',
      ),
      keyboardType: TextInputType.number,
      onSaved: (value) => chargeModel.quantity = int.parse(value),
      onFieldSubmitted: (_){
        _showAlert(context);
      },
    );
  }

  TextFormField _buildClientField(BuildContext context) {
    return TextFormField(
      focusNode: _clientFocus,
      cursorColor: Colors.blueGrey,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.perm_identity),
        labelText: 'Cliente*',
        hintText: 'Ingrese el cliente aqui',
      ),
      keyboardType: TextInputType.text,
      onSaved: (value) => chargeModel.client = value,
      onFieldSubmitted: (_){
        _fieldFocusChange(context, _clientFocus, _quantityFocus);
      }
    );
  }

  TextFormField _buildDestinationField(BuildContext context) {
    return TextFormField(
      focusNode: _destinationFocus,
      cursorColor: Colors.blueGrey,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        filled: true,
        icon: Icon(Icons.flight_takeoff),
        labelText: 'Destino*',
        hintText: 'Escoja destino',
      ),
      keyboardType: TextInputType.text,
      onSaved: (value) => chargeModel.destination = value,
      onFieldSubmitted: (_){
        _fieldFocusChange(context, _destinationFocus, _clientFocus);
      }
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
    _unfocusLast(context);
    ChargeForm.formChargeKey.currentState.save();
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
    ChargeForm.formChargeKey.currentState.reset();
    chargeModel.state = 'Generado';
    chargeModel.date = DateFormat('dd/MM/yyyy').format(globalDate.dateSelected).toString();
    chargeBloc.sendChargeEvent.add(AddCharge(charge: chargeModel));
  }

  _unfocusLast(BuildContext context){
    FocusScope.of(context).unfocus();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {

    _quantityFocus.dispose();
    _clientFocus.dispose();
    _destinationFocus.dispose();

    super.dispose();
  }
}