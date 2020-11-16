class EntryCounter {
  final List<bool> _entries;

  int _addedEntriesCount = 0;

  EntryCounter._(this._entries);

  bool get hasEntries => _addedEntriesCount > 0;

  factory EntryCounter.from(int count) {
    return EntryCounter._(List.filled(count, false));
  }

  void addEntry(int index) {
    if (_entries[index] == false) {
      _entries[index] = true;
      _addedEntriesCount++;
    }
  }

  void removeEntry(int index) {
    if (_entries[index] == true) {
      _entries[index] = false;
      _addedEntriesCount--;
    }
  }
}
