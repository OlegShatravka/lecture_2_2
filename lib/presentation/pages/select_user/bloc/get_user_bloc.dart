import 'package:bloc/bloc.dart';
import 'package:lecture_2_2/domain/entity/user.dart';
import 'package:lecture_2_2/domain/error/internet_connection_error.dart';
import 'package:lecture_2_2/domain/repository/user_repository.dart';
import 'package:lecture_2_2/presentation/pages/select_user/bloc/get_user_event.dart';
import 'package:lecture_2_2/presentation/pages/select_user/bloc/get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  GetUserBloc(this._userRepository);

  final UserRepository _userRepository;

  @override
  GetUserState get initialState => const FetchingState();

  @override
  Stream<GetUserState> mapEventToState(GetUserEvent event) async* {
    if (event is GetRandomUserEvent) {
      yield const FetchingState();
      try {
        final User user = await _userRepository.getRandomUser();
        yield SuccessState(user);
      } on InternetConnectionError catch (e) {
        yield ErrorState(e);
      }
    }
  }
}
