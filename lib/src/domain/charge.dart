import 'dart:convert';

Charge chargeModelFromJson(String str) => Charge.fromJson(json.decode(str));

String chargeModelToJson(Charge data) => json.encode(data.toJson());

class Charge {

  String id;
  String date;
  String destination;
  String client;
  int quantity;
  String state;
  double cost;

  Charge({
    this.id,
    this.date,
    this.destination,
    this.client,
    this.quantity,
    this.state,
    this.cost
  });

  factory Charge.fromJson(Map<dynamic, dynamic> json) => Charge(
    id: json["_id"],
    date: json["date"],
    destination: json["destination"],
    client: json["client"],
    quantity: json["quantity"],
    state: json["state"],
    cost: json["cost"]
  );

  Map<String, dynamic> toJson() => {
    "date"        : date,
    "destination" : destination,
    "client"      : client,
    "quantity"    : quantity,
    "state"       : state,
    "cost"        : cost
  };

  get totalCost {
    if(destination == 'Valledupar'){
      return 2400*quantity;
    }
    return 10400*quantity;
  }
}