import 'package:baton/models/entities/user.dart';

sealed class LoginStatus {
  final User user;
  LoginStatus(this.user);
}

class ExistingUser extends LoginStatus {
  ExistingUser(super.user);
}

class NewUser extends LoginStatus {
  NewUser(super.user);
}
