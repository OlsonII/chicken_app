import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/driver_provider_api.dart';
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

  final List<DriverModel> drivers = new List();

  List<Object> get props => [drivers];
}

class GetSpecifyDriver extends DriverEvent {

  final DriverModel driver;

  const GetSpecifyDriver({@required this.driver}) : assert(driver != null);

  @override
  List<Object> get props => [driver];

}

class GetSpecifyDriverByName extends DriverEvent {

  final DriverModel driver;

  const GetSpecifyDriverByName({@required this.driver}) : assert(driver != null);

  @override
  List<Object> get props => [driver];

}

class EditDriver extends DriverEvent {

  final DriverModel driver;

  const EditDriver({@required this.driver}) : assert(driver != null);

  @override
  List<Object> get props => [driver];

}

class GetDriverByState extends DriverEvent {

  final DriverModel driver;

  const GetDriverByState({@required this.driver}) : assert(driver != null);

  @override
  List<Object> get props => [driver];

}


