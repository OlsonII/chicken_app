import 'dart:async';

import 'package:chicken_app/src/bloc/charge_event.dart';
import 'package:chicken_app/src/bloc/charge_state.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';

class ChargeBloc{

  final _chargeProvider = ChargeProvider();

  StreamController<ChargeEvent> _chargeInput = StreamController();
  StreamController<ChargeState> _chargeOutput = StreamController.broadcast();

  Stream<ChargeState> get chargeStream => _chargeOutput.stream;
  StreamSink<ChargeEvent> get sendChargeEvent => _chargeInput.sink;

  ChargeBloc(){
    _chargeInput.stream.listen(_onEvent);
  }

  void dispose() {
    _chargeInput.close();
    _chargeOutput.close();
  }

  void _onEvent(ChargeEvent event) async {

    if(event is AddCharge){
      _chargeOutput.add(ChargesLoading());
      await _chargeProvider.addCharge(event.charge);
    }else if(event is GetCharges){
      _chargeOutput.add(ChargesLoading());
    }else if(event is EditChargeState) {
      _chargeOutput.add(ChargesLoading());
      await _chargeProvider.editChargeState(event.charge);
    }else if(event is AddDriverToCharge){
      _chargeOutput.add(ChargesLoading());
      await _chargeProvider.addDriverToCharge(event.charge);
    }
    _chargeOutput.add(ChargesLoaded(charges: await _chargeProvider.getCharges()));
  }

}

final chargeBloc = ChargeBloc();