import 'package:chatapp/Auth/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth/cubit/layoutcubit/layout_cubit.dart';
import 'Auth/login_screen.dart';
import 'Auth/register_screen.dart';
import 'Core/Constants.dart';

Future<void> main() async {
  // 1 Initialization of Firebase to use it in the application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedpref = await SharedPreferences.getInstance();
  Constants.UserId=sharedpref.getString("User ID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider( 
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => LayoutCubit()..getMyData(),) 
      ],
      child: MaterialApp(theme:ThemeData(primarySwatch: Colors.purple) ,
        home:LoginScreen(),
      ),
    );
  }
}
