import 'package:chatapp/UI/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final emailConroller = TextEditingController();
  final passwordConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if(state is LoginSuccessState){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
        }else if(state is LoginFailedState){

        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailConroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordConroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                ),
                SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    if (emailConroller.text.isNotEmpty &&
                        passwordConroller.text.isNotEmpty) {
                      BlocProvider.of<AuthCubit>(context).login(
                          email: emailConroller.text,
                          password: passwordConroller.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                              'please fill the Textformfield and try again')));
                    }
                  },
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  child: Text(state is LoginLoadingState?'processing........':'Login'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
