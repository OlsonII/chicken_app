
import 'package:chicken_app/src/domain/charge.dart';
import 'package:chicken_app/src/infraestructure/i_charge_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class ChargeProviderFirebase implements IChargeProvider {

  ChargeProviderFirebase(){
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    chargesDocument.keepSynced(true);
  }

  static final db = FirebaseDatabase.instance.reference();
  static final chargesDocument = db.child('charges');


  addCharge(Charge chargeModel){
    chargesDocument.push().set(chargeModel.toJson());
  }

  getCharges() async {
    List<Charge> charges = new List();
    await chargesDocument.orderByValue().once().then((DataSnapshot snapshot) {
      var chargesIds = snapshot.value.keys;
      var chargesData = snapshot.value;

      for(var chargeId in chargesIds){
        charges.add(new Charge.fromJson(chargesData[chargeId]));
      }

    }).catchError((onError){
      print(onError);
    });
    return charges;
  }

  getChargesByDate(String date) async {
    List<Charge> charges = new List();
    await chargesDocument.once().then((DataSnapshot snapshot) {
      var chargesIds = snapshot.value.keys;
      var chargesData = snapshot.value;

      for(var chargeId in chargesIds){
        if(chargesData[chargeId]['date'] == date) charges.add(new Charge.fromJson(chargesData[chargeId]));
      }

    }).catchError((onError){
      print(onError);
    });
    return charges;
  }

  getChargesByState(String state){}

  getChargesByDriver(String driverName) async {
    List<Charge> charges = new List();
    await chargesDocument.once().then((DataSnapshot snapshot) {
      var chargesIds = snapshot.value.keys;
      var chargesData = snapshot.value;

      for(var chargeId in chargesIds){
        if(chargesData[chargeId]['driver'] == driverName) charges.add(new Charge.fromJson(chargesData[chargeId]));
      }

    }).catchError((onError){
      print(onError);
    });
    return charges;
  }

  editCharge(Charge chargeModel) async {
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