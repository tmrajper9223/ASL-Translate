abstract class BaseUser {

  String _name;
  String _email;

  BaseUser(this._name, this._email);

  String getBaseUsername();

  String getBaseUserEmail();

  String toString();
}

class User extends BaseUser {

  User(_username, _userEmail) : super(_username, _userEmail);

  @override
  String getBaseUsername() => super._name;

  @override
  String getBaseUserEmail() => super._email;

  @override
  String toString() => "Username: ${getBaseUsername()} Email: ${getBaseUserEmail()}";

}