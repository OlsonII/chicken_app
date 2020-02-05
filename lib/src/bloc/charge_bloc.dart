import 'package:chicken_app/src/bloc/charge_event.dart';
import 'package:chicken_app/src/bloc/charge_state.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:bloc/bloc.dart';

/*class ChargeBloc {

  final _chargeRProvider = ChargeProvider();
  final _chargeController = PublishSubject<List<ChargeModel>>();

  Stream<List<ChargeModel>> get allCharges => _chargeController.stream;


  getAllCharges() async {
    final charges = await _chargeRProvider.getCharges();
    _chargeController.sink.add(charges);
  }

  dispose(){
    _chargeController.close();
  }

}

final chargeBloc = ChargeBloc();*/

class ChargeBloc extends Bloc<ChargeEvent, ChargeState> {

  ChargeBloc();

  final _chargeProvider = ChargeProvider();

  @override
  ChargeState get initialState => ChargesEmpty();

  @override
  Stream<ChargeState> mapEventToState(ChargeEvent event) async* {

    if(event is AddCharge){

      yield ChargesLoading();
      await _chargeProvider.addCharge(event.charge);
      yield ChargesLoaded(charges: await _chargeProvider.getCharges());

    }else if(event is GetCharges){

      yield ChargesLoading();
      final charges = await _chargeProvider.getCharges();
      yield ChargesLoaded(charges: charges);

    }

  }

}