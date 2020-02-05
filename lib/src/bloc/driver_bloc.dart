import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/bloc/driver_state.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'package:bloc/bloc.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {

  DriverBloc();

  final _driverProvider = DriverProvider();

  @override
  DriverState get initialState => DriversEmpty();

  @override
  Stream<DriverState> mapEventToState(DriverEvent event) async* {

    if(event is AddDriver){

      yield DriversLoading();
      await _driverProvider.addDriver(event.driver);
      yield DriversLoaded(drivers: await _driverProvider.getDrivers());

    }else if(event is GetDrivers){

      yield DriversLoading();
      final drivers = await _driverProvider.getDrivers();
      yield DriversLoaded(drivers: drivers);

    }

  }

}