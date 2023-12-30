import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_platform/model/message.dart';
import 'package:chat_platform/util/data_loader.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  late List<List<Message>> threads = [];
  late List<Message> currentActiveThreads = [];
  late int currentActiveThreadsIndex;

  LandingBloc() : super(LandingInitial()) {
    on<LandingInitialEvent>((event, emit) async {
      await LandingInitialEventHandler(event, emit);
    });

    on<LandingClickThreadMessageEvent>((event, emit) async {
      await LandingClickThreadMessageEventHandler(event, emit);
    });

    on<LandingCreateNewThreadMessageEvent>((event, emit) async {
      await LandingCreateNewThreadMessageEventHandler(event, emit);
    });

    on<LandingDeleteAllThreadMessageEvent>((event, emit) async {
      await LandingDeleteAllThreadMessageEventHandler(event, emit);
    });

    on<LandingSaveAllThreadsEvent>((event, emit) async {
      await LandingSaveAllThreadsEventHandler(event, emit);
    });
  }

  FutureOr<void> LandingInitialEventHandler(event, emit) async {
    emit(LandingInitial());
    emit(LandingLoadingThreadState());
    await Future.delayed(const Duration(seconds: 2));
    DataLoader loader = DataLoader();
    threads = await loader.readThread();
    emit(LandingLoadedThreadState());
  }

  FutureOr<void> LandingClickThreadMessageEventHandler(event, emit) {
    LandingClickThreadMessageEvent eventModel =
        event as LandingClickThreadMessageEvent;

    currentActiveThreads = threads[eventModel.threadId];
    currentActiveThreadsIndex = eventModel.threadId;
    emit(LandingNavigateToChatScreenState());
    emit(LandingLoadedThreadState());
  }

  FutureOr<void> LandingCreateNewThreadMessageEventHandler(event, emit) async {
    threads.add(
        [Message(role: "system", content: "You are a helpful assistant.")]);
    emit(LandingLoadingThreadState());
    await Future.delayed(const Duration(milliseconds: 100));
    currentActiveThreads = threads.last;
    currentActiveThreadsIndex = threads.length - 1;
    emit(LandingNavigateToChatScreenState());
    emit(LandingLoadedThreadState());
  }

  FutureOr<void> LandingDeleteAllThreadMessageEventHandler(event, emit) async {
    emit(LandingLoadingThreadState());
    await Future.delayed(const Duration(milliseconds: 500));
    threads.clear();
    await LandingSaveAllThreadsEventHandler(event, emit);
    emit(LandingLoadedThreadState());
  }

  FutureOr<void> LandingSaveAllThreadsEventHandler(event, emit) {
    DataLoader loader = DataLoader();
    loader.saveThread(threads);
  }
}
