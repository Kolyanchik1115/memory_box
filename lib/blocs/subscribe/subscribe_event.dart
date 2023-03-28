part of 'subscribe_bloc.dart';

abstract class SubscribeEvent {}

class ChangeSubscribeEvent extends SubscribeEvent {
  final bool changeSub;
  ChangeSubscribeEvent({
    this.changeSub = false,
  });
}
