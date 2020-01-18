import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:rxdart/rxdart.dart';

class ChargeBloc {

  final _chargeRProvider = ChargeProvider();
  final _chargeController = PublishSubject<List<ChargeModel>>();

  Stream<List<ChargeModel>> get allCharges => _chargeController.stream;


  getAllCharges() async {
    //final charges = await _chargeRProvider.getCharges();
    //_chargeController.sink.add(charges);
  }

  dispose(){
    _chargeController.close();
  }

}

final chargeBloc = ChargeBloc();


