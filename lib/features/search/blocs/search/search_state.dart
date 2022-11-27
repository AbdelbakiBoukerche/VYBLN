part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchFetchingInProgress extends SearchState {}

class SearchFetchingSuccess extends SearchState {
  const SearchFetchingSuccess(this.users);

  final List<User> users;

  @override
  List<Object> get props => [users];
}

class SearchFetchingFailed extends SearchState {}
