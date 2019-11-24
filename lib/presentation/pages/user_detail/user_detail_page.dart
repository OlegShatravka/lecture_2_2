import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_2_2/domain/entity/user.dart';
import 'package:lecture_2_2/domain/error/gps_not_enabled_error.dart';
import 'package:lecture_2_2/presentation/pages/select_user/bloc/get_user_bloc.dart';
import 'package:lecture_2_2/presentation/pages/select_user/bloc/get_user_state.dart';
import 'package:lecture_2_2/presentation/pages/user_detail/bloc/user_detail_event.dart';
import 'package:lecture_2_2/presentation/pages/user_detail/bloc/user_detail_state.dart';

import 'bloc/user_detail_bloc.dart';

class UserDetailPage extends StatefulWidget {
  static const String PAGE_NAME = '/detail';

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    final User user = _getCurrentUser(context);
    BlocProvider.of<UserDetailBloc>(context).add(CalculateDistanceEvent(user));
  }

  @override
  Widget build(BuildContext context) {
    final User user = _getCurrentUser(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: user.avatarUrl,
            child: Image.network(
              '${user.avatarUrl}',
              fit: BoxFit.contain,
              width: double.maxFinite,
            ),
          ),
          BlocBuilder<UserDetailBloc, UserDetailState>(
            builder: (context, state) {
              if (state is CalculateDistanceSuccessState) {
                return Text(
                    '${user.firstName} is ${state.distance} km away from you!');
              } else if (state is CalculateDistanceErrorState) {
                final error = state.error;
                if (error is GpsNotEnabledError) {
                  return const Text('Enable gps and try again');
                } else {
                  return const Text('Permissions not provided');
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

  User _getCurrentUser(BuildContext context) {
    final SuccessState state = BlocProvider.of<GetUserBloc>(context).state;
    return state.user;
  }
}
