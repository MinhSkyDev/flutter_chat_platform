part of 'landing_bloc.dart';

abstract class LandingState {}

class LandingInitial extends LandingState {}

class LandingLoadingThreadState extends LandingState {}

class LandingLoadedThreadState extends LandingState {}

class LandingNavigateToChatScreenState extends LandingState {}
