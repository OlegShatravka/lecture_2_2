import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_2_2/domain/entity/user.dart';
import 'package:lecture_2_2/domain/error/gps_not_enabled_error.dart';
import 'package:lecture_2_2/presentation/pages/user_detail/bloc/user_detail_event.dart';
import 'package:lecture_2_2/presentation/pages/user_detail/bloc/user_detail_state.dart';

import 'bloc/user_detail_bloc.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage(this._user, {Key key}) : super(key: key);

  final User _user;

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserDetailBloc>(context)
        .add(CalculateDistanceEvent(widget._user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget._user.firstName} ${widget._user.lastName}'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: widget._user.avatarUrl,
              child: Image.network(
                '${widget._user.avatarUrl}',
                fit: BoxFit.contain,
                width: double.maxFinite,
              ),
            ),
            BlocBuilder<UserDetailBloc, UserDetailState>(
              builder: (context, state) {
                if (state is CalculateDistanceSuccessState) {
                  return Text(
                      '${widget._user.firstName} is ${state.distance} km away from you!');
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
      ),
    );
  }
}
