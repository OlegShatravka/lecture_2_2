abstract class UserDetailState {
  const UserDetailState();
}

class CalculatingDistanceState extends UserDetailState {
  const CalculatingDistanceState();
}

class CalculateDistanceSuccessState extends UserDetailState {
  const CalculateDistanceSuccessState(this.distance);

  final num distance;
}

class CalculateDistanceErrorState extends UserDetailState {
  const CalculateDistanceErrorState(this.error);

  final Exception error;
}
