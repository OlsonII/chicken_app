import 'dart:async';

import 'package:chicken_app/src/application/charge_event.dart';
import 'package:chicken_app/src/application/charge_state.dart';
import 'package:chicken_app/src/infraestructure/charge_repository_firebase.dart';
import 'package:chicken_app/src/infraestructure/utils/global_date.dart';

class ChargeBloc{

  //final _chargeProvider = ChargeProvider();
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

  //TODO: OPTIMIZAR
  void _onEvent(ChargeEvent event) async {

    if(event is AddCharge){
      //_chargeOutput.add(ChargesLoading());
      await _chargeProviderFirebase.addCharge(event.charge);
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDate(globalDate.formatDate(globalDate.dateSelected))));
    }else if(event is GetCharges){
      //_chargeOutput.add(ChargesLoading());
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDate(globalDate.formatDate(globalDate.dateSelected))));
    }else if(event is GetChargesByDate){
      //_chargeOutput.add(ChargesLoading());
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDate(event.date)));
    }else if(event is GetChargesByDriver){
      //_chargeOutput.add(ChargesLoading());
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDriver(event.driverName)));
    }else if(event is EditChargeState) {
      //_chargeOutput.add(ChargesLoading());
      await _chargeProviderFirebase.editCharge(event.charge);
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDate(globalDate.formatDate(globalDate.dateSelected))));
    }else if(event is AddDriverToCharge){
      //_chargeOutput.add(ChargesLoading());
      await _chargeProviderFirebase.editCharge(event.charge);
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDate(globalDate.formatDate(globalDate.dateSelected))));
    }else if(event is DeleteCharge){
      //_chargeOutput.add(ChargesLoading());
      await _chargeProviderFirebase.editCharge(event.charge);
      _chargeOutput.add(ChargesLoaded(charges: await _chargeProviderFirebase.getChargesByDate(globalDate.formatDate(globalDate.dateSelected))));
    }
  }
}

final chargeBloc = ChargeBloc();