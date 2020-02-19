import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:chicken_app/src/bloc/charge_bloc.dart';
import 'package:chicken_app/src/bloc/charge_event.dart';
import 'package:chicken_app/src/bloc/charge_state.dart';
import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/pages/charges_page.dart';
import 'package:chicken_app/src/pages/drivers_page.dart';
import 'package:chicken_app/src/utils/globals_keys.dart';
import 'package:chicken_app/src/utils/globals_variables.dart';
import 'package:chicken_app/src/utils/register_charge_form.dart';
import 'package:chicken_app/src/utils/register_driver_form.dart';
import 'package:chicken_app/src/utils/register_due_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool showContainer = true;
  int _selectedIndex = 0;
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  int chickensSends = 0;
  DateTime dateSelected = DateTime.now();

  final todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
  final yesterdayDate = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: -1))).toString();


  List<Widget> _pages = [
    ChargesPage(),
    DriversPage(),
    Container(),
    Container()
  ];



  @override
  void initState() {
    showContainer = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    chargeBloc.dispose();
    driverBloc.dispose();
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
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(254, 206, 46,  1),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black87,),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _buildPrincipalInformation(),
            _buildSelectedForm(),
            _buildPrincipalContainer()
          ],
        ),
        bottomNavigationBar: bottomNavigationBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: showContainer ? Icon(Icons.add, color: Colors.blueGrey) : Icon(Icons.arrow_upward, color: Colors.blueGrey),
      onPressed: () {
        setState(() {
          showContainer ? showContainer = false : showContainer = true;
        });
      },
      backgroundColor: Color.fromRGBO(254, 206, 46,  1),
    );
  }

  Widget _buildPrincipalContainer() {
    return AnimatedPositioned(
      top: showContainer ? _screenHeight*0.17 : _screenHeight*0.85,
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
        child: showContainer ? _pages[_selectedIndex] : Container(),
      ),
    );
  }

  Widget _buildSelectedForm() {
    switch(_selectedIndex){
      case 0:
        return ChargeForm();
        break;
      case 1:
        return DriverForm();
        break;
      case 2:
        return DueForm();
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
          for(ChargeModel charge in charges){
            if(charge.state == 'Enviado'){
              chickensSends += charge.quantity;
              print(chickensSends);
            }
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
                  child: Text('Cantidad de pollos enviados:', style: TextStyle(color: Colors.black, fontSize: 20),),
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

  Widget bottomNavigationBar(){

    return BubbleBottomBar(
        opacity: .2,
        currentIndex: _selectedIndex,
        onTap: _changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 5.0,
        fabLocation: BubbleBottomBarFabLocation.end, //new
        hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        backgroundColor: Colors.white,
        items: bottomNavigationBarItems()
    );
  }

  bottomNavigationBarItems(){
    return <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          backgroundColor: Colors.red,
          icon: Icon(AntDesign.inbox, color: Colors.blueGrey),
          activeIcon: Icon(AntDesign.inbox, color: Colors.red,),
          title: Text("Encargos")
      ),
      BubbleBottomBarItem(
          backgroundColor: Colors.blue,
          icon: Icon(FontAwesome.truck, color: Colors.blueGrey),
          activeIcon: Icon(FontAwesome.truck, color: Colors.blue),
          title: Text("Conductores")
      ),
      BubbleBottomBarItem(
          backgroundColor: Colors.pink,
          icon: Icon(Icons.account_balance_wallet, color: Colors.blueGrey),
          activeIcon: Icon(Icons.account_balance_wallet, color: Colors.pink),
          title: Text("Deudores")
      ),
    ];
  }
  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _buildDateTimePicker() {
    return GestureDetector(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('${_formatDate(dateSelected)}', style: TextStyle(fontSize: 20.0),),
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
              chargeBloc.sendChargeEvent.add(GetChargesByDate(date: _formatDate(date)));
              globalsVariables.dateSelected = date;
              dateSelected = date;
            });
          }
        });
      },
    );
  }

  _formatDate(DateTime date){
    return  DateFormat('dd/MM/yyyy').format(date).toString();
  }
}
