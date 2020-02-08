import 'dart:convert';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:http/http.dart' as http;

class DriverProvider{

  static const String _URL = 'http://192.168.0.28:3000/api/drivers';

  Future<List<DriverModel>> getDrivers() async {
    try{
      final response = await http.get(_URL);
      final decodedData = jsonDecode(response.body);
      final List<DriverModel> drivers = new List();

      if(decodedData == null) return [];

      decodedData.forEach((driver){
        final driverTemp = DriverModel.fromJson(driver);
        drivers.add(driverTemp);
      });

      return drivers;
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<List<DriverModel>> getDriversByState(String state) async {
    try{
      final response = await http.get(_URL+'/state/$state');
      final decodedData = jsonDecode(response.body);
      final List<DriverModel> drivers = new List();

      if(decodedData == null) return [];

      decodedData.forEach((driver){
        final driverTemp = DriverModel.fromJson(driver);
        drivers.add(driverTemp);
      });

      print(drivers);
      return drivers;
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<bool> addDriver(DriverModel driverModel) async {
    return await http.post(_URL, headers: {'content-type': 'application/json'}, body: driverModelToJson(driverModel))
        .then((response) => true)
        .catchError((onError) => onError);
  }

  Future<DriverModel> getSpecifyDriver(String name) async{
    try{
      final response = await http.get(_URL+'/$name');
      final driver = jsonDecode(response.body);
      return DriverModel.fromJson(driver[0]);
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<bool> editDriver(DriverModel driverModel) async {
    return await http.put(_URL+'/${driverModel.identification}', headers: {'content-type': 'application/json'}, body: driverModelToJson(driverModel))
        .then((response) => true)
        .catchError((onError) => onError);
  }

  Future<bool> deleteDriver(DriverModel driverModel) async {
    return await http.delete(_URL+'/${driverModel.identification}', headers: {'content-type': 'application/json'})
        .then((response) => true)
        .catchError((onError) => onError);
  }

}