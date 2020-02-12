import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


abstract class ChargeEvent extends Equatable {
  const ChargeEvent();
}

class AddCharge extends ChargeEvent {

  final ChargeModel charge;

  const AddCharge({@required this.charge}) : assert(charge != null);

  List<Object> get props => [charge];
}

class GetCharges extends ChargeEvent {

  final List<ChargeModel> charges = new List();

  List<Object> get props => [charges];
}

class GetChargesByDate extends ChargeEvent {

  final String date;

  const GetChargesByDate({@required this.date}) : assert(date != null);

  @override
  List<Object> get props => [date];

}

class GetChargesByDriver extends ChargeEvent {

  final String driverName;

  const GetChargesByDriver({@required this.driverName}) : assert(driverName != null);

  @override
  List<Object> get props => [driverName];

}

class EditChargeState extends ChargeEvent {

  final ChargeModel charge;

  const EditChargeState({@required this.charge}) : assert(charge != null);

  @override
  List<Object> get props => [charge];

}

class AddDriverToCharge extends ChargeEvent {

  final ChargeModel charge;

  const AddDriverToCharge({@required this.charge}) : assert(charge != null);

  @override
  List<Object> get props => [charge];

}