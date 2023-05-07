import 'package:chatapp/Auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/auth_cubit.dart';

// i want to upload the photo to the firestorage
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final emailConroller = TextEditingController();
  final passwordConroller = TextEditingController();
  final nameConroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UserCreatedFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message.toString())));
          } else if (state is UserCreatedSuccessState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocProvider.of<AuthCubit>(context).userImgFile != null
                    ? Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: FileImage(
                                  BlocProvider.of<AuthCubit>(context)
                                      .userImgFile!),
                            ),
                            SizedBox(
                              height: 7.5,
                            ),
                            GestureDetector(
                              child: Text(
                                'Change Photo',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              onTap: () {
                                BlocProvider.of<AuthCubit>(context)
                                    .getImage();
                              },
                            )
                          ],
                        ),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          BlocProvider.of<AuthCubit>(context).getImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.green,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Select a photo')
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailConroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameConroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Name'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordConroller,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    if (emailConroller.text.isNotEmpty &&
                        passwordConroller.text.isNotEmpty) {
                      BlocProvider.of<AuthCubit>(context).register(
                        name: nameConroller.text,
                        email: emailConroller.text,
                        password: passwordConroller.text,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                              'please fill the Textformfield and try again')));
                    }
                  },
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  child: Text(state is UserCreatedLoadingState?'Processing...':'Sign up'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
//firebase storage picture video 
//firebase firestore data