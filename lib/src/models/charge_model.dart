import 'dart:convert';

ChargeModel chargeModelFromJson(String str) => ChargeModel.fromJson(json.decode(str));

String chargeModelToJson(ChargeModel data) => json.encode(data.toJson());

class ChargeModel {

  String id;
  String date;
  String destination;
  String driver;
  String client;
  int quantity;
  String state;

  ChargeModel({
    this.id,
    this.date,
    this.destination,
    this.driver,
    this.client,
    this.quantity,
    this.state,
  });

  factory ChargeModel.fromJson(Map<String, dynamic> json) => ChargeModel(
    id: json["_id"],
    date: json["date"],
    destination: json["destination"],
    driver: json["driver"],
    client: json["client"],
    quantity: json["quantity"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "destination": destination,
    "driver": driver,
    "client": client,
    "quantity": quantity,
    "state": state,
  };
}