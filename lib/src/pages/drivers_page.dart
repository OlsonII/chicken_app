import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/bloc/driver_state.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class DriversPage extends StatelessWidget {

  final driverProvider = new DriverProvider();

  @override
  Widget build(BuildContext context) {

    driverBloc.sendDriverEvent.add(GetDrivers());

    return StreamBuilder<DriverState>(
      stream: driverBloc.driverStream,
      initialData: DriversEmpty(),
      builder: (context, snapshot){
        if(snapshot.data is DriversLoaded){
          return ListView.builder(
              itemCount: snapshot.data.drivers.length,
              itemBuilder: (context, i) => _createItem(context, snapshot.data.drivers[i])
          );
        }else if(snapshot.data is DriversEmpty){
          return Center(child: Text('Sin Informacion'));
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _createItem(BuildContext context, DriverModel driver) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.17,
      movementDuration: Duration(milliseconds: 50),
      child: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
        child: GestureDetector(
          child: ListTile(
            title: Text(driver.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            subtitle: Text('${driver.phone}', style: TextStyle(fontSize: 15)),
            trailing: Icon(Icons.directions_car, color: driver.state == 'Activo' ? Colors.green : Colors.red),
          ),
          onTap: () => Navigator.pushNamed(context, '/profile_page', arguments: driver.name),
        ),
      ),
      actions: <Widget>[
        if (driver.state == 'Inactivo')
        IconSlideAction(
          caption: 'Activar',
          icon: Icons.check,
          color: Colors.green,
          onTap: () {
            //change driver state
            driver.state = 'Activo';
            driverBloc.sendDriverEvent.add(EditDriver(driver: driver));
          },
        )
      ],
      secondaryActions: <Widget>[
        if (driver.state == 'Activo')
        IconSlideAction(
            caption: 'Desactivar',
            icon: Icons.close,
            color: Colors.red,
            onTap: () {
              driver.state = 'Inactivo';
              driverBloc.sendDriverEvent.add(EditDriver(driver: driver));
            }
        ),
      ],
    );
  }
}
