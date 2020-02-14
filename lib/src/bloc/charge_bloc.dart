import 'dart:async';

import 'package:chicken_app/src/bloc/charge_event.dart';
import 'package:chicken_app/src/bloc/charge_state.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:chicken_app/src/providers/charge_provider_firebase.dart';

class ChargeBloc{

  final _chargeProvider = ChargeProvider();
  final _chargeProviderFirebase = ChargeProviderFirebase();

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
      //_chargeOutput.add(ChargesLoading());
      await _chargeProviderFirebase.addCharge(event.charge);
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getCharges()));
      
    }else if(event is GetCharges){
      //_chargeOutput.add(ChargesLoading());
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getCharges()));
    }else if(event is GetChargesByDate){
      //_chargeOutput.add(ChargesLoading());
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDate(event.date)));
    }else if(event is GetChargesByDriver){
      //_chargeOutput.add(ChargesLoading());
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDriver(event.driverName)));
    }else if(event is EditChargeState) {
      //_chargeOutput.add(ChargesLoading());
      await _chargeProviderFirebase.editCharge(event.charge);
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getCharges()));
    }else if(event is AddDriverToCharge){
      //_chargeOutput.add(ChargesLoading());
      await _chargeProviderFirebase.editCharge(event.charge);
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getCharges()));
    }else if(event is DeleteCharge){
      //_chargeOutput.add(ChargesLoading());
      await _chargeProviderFirebase.editCharge(event.charge);
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getCharges()));
    }
    
  }

}

final chargeBloc = ChargeBloc();