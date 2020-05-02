import 'package:chicken_app/src/application/charge_bloc.dart';
import 'package:chicken_app/src/application/charge_event.dart';
import 'package:chicken_app/src/application/charge_state.dart';
import 'package:chicken_app/src/domain/charge.dart';
import 'package:chicken_app/src/presentation/charges_page.dart';
import 'package:chicken_app/src/infraestructure/utils/globals_keys.dart';
import 'package:chicken_app/src/infraestructure/utils/global_date.dart';
import 'package:chicken_app/src/presentation/forms/register_charge_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  bool showContainer = true;
  int _selectedIndex = 0;
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  int chickensSends = 0;
  DateTime dateSelected = DateTime.now();
  AnimationController _buttonMenuAnimationController;
  Duration _animationDuration = Duration(milliseconds: 400);

  final todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();


  @override
  void initState() {
    showContainer = true;
    _buttonMenuAnimationController = AnimationController(duration: _animationDuration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    chargeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    _screenWidth = _screenSize.width;
    _screenHeight = _screenSize.height;
    chickensSends = 0;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return SafeArea(
      child: Scaffold(
        key: globalsKeys.scaffoldKey,
        body: Stack(
          children: <Widget>[
            _buildPrincipalInformation(),
            _buildSelectedForm(),
            _buildPrincipalContainer()
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: FloatingActionButton(
        child: AnimatedIcon(
          icon: AnimatedIcons.home_menu,
          progress: _buttonMenuAnimationController,
          color: Colors.black87,
          size: 27.0,
        ),
        onPressed: () {
          setState(() {
            showContainer ? showContainer = false : showContainer = true;
            showContainer ? _buttonMenuAnimationController.forward() : _buttonMenuAnimationController.reverse();
          });
        },
        backgroundColor: Color.fromRGBO(254, 206, 46,  1),
      ),
    );
  }

  Widget _buildPrincipalContainer() {
    return AnimatedPositioned(
      top: showContainer ? _screenHeight*0.2 : _screenHeight*0.85,
      bottom: -100,
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      child: Container(
        height: _screenHeight,
        width: _screenWidth*0.999,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            color: Colors.white
        ),
        child: showContainer ? ChargesPage() : Container(),
      ),
    );
  }

  Widget _buildSelectedForm() {
    switch(_selectedIndex){
      case 0:
        return ChargeForm();
        break;
    }
    return Container();
  }

  _buildPrincipalInformation() {

    return StreamBuilder(
      stream: chargeBloc.chargeStream,
      builder: (context, snapshot) {
        if(snapshot.data is ChargesLoaded){
          final charges = snapshot.data.charges;
          if(chickensSends > 0) chickensSends = 0;
          for(Charge charge in charges){
            chickensSends += charge.quantity;
          }
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(254, 206, 46,  1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDateTimePicker(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 30),
                  child: Text('Cantidad de cajas recibidas:', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 30),
                  child: Text('$chickensSends', style: TextStyle(color: Colors.black, fontSize: 40),),
                )
              ],
            ),
          );
        }else{
          return Container();
        }
      }
    );
  }

  _buildDateTimePicker() {
    return GestureDetector(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('${globalDate.formatDate(dateSelected)}', style: TextStyle(fontSize: 20.0),),
        ),
      ),
      onTap: (){
        showDatePicker(
            context: globalsKeys.scaffoldKey.currentContext,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 3),
            lastDate: DateTime(DateTime.now().year + 1)
        ).then((date){
          if(date != null){
            setState(() {
              chargeBloc.sendChargeEvent.add(GetChargesByDate(date: globalDate.formatDate(date)));
              globalDate.dateSelected = date;
              dateSelected = date;
            });
          }
        });
      },
    );
  }

}
