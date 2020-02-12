import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/bloc/charge_bloc.dart';
import 'package:chicken_app/src/bloc/charge_event.dart';
import 'package:chicken_app/src/bloc/charge_state.dart';
import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/bloc/driver_state.dart';
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:chicken_app/src/utils/choose_driver_dialog.dart';
import 'package:chicken_app/src/utils/globals_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ChargesPage extends StatefulWidget {

  @override
  _ChargesPageState createState() => _ChargesPageState();
}

class _ChargesPageState extends State<ChargesPage> {
  
  final todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {

    //chargeBloc.sendChargeEvent.add(GetChargesByDate(date: todayDate));
    chargeBloc.sendChargeEvent.add(GetCharges());

    return StreamBuilder(
      key: globalsKeys.driversDropDownKey,
      stream: chargeBloc.chargeStream,
      initialData: ChargesEmpty(),
      builder: (context, snapshot){
        if(snapshot.data is ChargesLoaded){
          return ListView.builder(
              itemCount: snapshot.data.charges.length,
              itemBuilder: (context, i) => _createItem(context, snapshot.data.charges[i])
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _createItem(BuildContext context, ChargeModel charge) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.17,
      movementDuration: Duration(milliseconds: 50),
      child: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
        child: ListTile(
          title: Text(charge.destination + ' - ' + charge.client, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          subtitle: Text('Cantidad de cajas: ${charge.quantity}', style: TextStyle(fontSize: 15),),
          leading: _chooseAvatar(charge.state),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Conductor',
          icon: Icons.perm_identity,
          color: Colors.red,
          onTap: () => charge.driver != null ? _showDriverProfile(context, charge.driver) : _chooseDriverAlert(charge),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Info',
          icon: Icons.info,
          color: Colors.blue,
          onTap: () => _showChargeInfoAlert(charge)
        ),
        if(charge.state != 'Entregado') _chooseOptionOfCharge(context, charge.state, charge)
      ],
    );
  }

  _chooseOptionOfCharge(BuildContext context, String state, ChargeModel charge){
    switch(state){
      case 'Generado':
        return IconSlideAction(
          caption: 'Enviar',
          icon: Icons.flight_takeoff,
          color: Colors.green,
          onTap: () => _showDeliverChargeConfirmAlert(charge),
        );
        break;
      case 'Enviado':
        return IconSlideAction(
          caption: 'Entregar',
          icon: Icons.flight_land,
          color: Colors.green,
          onTap: () => _deliverCharge(charge),
        );
        break;
    }
  }

  _sendCharge(ChargeModel charge){
    if(charge.driver != null) {
      charge.state = 'Enviado';
      chargeBloc.sendChargeEvent.add(EditChargeState(charge: charge));
      _showChargeDeliveredAlert();
    }else{
      _showNoDriverAlert();
    }
  }

  _deliverCharge(ChargeModel charge){
    charge.state = 'Entregado';
    chargeBloc.sendChargeEvent.add(EditChargeState(charge: charge));
  }

  _chooseAvatar(String state){
    Color color;
    Icon icon;
    switch(state){
      case 'Generado':
        color = Colors.redAccent;
        //icon = Icon(Icons.insert_drive_file, color: Colors.white);
        break;
      case 'Enviado':
        color =  Color.fromRGBO(254, 206, 46,  1);
        //icon = Icon(Icons.flight_takeoff, color: Colors.blue);
        break;
      case 'Entregado':
        color = Colors.green;
        //icon = Icon(Icons.flight_land, color: Colors.white);
        break;
    }
    return CircleAvatar(
      child: icon,
      backgroundColor: color,
      radius: 13.0,
    );
  }

  _showChargeInfoAlert(ChargeModel chargeModel){
      return AwesomeDialog(
          context: globalsKeys.scaffoldKey.currentContext,
          dialogType: DialogType.INFO,
          animType: AnimType.BOTTOMSLIDE,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('DESTINO: ${chargeModel.destination}'),
              Text('CLIENTE: ${chargeModel.client}'),
              Text('CONDUCTOR: ${chargeModel.driver}'),
              Text('CANTIDAD: ${chargeModel.quantity}'),
              Text('ESTADO: ${chargeModel.state}')
            ],
          ),
          btnOkOnPress: (){}
      ).show();
  }

  _showNoDriverAlert(){
    return AwesomeDialog(
        context: globalsKeys.scaffoldKey.currentContext,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        tittle: 'Sin conductor',
        desc: 'Por favor asigne un conductor antes de enviar',
        btnOkOnPress: (){}
    ).show();
  }

  _showDeliverChargeConfirmAlert(ChargeModel charge){
    return AwesomeDialog(
        context: globalsKeys.scaffoldKey.currentContext,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        tittle: 'Enviar carga',
        desc: ' ',
        btnOkOnPress: () => _sendCharge(charge),
        btnOkText: 'Enviar',
        btnCancelOnPress: (){}
    ).show();
  }

  _showChargeDeliveredAlert(){
    return AwesomeDialog(
        context: globalsKeys.scaffoldKey.currentContext,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        tittle: 'Exito',
        desc: 'Carga enviada con exito',
        btnOkOnPress: (){}
    ).show();
  }

  _chooseDriverAlert(ChargeModel chargeModel){
    return showDialog(
        context: globalsKeys.driversDropDownKey.currentContext,
        builder:(context) {
          return ChooseDriverDialog(chargeModel);
        }
    );

    /*return AwesomeDialog(
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        body: Container(
          child: Column(
            children: <Widget>[
              Text('Asignar conductor'),
              _buildDropDownMenu()
            ],
          ),
        ),
        btnOkOnPress: (){}, context: context
        ).show();*/
  }

  _showDriverProfile(BuildContext context, String driverName) {
    Navigator.pushNamed(context, '/profile_page', arguments: {'driverId': driverName, 'name': true});
  }




}
