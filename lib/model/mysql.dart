import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '210.48.158.67',
      user = 'znn',
      password = '!znntech123#',
      db = 'itadikadb';
  static int port = 2222;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}
