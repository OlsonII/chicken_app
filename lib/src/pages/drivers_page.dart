import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'package:flutter/material.dart';

class DriversPage extends StatelessWidget {

  final driverProvider = new DriverProvider();
  @override
  Widget build(BuildContext context) {
    driverBloc.getAllDrivers();
    return StreamBuilder(
      stream: driverBloc.allDrivers,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){
          final drivers = snapshot.data;
          return ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, i) => _createItem(context, drivers[i])
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _createItem(BuildContext context, DriverModel driver) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
      child: GestureDetector(
        child: ListTile(
          title: Text(driver.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          subtitle: Text('${driver.state}', style: TextStyle(fontSize: 15, color: driver.state == 'Activo' ? Colors.green : Colors.red)),
        ),
        onTap: () => Navigator.pushNamed(context, '/profile_page', arguments: driver),
      ),
    );
  }
}
