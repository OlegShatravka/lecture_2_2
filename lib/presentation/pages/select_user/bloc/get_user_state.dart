import 'package:lecture_2_2/domain/entity/user.dart';

abstract class GetUserState {
  const GetUserState();
}

class FetchingState extends GetUserState {
  const FetchingState();
}

class SuccessState extends GetUserState {
  const SuccessState(this.user);

  final User user;
}

class ErrorState extends GetUserState {
  const ErrorState(this.error);

  final Exception error;
}
