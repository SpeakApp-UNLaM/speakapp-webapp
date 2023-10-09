import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_app_web/auth/user.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.userId);
    prefs.setString("username", user.username);
    prefs.setString("firstName", user.firstName);
    prefs.setString("lastName", user.lastName);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("type", user.type);
    prefs.setString("token", user.token);
    prefs.setString("renewalToken", user.renewalToken);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId") as int;
    String username = prefs.getString("username") as String;
    String firstName = prefs.getString("firstName") as String;
    String lastName = prefs.getString("lastName") as String;
    String email = prefs.getString("email") as String;
    String phone = prefs.getString("phone") as String;
    String type = prefs.getString("type") as String;
    String token = prefs.getString("token") as String;
    String renewalToken = prefs.getString("renewalToken") as String;

    return User(
        userId: userId,
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        type: type,
        token: token,
        renewalToken: renewalToken);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("username");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("type");
    prefs.remove("token");

    prefs.clear();
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") as String;
    return token;
  }
}
