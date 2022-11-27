import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vybln/core/injection_container.dart';
import 'package:vybln/features/auth/blocs/auth/auth_bloc.dart';

import '../../../../common/models/user.dart';
import '../../../../core/exceptions/search_exceptions.dart';
import '../../repositories/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required SearchRepository searchRepository})
      : _searchRepository = searchRepository,
        super(SearchInitial()) {
    on<SearchValueChanged>(_onValueChanged);
  }

  final SearchRepository _searchRepository;

  void _onValueChanged(
    SearchValueChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchFetchingInProgress());
    try {
      final result = await _searchRepository.getUsersByUsername(event.value);
      final currentUser = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;
      result.remove(currentUser);
      return emit(SearchFetchingSuccess(result));
    } on GetUsersFromFirestoreException catch (_) {
      return emit(SearchFetchingFailed());
    } on Exception catch (_) {
      return emit(SearchFetchingFailed());
    }
  }
}
