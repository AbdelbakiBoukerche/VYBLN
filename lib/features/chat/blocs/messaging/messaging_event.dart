part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class MessagingSendMessage extends MessagingEvent {
  const MessagingSendMessage(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}
