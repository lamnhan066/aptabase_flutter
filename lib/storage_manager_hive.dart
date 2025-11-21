import "package:aptabase_flutter/storage_manager.dart";
import "package:hive_ce_flutter/hive_flutter.dart";

class StorageManagerHive extends StorageManager {
  final _events = <String, String>{};
  late final Box<String> _box;

  @override
  Future<void> init() async {
    await Hive.initFlutter();

    _box = await Hive.openBox<String>("aptabase");

    return super.init();
  }

  @override
  Future<void> addEvent(String key, String event) async {
    _events[key] = event;

    await _box.put(key, event);
  }

  @override
  Future<void> deleteEvents(Set<String> keys) async {
    _events.removeWhere((k, _) => keys.contains(k));

    for (final key in keys) {
      await _box.delete(key);
    }
  }

  @override
  Future<Iterable<MapEntry<String, String>>> getItems(int length) async {
    return _events.entries.take(length);
  }
}
