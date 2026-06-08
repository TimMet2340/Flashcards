// In-memory localStorage shim for non-web platforms (tests, mobile, desktop)
class _InMemoryLocalStorage {
  final Map<String, String> _store = {};

  // exspects localStorage['key']
  String? operator [](String key) => _store[key];
  // exspects localStorage['key'] = 'value'
  void operator []=(String key, String value) => _store[key] = value;
}

final _inMemoryLocalStorage = _InMemoryLocalStorage();

// Expose with the name `localStorage` so the conditional import matches web API
final localStorage = _inMemoryLocalStorage;
