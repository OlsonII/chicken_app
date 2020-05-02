import 'package:intl/intl.dart';

//TODO: Corregir esta vaina


class GlobalDate {

  DateTime _dateSelected;

  GlobalDate() {
    _dateSelected = DateTime.now();
  }

  DateTime get dateSelected => _dateSelected;

  set dateSelected (DateTime date){
    _dateSelected = date;
  }

  formatDate(DateTime date){
    return  DateFormat('dd/MM/yyyy').format(date).toString();
  }
}

GlobalDate globalDate = new GlobalDate();