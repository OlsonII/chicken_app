import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/driver_provider.dart';
import 'package:rxdart/rxdart.dart';

class DriverBloc {

  final _driverRProvider = DriverProvider();
  final _driversController = PublishSubject<List<DriverModel>>();

  Stream<List<DriverModel>> get allDrivers => _driversController.stream;


  getAllDrivers() async {
    //_driverRepository.getAllDrivers
    //_driversController.sink.add();
  }

  dispose(){
    _driversController.close();
  }

}

final driverBloc = DriverBloc();