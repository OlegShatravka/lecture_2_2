import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_2_2/data/platform/location_repository_platform.dart';
import 'package:lecture_2_2/domain/repository/location_repository.dart';
import 'package:lecture_2_2/presentation/pages/select_user/bloc/get_user_bloc.dart';
import 'package:lecture_2_2/presentation/pages/select_user/select_user_page.dart';
import 'package:lecture_2_2/presentation/pages/user_detail/bloc/user_detail_bloc.dart';

import 'data/server/user_repository_server.dart';
import 'domain/repository/user_repository.dart';

void main() {
  final BaseOptions baseOptions =
      BaseOptions(baseUrl: 'https://randomuser.me/');
  final Dio dio = Dio(baseOptions);

  final UserRepository userRepository = UserRepositoryServer(dio);
  final LocationRepository locationRepository = LocationRepositoryPlatform();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<GetUserBloc>(
            builder: (context) => GetUserBloc(userRepository)),
        BlocProvider<UserDetailBloc>(
            builder: (context) => UserDetailBloc(locationRepository)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Powerful Tinder',
      theme: ThemeData.dark(),
      home: SelectUserPage(),
    );
  }
}
