import 'package:qrcodescanner/api/repository.dart';
import 'package:qrcodescanner/model/settings.dart';

class SettingsBloc {
  final _repository = Repository();

  Future<AppSettings> getSettings() => _repository.getSettings();
}
