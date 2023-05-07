import 'package:bloc/bloc.dart';
import 'package:chatapp/Core/Constants.dart';
import 'package:chatapp/models/messagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../models/UserModel.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());
  UserModel? userModel;

  Future<void> getMyData() async {
    try {
      print(Constants.UserId);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(Constants.UserId)
          .get()
          .then((value) {
        userModel = UserModel.fromJson(data: value.data()!);
      });
      emit(GetMyDataSuccessState());
    } on FirebaseException catch (e) {
      print(e);

      emit(GetMyDataFailedState());
    }
  }
/******************************************************************** */

  List<UserModel> users = [];
  void getUsers() async {
    try {
      users.clear();
      emit(GetUsersDataLoadingState());
      await FirebaseFirestore.instance.collection("Users").get().then((value) {
        for (var item in value.docs) {
          if (item.id != Constants.UserId) {
            users.add(UserModel.fromJson(data: item.data()));
            // 1 items.data to access the fields
            // 2 fromjson so it will turn to a class
            // 3 Usermodel because it is a Usermodel "logic"
            // 4 i want it to be in the list
          }
        }
        emit(GetUsersDataSuccessState());
      });
    } on FirebaseException catch (e) {
      print(e);
      users = [];
      emit(GetUsersDataFailedState());
    }
  }
/******************************************************************** */

  List<UserModel> usersfiltered = [];
  void searchAboutUsers({required String query}) {
    usersfiltered = users
        .where((element) =>
            element.name!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    emit(FilteredUsersSuccessState());
  }
/******************************************************************** */

  bool searchenabled = false;
  void changeSearchStatus() {
    if (searchenabled == false) usersfiltered.clear();
    searchenabled = !searchenabled;
    emit(ChangeSearchStatusSuccessState());
  }

/******************************************************************** */
  void sendMessage(
      {required String message, required String recieverID}) async {
    MessageModel messageModel = await MessageModel(
        content: message,
        date: DateTime.now().toString(),
        senderID: Constants.UserId);
    //save data on my documents
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(Constants.UserId) //switch
        .collection('Chat')
        .doc(recieverID)
        .collection("Messages")
        .add(messageModel.toJson());
    print("Messages sent successfully");
    //save data in reciever documents
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recieverID)
        .collection('Chat')
        .doc(Constants.UserId)
        .collection("Messages")
        .add(messageModel.toJson());
    emit(SendMessageSuccesfullyState());
  }
/******************************************************************** */
List<MessageModel>messages=[];
 getmessages({ required String recieverID}){
 
  emit(GetMessagesLoadingState());
  //بشكل لحظي then take time
  //mybe this is realtime database
  FirebaseFirestore.instance.collection('Users').doc(Constants.UserId).collection('Chat').doc(recieverID).collection("Messages").orderBy('date').snapshots().listen((event) {
    messages.clear();
    for(var item in event.docs){
      //i loop throught all messages
messages.add(MessageModel.fromJson(data: item.data()));
    }
    emit(GetMessagesSuccessState());
  });
}
}
