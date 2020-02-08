import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:chicken_app/src/bloc/driver_event.dart';
import 'package:chicken_app/src/bloc/driver_state.dart';
import 'package:chicken_app/src/models/charge_model.dart';
import 'package:chicken_app/src/models/driver_model.dart';
import 'package:chicken_app/src/providers/charge_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverProfilePage extends StatelessWidget {
  
  final chargeProvider = new ChargeProvider();



  @override
  Widget build(BuildContext context) {

    final driverName = ModalRoute.of(context).settings.arguments;

    driverBloc.sendDriverEvent.add(GetSpecifyDriver(driver: new DriverModel(identification: driverName)));

    return StreamBuilder(
      stream: driverBloc.driverStream,
        builder: (context, state) {
          if(state.data is DriverLoaded) {
            final driverModel = state.data.driver;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(254, 206, 46,  1),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black87,),
                    onPressed: () => Navigator.pop(context)
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.edit, color: Colors.black87)
                  )
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Center(child: Text(driverModel.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                  Row(
                    children: <Widget>[
                      Expanded(child: Container()),
                      Text(driverModel.licencePlate, style: TextStyle(fontSize: 17)),
                      Text(' | ', style: TextStyle(color: Colors.red),),
                      Text(driverModel.state, style: TextStyle(fontSize: 17, color: driverModel.state == 'Activo' ? Colors.green : Colors.red)),
                      Expanded(child: Container())
                    ],
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text('INFORMACION'),
                        Expanded(child: Container(),),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text('CEDULA: '),
                        Text(driverModel.identification),
                        Expanded(child: Container(),),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text('TELEFONO: '),
                        Text(driverModel.phone),
                        Expanded(child: Container(),),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text('ESTADISTICAS DE ENCARGOS'),
                        Expanded(child: Container(),)
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text('ENCARGOS EN PROGRESO'),
                        Expanded(child: Container(),),
                        Text('VER TODO')
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Container(
                      child: FutureBuilder(
                        future: chargeProvider.getChargesByDriver(driverModel.name),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.data == null) return Text('Este conductor no tiene encargos');
                          if(snapshot.hasData){
                            final charges = snapshot.data;
                            return ListView.builder(
                                itemCount: charges.length,
                                itemBuilder: (context, i) => _createItem(context, charges[i])
                            );
                            return Container();
                          }else{
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){},
              ),
            );
          }
          return Container();
        },
    );
  }

  _createItem(BuildContext context, ChargeModel charge) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
      child: GestureDetector(
        child: ListTile(
          title: Text(charge.destination + ' - ' + charge.client, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          subtitle: Text('Cantidad de cajas: ${charge.quantity}', style: TextStyle(fontSize: 15),),
          leading: _chooseAvatar(charge.state)
        ),
        onTap: () => _showAlert(context, charge),
      ),
    );
  }

  _chooseAvatar(String state){
    Color color;
    Icon icon;
    switch(state){
      case 'Enviado':
        color =  Color.fromRGBO(254, 206, 46,  1);
        icon = Icon(Icons.flight_takeoff, color: Colors.blue);
        break;
      case 'Entregado':
        color = Colors.green;
        icon = Icon(Icons.flight_land, color: Colors.white);
        break;
    }
    return CircleAvatar(
      child: icon,
      backgroundColor: color,
    );
  }

  _showAlert(BuildContext context, ChargeModel chargeModel){
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('DESTINO: ${chargeModel.destination}'),
            Text('CLIENTE: ${chargeModel.client}'),
            Text('CONDUCTOR: ${chargeModel.driver}'),
            Text('CANTIDAD: ${chargeModel.quantity}'),
            Text('ESTADO: ${chargeModel.state}')
          ],
        ),
        btnOkOnPress: (){}
    ).show();
  }
}
