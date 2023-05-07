import 'package:chatapp/Auth/cubit/layoutcubit/layout_cubit.dart';
import 'package:chatapp/UI/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layoutCubit = BlocProvider.of<LayoutCubit>(context)
      ..getMyData()
      ..getUsers();
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(actions: [
              IconButton(onPressed: (){
                layoutCubit.changeSearchStatus();
              }, icon: Icon(layoutCubit.searchenabled?Icons.clear:Icons.search)),
            ],
              title: layoutCubit.searchenabled
                  ? TextFormField(style: TextStyle(color: Colors.white),onChanged: (value) {
                    layoutCubit.searchAboutUsers(query: value);
                  },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search about User',
                          hintStyle: TextStyle(color: Colors.white)),
                    )
                  : GestureDetector(
                      child: Text('ChatApp'),
                      onTap: () {
                        scaffoldKey.currentState!.openDrawer();
                      },
                    ),
              automaticallyImplyLeading: false,
            ),
            key: scaffoldKey,
            drawer: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(layoutCubit.userModel?.name ?? ''),
                    accountEmail: Text(layoutCubit.userModel?.email ?? ''),
                    currentAccountPicture: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          NetworkImage(layoutCubit.userModel?.imageUrl ?? ""),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text("log out"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: state is GetUsersDataLoadingState
                ? Center(child: CircularProgressIndicator())
                : layoutCubit.users.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 12,
                            );
                          },
                          itemCount: layoutCubit.usersfiltered.isEmpty?layoutCubit.users.length:layoutCubit.usersfiltered.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return ChatScreen(usermodel:layoutCubit.usersfiltered.isEmpty? layoutCubit.users[index]:layoutCubit.usersfiltered[index]);
                              },));
                            },
                              contentPadding: EdgeInsets.zero,
                              title: Text((layoutCubit.usersfiltered.isEmpty?layoutCubit.users[index].name!:layoutCubit.usersfiltered[index].name!)),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    layoutCubit.usersfiltered.isEmpty?layoutCubit.users[index].imageUrl!:layoutCubit.usersfiltered[index].imageUrl!),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(child: Text('there is no users yet')));
      },
    );
  }
}
