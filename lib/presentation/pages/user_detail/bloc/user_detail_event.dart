import 'package:lecture_2_2/domain/entity/user.dart';

abstract class UserDetailEvent {
  const UserDetailEvent();
}

class CalculateDistanceEvent extends UserDetailEvent {
  const CalculateDistanceEvent(this.user);

  final User user;
}
