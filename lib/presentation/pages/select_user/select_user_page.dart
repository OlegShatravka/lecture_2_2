import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_2_2/domain/entity/user.dart';
import 'package:lecture_2_2/presentation/pages/select_user/bloc/get_user_bloc.dart';
import 'package:lecture_2_2/presentation/pages/user_detail/user_detail_page.dart';

import 'bloc/get_user_event.dart';
import 'bloc/get_user_state.dart';

class SelectUserPage extends StatefulWidget {
  static const String PAGE_NAME = '/';

  @override
  _SelectUserPageState createState() => _SelectUserPageState();
}

class _SelectUserPageState extends State<SelectUserPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetUserBloc>(context).add(const GetRandomUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose user'),
      ),
      body: BlocBuilder<GetUserBloc, GetUserState>(
        builder: (context, state) {
          if (state is ErrorState) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: const Text('Check your internet connection'),
                  ),
                ),
                _buildButtons(state)
              ],
            );
          } else if (state is SuccessState) {
            final User user = state.user;
            return Column(
              children: <Widget>[
                Expanded(child: _buildUserWidget(user)),
                _buildButtons(state)
              ],
            );
          } else {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserWidget(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          child: Hero(
            tag: user.avatarUrl,
            child: Image.network(
              '${user.avatarUrl}',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${user.firstName} ${user.lastName}'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildButtons(GetUserState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Ink(
          decoration: ShapeDecoration(
            color: Colors.grey,
            shape: CircleBorder(),
          ),
          child: IconButton(
            iconSize: 36,
            onPressed: _getNextUser,
            icon: Icon(Icons.refresh),
          ),
        ),
        Ink(
          decoration: ShapeDecoration(
            color: Colors.lightBlue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            iconSize: 36,
            color: Colors.black,
            onPressed: () => _navigateToUserDetail(context, state),
            icon: Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }

  void _navigateToUserDetail(BuildContext context, GetUserState state) {
    if (state is SuccessState) {
      Navigator.of(context).pushNamed(UserDetailPage.PAGE_NAME);
    }
  }

  void _getNextUser() =>
      BlocProvider.of<GetUserBloc>(context).add(const GetRandomUserEvent());
}
