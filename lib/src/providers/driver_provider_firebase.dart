import 'package:chicken_app/src/models/driver_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DriverProviderFirebase {

  DriverProviderFirebase(){
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    driversDocument.keepSynced(true);
  }


  static final db = FirebaseDatabase.instance.reference();
  static final driversDocument = db.child('drivers');

  addDriver(DriverModel driverModel){
    driversDocument.child('${driverModel.identification}').set(driverModel.toJson());
  }

  getDrivers() async {
    List<DriverModel> drivers = new List();
    await driversDocument.once().then((DataSnapshot snapshot) {
      var identifications = snapshot.value.keys;
      var driversData = snapshot.value;      

      for(var identification in identifications){
        drivers.add(new DriverModel.fromJson(driversData[identification]));
      }

    }).catchError((onError){
      print(onError);
    });
    return drivers;
  }

  getDriversByState(String state) async{
    List<DriverModel> drivers = new List();
    await driversDocument.once().then((DataSnapshot snapshot) {

      var identifications = snapshot.value.keys;
      var driversData = snapshot.value;

      for(var identification in identifications){
        if(driversData[identification]['state'] == state) drivers.add(new DriverModel.fromJson(driversData[identification]));
      }
    });
    return drivers;
  }

  getSpecifyDriver(String driverIdentification) async{
    List<DriverModel> drivers = new List();
    await driversDocument.child(driverIdentification).once().then((DataSnapshot snapshot){
      var driversData = snapshot.value;
      drivers.add(new DriverModel.fromJson(driversData));
    }).catchError((onError){
      print(onError);
    });
    return drivers;
  }

  getSpecifyDriverByName(String driverIdentification) async{
    List<DriverModel> drivers = new List();
    await driversDocument.child(driverIdentification).once().then((DataSnapshot snapshot){
      var driversData = snapshot.value;
      drivers.add(new DriverModel.fromJson(driversData));
    }).catchError((onError){
      print(onError);
    });
    return drivers;
  }

  editDriver(DriverModel driverModel) async {
    await driversDocument.child(driverModel.identification).update(driverModel.toJson());
  }
}