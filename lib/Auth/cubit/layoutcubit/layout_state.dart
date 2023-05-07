part of 'layout_cubit.dart';

@immutable
abstract class LayoutState {}

class LayoutInitial extends LayoutState {}
class GetMyDataSuccessState extends LayoutState {}
class GetMyDataFailedState extends LayoutState {}
/******************************************************************** */
class GetUsersDataSuccessState extends LayoutState {}
class GetUsersDataFailedState extends LayoutState {}
class GetUsersDataLoadingState extends LayoutState {}
/******************************************************************** */
class FilteredUsersSuccessState extends LayoutState {}
class ChangeSearchStatusSuccessState extends LayoutState {}
/******************************************************************** */
class SendMessageSuccesfullyState extends LayoutState {}
/******************************************************************** */
class GetMessagesSuccessState extends LayoutState {}
class GetMessagesFailedState extends LayoutState {}
class GetMessagesLoadingState extends LayoutState {}