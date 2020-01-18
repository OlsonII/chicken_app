import 'dart:ui';

import 'package:chicken_app/src/bloc/charge_bloc.dart';
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:flutter/material.dart';

class ChargesPage extends StatelessWidget {

  final chargesProvider = new ChargeProvider();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: chargesProvider.getCharges(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){
          final charges = snapshot.data;
          return ListView.builder(
              itemCount: charges.length,
              itemBuilder: (context, i) => _createItem(context, charges[i])
          );
          return Container();
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _createItem(BuildContext context, ChargeModel charge) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
      child: GestureDetector(
        child: ListTile(
          title: Text(charge.destination + ' - ' + charge.client, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          subtitle: Text('Cantidad de cajas: ${charge.quantity}', style: TextStyle(fontSize: 15),),
        ),
        onTap: () => print('pressed id: ${charge.id}'),
      ),
    );
  }
}
