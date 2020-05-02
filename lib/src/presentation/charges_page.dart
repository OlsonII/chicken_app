import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/application/charge_bloc.dart';
import 'package:chicken_app/src/application/charge_event.dart';
import 'package:chicken_app/src/application/charge_state.dart';
import 'package:chicken_app/src/domain/charge.dart';
import 'package:chicken_app/src/infraestructure/utils/globals_keys.dart';
import 'package:chicken_app/src/infraestructure/utils/global_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChargesPage extends StatefulWidget {

  @override
  _ChargesPageState createState() => _ChargesPageState();
}

class _ChargesPageState extends State<ChargesPage> {

  final todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {

    chargeBloc.sendChargeEvent.add(GetChargesByDate(date: globalDate.formatDate(globalDate.dateSelected)));
    return StreamBuilder(
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

  _createItem(BuildContext context, Charge charge) {
    if(charge.state != 'Cancelado')
      return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.17,
        movementDuration: Duration(milliseconds: 50),
        child: _buildChargePrincipalInfo(charge),
        secondaryActions: <Widget>[
          _buildInfoAction(charge),
          if(charge.state != 'Entregado') _chooseOptionOfCharge(context, charge.state, charge),
          _buildCancelAction(charge),
        ],
      );
  }

  Container _buildChargePrincipalInfo(Charge charge) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
      child: ListTile(
        title: Text('${charge.destination } -  ${charge.client}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        subtitle: Text('Cantidad de cajas: ${charge.quantity} - \$${charge.totalCost} ', style: TextStyle(fontSize: 15),),
        leading: _chooseAvatar(charge.state),
      ),
    );
  }

  IconSlideAction _buildCancelAction(Charge charge) {
    return IconSlideAction(
        caption: 'Cancelar',
        icon: Icons.cancel,
        color: Colors.red,
        onTap: () {
          charge.state = 'Cancelado';
          chargeBloc.sendChargeEvent.add(DeleteCharge(charge: charge));
        }
    );
  }

  IconSlideAction _buildInfoAction(Charge charge) {
    return IconSlideAction(
        caption: 'Info',
        icon: Icons.info,
        color: Colors.blue,
        onTap: () => _showChargeInfoAlert(charge)
    );
  }


  _chooseOptionOfCharge(BuildContext context, String state, Charge charge){
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

  _deliverCharge(Charge charge){
    charge.state = 'Entregado';
    chargeBloc.sendChargeEvent.add(EditChargeState(charge: charge));
  }

  _chooseAvatar(String state){
    Color color;
    switch(state){
      case 'Generado':
        color = Colors.redAccent;
        break;
      case 'Enviado':
        color =  Color.fromRGBO(254, 206, 46,  1);
        break;
      case 'Entregado':
        color = Colors.green;
        break;
    }
    return CircleAvatar(
      backgroundColor: color,
      radius: 13.0,
    );
  }

  _showChargeInfoAlert(Charge chargeModel){
    return AwesomeDialog(
        context: globalsKeys.scaffoldKey.currentContext,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        body: /*QrImage(
          data: chargeModel.id,
          version: QrVersions.auto,
          size: 40,
        ) */Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('DESTINO: ${chargeModel.destination}'),
            Text('CLIENTE: ${chargeModel.client}'),
            Text('CANTIDAD: ${chargeModel.quantity}'),
            Text('ESTADO: ${chargeModel.state}'),
            Text('COSTO: \$${chargeModel.totalCost}'),
          ],
        ),
        btnOkOnPress: (){}
    ).show();
  }

  _showDeliverChargeConfirmAlert(Charge charge){
    return AwesomeDialog(
        context: globalsKeys.scaffoldKey.currentContext,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        tittle: 'Enviar carga',
        desc: ' ',
        btnOkOnPress: () {},
        btnOkText: 'Enviar',
        btnCancelOnPress: (){}
    ).show();
  }

}
