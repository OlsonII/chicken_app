import 'dart:convert';
import 'package:chicken_app/src/bloc/charge_bloc.dart';
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:http/http.dart' as http;



class ChargeProvider {

  static const String _URL = 'http://192.168.0.28:3000/api/charges';

  Future<List<ChargeModel>> getCharges() async {
    try{
      final response = await http.get(_URL);
      final decodedData = jsonDecode(response.body);
      final List<ChargeModel> charges = new List();

      if(decodedData == null) return [];

      decodedData.forEach((charge){
        final chargeTemp = ChargeModel.fromJson(charge);
        charges.add(chargeTemp);
      });

      return charges;
    }catch(e){
      print(e);
    }
  }

  Future<List<ChargeModel>> getChargesByState(String state) async {
    try{
      final response = await http.get(_URL+'/$state');
      final decodedData = jsonDecode(response.body);
      final List<ChargeModel> charges = new List();

      if(decodedData == null) return [];

      decodedData.forEach((charge){
        final chargeTemp = ChargeModel.fromJson(charge);
        charges.add(chargeTemp);
      });

      return charges;
    }catch(e){
      print(e);
    }
  }

  Future<List<ChargeModel>> getChargesByDate(String date) async {
    try{
      final response = await http.get(_URL+'/$date');
      final decodedData = jsonDecode(response.body);
      final List<ChargeModel> charges = new List();

      if(decodedData == null) return [];

      decodedData.forEach((charge){
        final chargeTemp = ChargeModel.fromJson(charge);
        charges.add(chargeTemp);
      });

      return charges;
    }catch(e){
      print(e);
    }
  }

  Future<ChargeModel> getSpecifyCharge(String id) async{
    try{
      final response = await http.get(_URL+'/$id');
      final charge = jsonDecode(response.body);
      return ChargeModel.fromJson(charge[0]);
    }catch(e){

    }
  }

  Future<bool> addCharge(ChargeModel chargeModel) async {
    return await http.post(_URL, headers: {'content-type': 'application/json'}, body: chargeModelToJson(chargeModel))
        .then((response) => true)
        .catchError((onError) => onError);
  }

  Future<bool> editChargeState(ChargeModel chargeModel) async {
    print(chargeModel);
    print(chargeModelToJson(chargeModel));
    return await http.put(_URL+'/${chargeModel.id}', headers: {'content-type': 'application/json'}, body: chargeModelToJson(chargeModel))
        .then((response) => true)
        .catchError((onError) => onError);
  }

}