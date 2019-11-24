import 'package:bloc/bloc.dart';
import 'package:lecture_2_2/domain/entity/user.dart';
import 'package:lecture_2_2/domain/repository/location_repository.dart';
import 'package:lecture_2_2/presentation/pages/user_detail/bloc/user_detail_event.dart';
import 'package:lecture_2_2/presentation/pages/user_detail/bloc/user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserDetailBloc(this._locationRepository);

  final LocationRepository _locationRepository;

  @override
  UserDetailState get initialState => const CalculatingDistanceState();

  @override
  Stream<UserDetailState> mapEventToState(UserDetailEvent event) async* {
    if (event is CalculateDistanceEvent) {
      final User user = event.user;
      yield const CalculatingDistanceState();
      try {
        final distance = await _locationRepository.calculateDistanceToUser(
          user.longitude,
          user.latitude,
        );
        yield CalculateDistanceSuccessState(distance);
      } on Exception catch (e) {
        yield CalculateDistanceErrorState(e);
      }
    }
  }
}
