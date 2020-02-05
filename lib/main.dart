import 'package:chicken_app/src/app.dart';
import 'package:chicken_app/src/bloc/charge_bloc.dart';
import 'package:chicken_app/src/bloc/driver_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
      BlocProvider<DriverBloc>(
        create: (_) => DriverBloc(),
        child: BlocProvider<ChargeBloc>(
            create: (_) => ChargeBloc(),
            child: App(),
        )
      )
  );
}

