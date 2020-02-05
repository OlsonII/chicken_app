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

  final List<ChargeModel> drivers = new List();

  List<Object> get props => [drivers];
}

class GetChargesByDate extends ChargeEvent {

  final String date;

  const GetChargesByDate({@required this.date}) : assert(date != null);

  @override
  List<Object> get props => [new ChargeProvider().getChargesByDate(this.date)];

}

class EditChargeState extends ChargeEvent {

  final ChargeModel charge;

  const EditChargeState({@required this.charge}) : assert(charge != null);

  @override
  List<Object> get props => [charge];

}