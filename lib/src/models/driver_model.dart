import 'dart:convert';


DriverModel driverModelFromJson(String str) => DriverModel.fromJson(json.decode(str));

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  String identification;
  String name;
  String licencePlate;
  String phone;
  String state;

  DriverModel({
    this.identification,
    this.name,
    this.licencePlate,
    this.phone,
    this.state,
  });

  factory DriverModel.fromJson(Map<dynamic, dynamic> json) => DriverModel(
    identification: json["identification"],
    name: json["name"],
    licencePlate: json["licence_plate"],
    phone: json["phone"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "identification": identification,
    "name": name,
    "licence_plate": licencePlate,
    "phone": phone,
    "state": state,
  };
}