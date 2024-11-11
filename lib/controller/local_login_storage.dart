import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:logger/logger.dart';
class LocalLoginStorage{
  Future<void> saveLoginCredentials(String username, String password) async {
    final LocalStorageInterface localStorage = await LocalStorage.getInstance();
    await localStorage.setString('username', username);
    await localStorage.setString('password', password);
    Logger().i('Credentials saved successfully $username, $password');
  }

  Future<Map<String, String?>> getLoginCredentials() async {
    final LocalStorageInterface localStorage = await LocalStorage.getInstance();
    String? username = localStorage.getString('username');
    String? password = localStorage.getString('password');
    return {
      'username': username,
      'password': password,
    };
  }

  Future<void> deleteLoginCredentials() async {
    final LocalStorageInterface localStorage = await LocalStorage.getInstance();
    await localStorage.remove('username');
    await localStorage.remove('password');
    Logger().i('Credentials deleted successfully');
  }

  Future<String?> getUserName() async{
    final LocalStorageInterface localStorage = await LocalStorage.getInstance();
    return localStorage.getString('username');
  }

  Future<String?> getUserPsw() async{
    final LocalStorageInterface localStorage = await LocalStorage.getInstance();
    return localStorage.getString('password');
  }

}