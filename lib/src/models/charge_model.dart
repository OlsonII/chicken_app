import 'dart:convert';

class ChargeModel {
  String date;
  String destination;
  String client;
  int quantity;
  bool state;

  ChargeModel({
    this.date,
    this.destination,
    this.client,
    this.quantity,
    this.state,
  });

  factory ChargeModel.fromJson(Map<String, dynamic> json) => ChargeModel(
    date: json["date"],
    destination: json["destination"],
    client: json["client"],
    quantity: json["quantity"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "destination": destination,
    "client": client,
    "quantity": quantity,
    "state": state,
  };
}