import 'package:flutter/material.dart';

import '../models/auth.dart';
import 'login_page.dart';
import 'notelist_page.dart';



class RootPage extends StatefulWidget {
  RootPage({required this.auth}) : super();
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          title: 'Flutter Task',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn) ,
        );
      case AuthStatus.signedIn:
        return new NoteListPage(
          auth: widget.auth,
          onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
        );


    }
  }
}