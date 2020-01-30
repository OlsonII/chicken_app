import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/bloc/charge_bloc.dart';
import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChargesPage extends StatelessWidget {

  final chargesProvider = new ChargeProvider();

  @override
  Widget build(BuildContext context) {
    chargeBloc.getAllCharges();
    return StreamBuilder(
      stream: chargeBloc.allCharges,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){
          final charges = snapshot.data;
          return ListView.builder(
              itemCount: charges.length,
              itemBuilder: (context, i) => _createItem(context, charges[i])
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
      actionExtentRatio: 0.25,
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
          onTap: () => charge.driver.length > 2 ? _showDriverInfoAlert(context, charge.driver) : _chooseDriver(),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Info',
          icon: Icons.info,
          color: Colors.blue,
          onTap: () => _showChargeInfoAlert(context, charge)
        ),
        IconSlideAction(
          caption: 'Entregar',
          icon: Icons.flight_land,
          color: Colors.green,
          //onTap: () => _showAlert(context, charge),
        )
      ],
    );
  }

  _chooseAvatar(String state){
    Color color;
    Icon icon;
    switch(state){
      case 'Generado':
        color = Colors.redAccent;
        icon = Icon(Icons.insert_drive_file, color: Colors.white);
        break;
      case 'Enviado':
        color =  Color.fromRGBO(254, 206, 46,  1);
        icon = Icon(Icons.flight_takeoff, color: Colors.blue);
        break;
      case 'Entregado':
        color = Colors.green;
        icon = Icon(Icons.flight_land, color: Colors.white);
        break;
    }
    return CircleAvatar(
      child: icon,
      backgroundColor: color,
    );
  }

  _showChargeInfoAlert(BuildContext context, ChargeModel chargeModel){
      return AwesomeDialog(
          context: context,
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

  _showDriverInfoAlert(BuildContext context, String driverId) {
    print('searching driver');
    StreamBuilder(
      stream: driverBloc.allDrivers,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          // ignore: missing_return
          snapshot.data.forEach((driver){
            if (driver.identification == driverId){
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('IDENTIFICACION: ${driver.destination}'),
                      Text('NOMBRE: ${driver.name}'),
                      Text('PLACA: ${driver.licencePlate}'),
                      Text('TELEFONO: ${driver.phone}'),
                    ],
                  ),
                  btnOkOnPress: (){}
              ).show();
            }
          });
        }
        return null;
      },
    );
  }

  _chooseDriver() {
    print('without driver');
  }
}
