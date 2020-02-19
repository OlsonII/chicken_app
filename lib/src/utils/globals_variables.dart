

class GlobalsVariables {

  DateTime _dateSelected;

  GlobalsVariables() {
    _dateSelected = DateTime.now();
  }

  DateTime get dateSelected => _dateSelected;

  set dateSelected (DateTime date){
    _dateSelected = date;
  }
}

GlobalsVariables globalsVariables = new GlobalsVariables();