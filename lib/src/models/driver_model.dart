import 'dart:convert';

import 'charge_model.dart';

DriverModel driverModelFromJson(String str) => DriverModel.fromJson(json.decode(str));

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  
  String identification;
  String firstname;
  String lastname;
  String state = 'inactivo';
  List<ChargeModel> charge;

  DriverModel({
    this.identification,
    this.firstname,
    this.lastname,
    this.state,
    this.charge,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
    identification: json["identification"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    state: json["state"],
    charge: List<ChargeModel>.from(json["charge"].map((x) => ChargeModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "identification": identification,
    "firstname": firstname,
    "lastname": lastname,
    "state": state,
    "charge": List<dynamic>.from(charge.map((x) => x.toJson())),
  };
}