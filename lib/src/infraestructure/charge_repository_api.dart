import 'dart:convert';
import 'package:chicken_app/src/domain/charge.dart';
import 'package:chicken_app/src/infraestructure/i_charge_repository.dart';
import 'package:http/http.dart' as http;



class ChargeProviderApi implements IChargeProvider{

  static const String _URL = 'http://192.168.0.28:3000/api/charges';

  Future<List<Charge>> getCharges() async {
    try{
      final response = await http.get(_URL);
      final decodedData = jsonDecode(response.body);
      final List<Charge> charges = new List();

      if(decodedData == null) return [];

      decodedData.forEach((charge){
        final chargeTemp = Charge.fromJson(charge);
        charges.add(chargeTemp);
      });

      return charges;
    }catch(e){
      print(e);
    }
  }

  Future<List<Charge>> getChargesByState(String state) async {
    try{
      final response = await http.get(_URL+'/state/$state');
      final decodedData = jsonDecode(response.body);
      final List<Charge> charges = new List();

      if(decodedData == null) return [];

      decodedData.forEach((charge){
        final chargeTemp = Charge.fromJson(charge);
        charges.add(chargeTemp);
      });

      return charges;
    }catch(e){
      print(e);
    }
  }

  Future<List<Charge>> getChargesByDate(String date) async {
    try{
      final response = await http.get(_URL+'/$date');
      final decodedData = jsonDecode(response.body);
      final List<Charge> charges = new List();

      if(decodedData == null) return [];

      decodedData.forEach((charge){
        final chargeTemp = Charge.fromJson(charge);
        charges.add(chargeTemp);
      });

      return charges;
    }catch(e){
      print(e);
    }
  }

  Future<List<Charge>> getChargesByDriver(String driverId) async {
    try{
      final response = await http.get(_URL+'/driver/$driverId');
      final decodedData = jsonDecode(response.body);
      final List<Charge> charges = new List();

      if(decodedData == null) return [];

      decodedData.forEach((charge){
        final chargeTemp = Charge.fromJson(charge);
        charges.add(chargeTemp);
      });

      return charges;
    }catch(e){
      print(e);
    }
  }

  Future<Charge> getSpecifyCharge(String id) async{
    try{
      final response = await http.get(_URL+'/$id');
      final charge = jsonDecode(response.body);
      return Charge.fromJson(charge[0]);
    }catch(e){

    }
  }

  Future<bool> addCharge(Charge chargeModel) async {
    return await http.post(_URL, headers: {'content-type': 'application/json'}, body: chargeModelToJson(chargeModel))
        .then((response) => true)
        .catchError((onError) => onError);
  }

  editCharge(Charge chargeModel){}

  Future<bool> editChargeState(Charge chargeModel) async {
    return await http.put(_URL+'/${chargeModel.id}', headers: {'content-type': 'application/json'}, body: chargeModelToJson(chargeModel))
        .then((response) => true)
        .catchError((onError) => onError);
  }

  Future<bool> addDriverToCharge(Charge chargeModel) async {
    return await http.put(_URL+'/${chargeModel.id}/driver', headers: {'content-type': 'application/json'}, body: chargeModelToJson(chargeModel))
        .then((response) => true)
        .catchError((onError) => onError);
  }

}