import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/bloc/driver_state.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'dart:async';

class DriverBloc{

  final _driverProvider = DriverProvider();

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
      _driverOutput.add(DriversLoading());
      await _driverProvider.addDriver(event.driver);
      _driverOutput.add(DriversLoaded(drivers: await _driverProvider.getDrivers()));
    }else if(event is GetDrivers){
      _driverOutput.add(DriversLoading());
      final drivers = await _driverProvider.getDrivers();
      _driverOutput.add(DriversLoaded(drivers: drivers));
    }else if(event is GetSpecifyDriver){
      _driverOutput.add(DriversLoading());
      final driver = await _driverProvider.getSpecifyDriver(event.driver.identification);
      _driverOutput.add(DriverLoaded(driver: driver));
    }else if(event is EditDriver){
      _driverOutput.add(DriversLoading());
      await _driverProvider.editDriver(event.driver);
      _driverOutput.add(DriversLoaded(drivers: await _driverProvider.getDrivers()));
    }else if(event is GetDriverByState){
      _driverOutput.add(DriversLoading());
      _driverOutput.add(DriversLoaded(drivers: await _driverProvider.getDriversByState(event.driver.state)));
    }
  }

}

final driverBloc = DriverBloc();