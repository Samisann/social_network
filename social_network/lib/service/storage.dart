import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class StorageService {
 final _secureStorage = const FlutterSecureStorage();

Future<void> writeSecureData(String k,String v) async {
 await _secureStorage.write(key: k, value: v, aOptions: _getAndroidOptions());
}

 AndroidOptions _getAndroidOptions() => const AndroidOptions(
     encryptedSharedPreferences: true,
 );
 Future<String?> readSecureData(String key) async {
  var readData =
     await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
   return readData;
 }
}