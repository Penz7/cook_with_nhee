import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/storage_key.dart';
import '../jwt.dart';
import '../storage_interace.dart';

class StorageService extends GetxService implements IStorage {
  late final GetStorage _storage;

  Future<StorageService> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    return this;
  }

  @override
  Future<bool> clear() async {
    await _storage.erase();
    return true;
  }

  @override
  Future<String?> delete<T>(String key) async {
    final value = _storage.read(key);
    await _storage.remove(key);
    return value;
  }

  @override
  Future<String?> get<T>(String key) async {
    return _storage.read<String>(key);
  }

  @override
  Future<bool> set<T>(String key, String value) async {
    await _storage.write(key, value);
    return true;
  }

  Future<dynamic> decodeToken() async {
    try {
      var token = await get(StorageKey.token);
      if (token == null) throw Exception("Token is null");
      return Jwt.parseJwtPayLoad(token);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<bool> setToken(String token) async {
    await set(StorageKey.token, token);
    return true;
  }

  Future<dynamic> getToken() async {
    try {
      return await get(StorageKey.token);
    } catch (error) {
      return Future.error(error);
    }
  }
}
