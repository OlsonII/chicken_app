
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ChargeProviderFirebase {

  ChargeProviderFirebase(){
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    chargesDocument.keepSynced(true);
  }

  static final db = FirebaseDatabase.instance.reference();
  static final chargesDocument = db.child('charges');


  addCharge(ChargeModel chargeModel){
    chargesDocument.push().set(chargeModel.toJson());
  }

  getCharges() async {
    List<ChargeModel> charges = new List();
    await chargesDocument.orderByValue().once().then((DataSnapshot snapshot) {
      var chargesIds = snapshot.value.keys;
      var chargesData = snapshot.value;

      for(var chargeId in chargesIds){
        charges.add(new ChargeModel.fromJson(chargesData[chargeId]));
      }

    }).catchError((onError){
      print(onError);
    });
    return charges;
  }

  getChargesByDate(String date) async {
    List<ChargeModel> charges = new List();
    await chargesDocument.once().then((DataSnapshot snapshot) {
      var chargesIds = snapshot.value.keys;
      var chargesData = snapshot.value;

      for(var chargeId in chargesIds){
        if(chargesData[chargeId]['date'] == date) charges.add(new ChargeModel.fromJson(chargesData[chargeId]));
      }

    }).catchError((onError){
      print(onError);
    });
    return charges;
  }

  getChargesByDriver(String driverName) async {
    List<ChargeModel> charges = new List();
    await chargesDocument.once().then((DataSnapshot snapshot) {
      var chargesIds = snapshot.value.keys;
      var chargesData = snapshot.value;

      for(var chargeId in chargesIds){
        if(chargesData[chargeId]['driver'] == driverName) charges.add(new ChargeModel.fromJson(chargesData[chargeId]));
      }

    }).catchError((onError){
      print(onError);
    });
    return charges;
  }

  editCharge(ChargeModel chargeModel) async {
    await chargesDocument.once().then((DataSnapshot snapshot) {

      var chargesIds = snapshot.value.keys;
      var chargesData = snapshot.value;

      for(var chargeId in chargesIds) {
        if(chargesData[chargeId]['client'] == chargeModel.client && chargesData[chargeId]['quantity'] == chargeModel.quantity && chargesData[chargeId]['date'] == chargeModel.date)
          chargesDocument.child(chargeId).update(chargeModel.toJson());
      }
    }).catchError((onError){
      print(onError);
    });
  }
}