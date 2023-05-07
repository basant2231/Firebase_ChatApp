import 'dart:io';

import 'package:chatapp/Core/Constants.dart';
import 'package:chatapp/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      emit(UserCreatedLoadingState());
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user?.uid != null) {
        debugPrint(
            'User created successfully with uid: ${userCredential.user?.uid}');
        String imgurl = await uploadImageToStorage();
        await sendUserDataToFireStore(
            email: email,
            password: password,
            userId: userCredential.user!.uid,
            name: name,
            url: imgurl);
        debugPrint('img url is ${imgurl}');
        emit(UserCreatedSuccessState());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed to register and the reason is ${e.code}');
      if (e.code == 'email_already_in_use') {
        emit(UserCreatedFailedState(message: 'Email already used'));
      }
    }
  }

/******************************************************************************/
  File? userImgFile;

  void getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      userImgFile = File(pickedImage.path);

      emit(UserImageSelectedSuccessState());
    } else {
      emit(UserImageSelectedFailedState());
    }
  }

/******************************************************************************/
  Future<String> uploadImageToStorage() async {
    // This function returns a Future<String> which will resolve to the download URL of the uploaded image.

    // Print the path and basename of the file to upload (for debugging purposes)
    debugPrint('file is $userImgFile');
    debugPrint('base name for file ${basename(userImgFile!.path)}');

    // Determine the reference where the image will be uploaded to
    Reference imageref =
        await FirebaseStorage.instance.ref(basename(userImgFile!.path));

    // Upload the file to the determined reference
    await imageref.putFile(userImgFile!);

    // Return the download URL of the uploaded image
    return await imageref.getDownloadURL();
  }

/******************************************************************************/
  Future<void> sendUserDataToFireStore(
      {required String email,
      required String password,
      required String userId,
      required String name,
      required String url,
     }) async {
        UserModel userModel=UserModel(id: userId, name: name, email: email, imageUrl: url);
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).set(
         userModel.toJson());
      emit(SuccessToSaveUserDataOnFireStoreState());
    } on FirebaseException catch (e) {
      emit(FailedToSaveUserDataOnFireStoreState());
      print(e);
    }
  }

  /******************************************************************************/
  void login({required String email, required String password}) async {
    try {
      emit(LoginLoadingState());
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.uid != null) {
        //save id into cache throught cache prefrences
        final sharedpref = await SharedPreferences.getInstance();
        await sharedpref.setString("User ID", userCredential.user!.uid);
        Constants.UserId = sharedpref.getString("User ID");
        emit(LoginSuccessState());
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      emit(LoginFailedState());
    }
  }
}
