part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchValueChanged extends SearchEvent {
  const SearchValueChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}
