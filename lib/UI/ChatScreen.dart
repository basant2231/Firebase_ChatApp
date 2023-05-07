import 'package:chatapp/Auth/cubit/layoutcubit/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/UserModel.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    Key? key,
    required this.usermodel,
  }) : super(key: key);
  final UserModel usermodel;
  final messagecontroller = TextEditingController();
//i need the data about the user i want to chat with
  @override
  Widget build(BuildContext context) {
    //take care is it 1 or 2 dotes
    final cubit = BlocProvider.of<LayoutCubit>(context)
      ..getmessages(recieverID: usermodel.id!);
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        if (state is SendMessageSuccesfullyState) {
          messagecontroller.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(usermodel.name!),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Expanded(
                    child: state is GetMessagesLoadingState
                        ? Center(child: CircularProgressIndicator())
                        : cubit.messages.isNotEmpty
                            ? ListView.builder(
                                itemCount: cubit.messages.length,
                                itemBuilder: (context, index) {
                                  return Container(color: Colors.purple[200],
                                  margin: EdgeInsets.only(bottom: 15),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                    child: Text(cubit.messages[index].content!),
                                  );
                                },
                              )
                            : Center(
                                child: Text('No messages yet'),
                              )),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: messagecontroller,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            cubit.sendMessage(
                                message: messagecontroller.text,
                                recieverID: usermodel.id!);
                            //search message to firestore
                          },
                          icon: Icon(Icons.send)),
                      border: OutlineInputBorder()),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
