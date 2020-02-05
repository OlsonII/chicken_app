import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


abstract class DriverEvent extends Equatable {
  const DriverEvent();
}

class AddDriver extends DriverEvent {

  final DriverModel driver;

  const AddDriver({@required this.driver}) : assert(driver != null);

  List<Object> get props => [driver];
}

class GetDrivers extends DriverEvent {

  DriverProvider _driverProvider = new DriverProvider();

  final List<DriverModel> drivers = new List();

  List<Object> get props => [_driverProvider.getDrivers()];
}