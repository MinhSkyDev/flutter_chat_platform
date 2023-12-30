part of 'chat_bloc.dart';

class ChatEvent {}

class ChatInitialEvent extends ChatEvent {
  List<Message> currentThread;
  int currentIndex;
  ChatInitialEvent({required this.currentThread, required this.currentIndex});
}

class ChatSendMessageEvent extends ChatEvent {
  Message message;
  ChatSendMessageEvent({required this.message});
}

class ChatOnChangeThreadsEvent extends ChatEvent {
  List<Message> newThread;
  int newIndex;
  ChatOnChangeThreadsEvent({required this.newThread, required this.newIndex});
}
