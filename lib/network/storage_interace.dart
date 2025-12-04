abstract class IStorage {
  Future<String?> get<T>(String key);
  Future<bool> set<T>(String key, String value);
  Future<String?> delete<T>(String key);
  Future<bool> clear();
}
