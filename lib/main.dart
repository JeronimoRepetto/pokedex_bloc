import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_bloc/ui/screens/detail.dart';
import 'package:pokedex_bloc/ui/screens/home.dart';

import 'bloc/session_bloc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SessionBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokédex',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomeScreen(),
          'detail': (_) =>const DetailScreen()
        },
      ),
    );
  }
}
