part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatSendMessageState extends ChatState {}

class ChatRecievedMessageState extends ChatState {}

class ChatStableMesssageState extends ChatState {}
