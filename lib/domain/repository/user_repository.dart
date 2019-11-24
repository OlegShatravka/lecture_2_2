import 'package:lecture_2_2/domain/entity/user.dart';

abstract class UserRepository {
  Future<User> getRandomUser();
}
