import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_platform/model/message.dart';
import 'package:chat_platform/util/gpt_call.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late List<Message> currentThreads;
  late int currentThreadsIndex;

  ChatBloc() : super(ChatInitial()) {
    on<ChatInitialEvent>((event, emit) {
      ChatInitialEventHandler(event, emit);
    });

    on<ChatSendMessageEvent>((event, emit) async {
      await ChatSendMessageEventHandler(event, emit);
    });

    on<ChatOnChangeThreadsEvent>((event, emit) async {
      await ChatOnChangeThreadsEventHandler(event, emit);
    });
  }

  FutureOr<void> ChatInitialEventHandler(event, emit) async {
    emit(ChatInitial());
    ChatInitialEvent eventModel = event as ChatInitialEvent;
    currentThreads = eventModel.currentThread;
    currentThreadsIndex = eventModel.currentIndex;
    emit(ChatStableMesssageState());
  }

  FutureOr<void> ChatSendMessageEventHandler(event, emit) async {
    ChatSendMessageEvent eventModel = event as ChatSendMessageEvent;
    currentThreads.add(eventModel.message);

    GPTCaller gptCaller = GPTCaller();

    Map<String, dynamic> request =
        gptCaller.createRequestDataFromMessageList(currentThreads);

    emit(ChatSendMessageState());
    String messageResponse = await gptCaller.callOpenAIToGetMessage(request);

    Message gptResponseMessage =
        Message(role: "assistant", content: messageResponse);
    currentThreads.add(gptResponseMessage);

    emit(ChatStableMesssageState());
  }

  FutureOr<void> ChatOnChangeThreadsEventHandler(event, emit) async {
    ChatOnChangeThreadsEvent eventModel = event as ChatOnChangeThreadsEvent;
    currentThreads = eventModel.newThread;
    currentThreadsIndex = eventModel.newIndex;
    emit(ChatStableMesssageState());
  }
}
