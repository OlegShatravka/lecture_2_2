import 'package:dio/dio.dart';
import 'package:lecture_2_2/domain/entity/user.dart';
import 'package:lecture_2_2/domain/error/internet_connection_error.dart';
import 'package:lecture_2_2/domain/repository/user_repository.dart';

class UserRepositoryServer extends UserRepository {
  UserRepositoryServer(this._dio);

  final Dio _dio;

  @override
  Future<User> getRandomUser() async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.get('/api');
      final json = response.data;

      final String firstName = json['results'][0]['name']['first'];
      final String lastName = json['results'][0]['name']['last'];
      final String avatarUrl = json['results'][0]['picture']['large'];
      final double latitude = double.tryParse(
              json['results'][0]['location']['coordinates']['latitude']) ??
          0;
      final double longitude = double.tryParse(
              json['results'][0]['location']['coordinates']['longitude']) ??
          0;

      return User(firstName, lastName, avatarUrl, latitude, longitude);
    } on Exception {
      throw InternetConnectionError();
    }
  }
}
