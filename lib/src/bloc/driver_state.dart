import 'package:chicken_app/src/models/driver_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DriverState {}

class DriversEmpty extends DriverState {}

class DriversLoading extends DriverState {

}

class DriversLoaded extends DriverState {

  final List<DriverModel> drivers;

  DriversLoaded({@required this.drivers}) : assert(drivers != null);

  List<Object> get props => [drivers];
}

class DriverLoaded extends DriverState {

  final DriverModel driver;

  DriverLoaded({@required this.driver}) : assert(driver != null);

  Object get props => driver;
}

class DriversError extends DriverState {}

