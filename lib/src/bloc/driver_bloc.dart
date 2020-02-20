import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/bloc/driver_state.dart';
import 'package:chicken_app/src/providers/driver_provider_api.dart';
import 'dart:async';

import 'package:chicken_app/src/providers/driver_provider_firebase.dart';

class DriverBloc{

  //final _driverProvider = DriverProvider();
  final _driverProviderFirebase = DriverProviderFirebase();

  StreamController<DriverEvent> _driverInput = StreamController();
  StreamController<DriverState> _driverOutput = StreamController.broadcast();

  Stream<DriverState> get driverStream => _driverOutput.stream;
  StreamSink<DriverEvent> get sendDriverEvent => _driverInput.sink;

  DriverBloc(){
    _driverInput.stream.listen(_onEvent);
  }

  void dispose() {
    _driverInput.close();
    _driverOutput.close();
  }

  void _onEvent(DriverEvent event) async{
    if(event is AddDriver){

      //_driverOutput.add(DriversLoading());
      //await _driverProvider.addDriver(event.driver);
      await _driverProviderFirebase.addDriver(event.driver);
      _driverOutput.add(DriversLoaded(drivers: await _driverProviderFirebase.getDrivers()));

    }else if(event is GetDrivers){

      //_driverOutput.add(DriversLoading());
      //final drivers = await _driverProvider.getDrivers();
      final drivers = await _driverProviderFirebase.getDrivers();
      _driverOutput.add(DriversLoaded(drivers: drivers));

    }else if(event is GetSpecifyDriver){

      //_driverOutput.add(DriversLoading());
      //final driver = await _driverProvider.getSpecifyDriver(event.driver.identification);
      final driver = await _driverProviderFirebase.getSpecifyDriver(event.driver.identification);
      _driverOutput.add(DriversLoaded(drivers: driver));

    }else if(event is GetSpecifyDriverByName){

      //_driverOutput.add(DriversLoading());
      //final driver = await _driverProvider.getSpecifyDriver(event.driver.identification);
      final driver = await _driverProviderFirebase.getSpecifyDriverByName(event.driver.name);
      _driverOutput.add(DriversLoaded(drivers: driver));

    }else if(event is EditDriver){

      //_driverOutput.add(DriversLoading());
      //await _driverProvider.editDriver(event.driver);
      await _driverProviderFirebase.editDriver(event.driver);
      _driverOutput.add(DriversLoaded(drivers: await _driverProviderFirebase.getDrivers()));

    }else if(event is GetDriverByState){

      //_driverOutput.add(DriversLoading());
      _driverOutput.add(DriversLoaded(drivers: await _driverProviderFirebase.getDriversByState(event.driver.state)));
    }
  }

}

final driverBloc = DriverBloc();