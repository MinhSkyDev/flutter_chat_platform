part of 'landing_bloc.dart';

abstract class LandingEvent {}

class LandingInitialEvent extends LandingEvent {}

class LandingClickThreadMessageEvent extends LandingEvent {
  int threadId;
  LandingClickThreadMessageEvent({required this.threadId});
}

class LandingCreateNewThreadMessageEvent extends LandingEvent {}

class LandingDeleteAllThreadMessageEvent extends LandingEvent {}

class LandingSaveAllThreadsEvent extends LandingEvent {}
