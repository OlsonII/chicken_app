import 'package:chicken_app/src/bloc/charge_bloc.dart';
import 'package:chicken_app/src/bloc/charge_event.dart';
import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/bloc/driver_state.dart';
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:flutter/material.dart';

class ChooseDriverDialog extends StatefulWidget {

  ChargeModel _chargeModel;

  ChooseDriverDialog(ChargeModel chargeModel){
    _chargeModel = chargeModel;
  }

  @override
  _ChooseDriverDialogState createState() => _ChooseDriverDialogState(_chargeModel);
}

class _ChooseDriverDialogState extends State<ChooseDriverDialog> {


  List<DropdownMenuItem> drivers = new List<DropdownMenuItem>();

  String _driverSelected;
  ChargeModel _chargeModel;

  _ChooseDriverDialogState(ChargeModel chargeModel){
    _chargeModel = chargeModel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Escoja un conductor')),
      content: _buildDropDownMenu(context),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
      ),
      actions: <Widget>[
        _buildCancelButton(context),
        SizedBox(width: 10.0,),
        _buildCompleteButton(context)
      ],
    );
  }


  Padding _buildCompleteButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
          ),
          onPressed: () {
            _chargeModel.driver = _driverSelected;
            chargeBloc.sendChargeEvent.add(AddDriverToCharge(charge: _chargeModel));
            Navigator.pop(context, _driverSelected);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text('Completar'),
          ),
          color: Colors.green,
        ),
      );
  }

  Padding _buildCancelButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
          ),
          onPressed: ()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text('Cancelar'),
          ),
          color: Colors.red,
        ),
      );
  }

  _buildDropDownMenu(BuildContext context) {
    driverBloc.sendDriverEvent.add(GetDriverByState(driver: new DriverModel(state: 'Activo')));
    return StreamBuilder(
        stream: driverBloc.driverStream,
        initialData: DriversEmpty(),
        builder: (context, snapshot) {
          _fillDrivers(snapshot.data.drivers);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _dropdownButton(),
          );
        }
    );
  }

  Widget _dropdownButton() {
    return DropdownButton(
            icon: Icon(Icons.arrow_drop_down, color: Colors.blue,),
              iconSize: 24,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              hint: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Text('Escoja un conductor'),
              ),
              value: _driverSelected,
              items: drivers,
              onChanged: (value) {
                setState(() {
                  _driverSelected = value;
                });
              }
          );
  }

  _fillDrivers(List completeDrivers){
    drivers.clear();
    completeDrivers.forEach((driver){
      drivers.add(DropdownMenuItem(
        value: driver.name,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(driver.name),
        ),
      ));
    });
  }
}
