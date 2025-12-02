import 'package:flutter/foundation.dart';

class Env {
  static final Env _env = Env._internal();

  Env._internal() {
    if (kDebugMode) {
      print('APP_NAME: $appName');
      print('FLAVOR: $flavor');
      print('API_URL: $apiUrl');
      print('API_KEY: $apiKey');
    }
  }

  factory Env() => _env;

  final appName = const String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Penz7',
  );
  final flavor = Flavor.values.byName(const String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'production',
  ));
  final _apiUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://penz.com/api/v1/',
  );

  final apiKey = const String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  String get apiUrl => _apiUrl;

  Future getRemoteConfig() async {
    // final remoteConfig = FirebaseRemoteConfig.instance;
    // await remoteConfig.setDefaults(<String, dynamic>{
    //   'API_URL': _apiUrl,
    //   'DISCOVER_URL': _discoverUrl,
    //   'IS_MAINTAINING': false,
    // });
    // await remoteConfig.setConfigSettings(RemoteConfigSettings(
    //   fetchTimeout: const Duration(minutes: 1),
    //   minimumFetchInterval: flavor == Flavor.develop
    //       ? const Duration(minutes: 1)
    //       : const Duration(hours: 1),
    // ));
    // await remoteConfig.fetchAndActivate();

    // _apiUrl = remoteConfig.getString('API_URL');
    // _discoverUrl = remoteConfig.getString('DISCOVER_URL');
    // _isMaintaining = remoteConfig.getBool('IS_MAINTAINING');
    // _maintainingData = jsonDecode(remoteConfig.getString('MAINTAINING_DATA'));

    // print('Remote config: ${remoteConfig.getAll().map(
    //       (key, value) => MapEntry(key, value.asString()),
    //     )}');
  }
}

enum Flavor { production, develop }
