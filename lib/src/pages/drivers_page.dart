import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/bloc/driver_state.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class DriversPage extends StatelessWidget {

  final driverProvider = new DriverProvider();
  DriverBloc _driverBlocII;

  @override
  Widget build(BuildContext context) {

    _driverBlocII = BlocProvider.of<DriverBloc>(context);
    _driverBlocII.add(GetDrivers());

    return BlocBuilder<DriverBloc, DriverState>(
      builder: (context, state){
        if(state is DriversLoaded){
          return ListView.builder(
              itemCount: state.drivers.length,
              itemBuilder: (context, i) => _createItem(context, state.drivers[i])
          );
        }else if(state is DriversEmpty){
          return Center(child: Text('Sin Informacion'));
        }else{
          print(state);
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
          subtitle: Text('${driver.phone}', style: TextStyle(fontSize: 15)),
          trailing: Icon(Icons.directions_car, color: driver.state == 'Activo' ? Colors.green : Colors.red),
        ),
        onTap: () => Navigator.pushNamed(context, '/profile_page', arguments: driver.name),
      ),
    );
  }
}
