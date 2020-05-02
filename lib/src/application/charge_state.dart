import 'package:chicken_app/src/domain/charge.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChargeState {}

class ChargesEmpty extends ChargeState {
  final List<Charge> charges = [];

  List<Object> get props => [charges];
}

class ChargesLoading extends ChargeState {

}

class ChargesLoaded extends ChargeState {

  final List<Charge> charges;

  ChargesLoaded({@required this.charges}) : assert(charges != null);

  List<Object> get props => [charges];
}

class ChargesError extends ChargeState {}