import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<String> _previousSearches = [];

  List<String> get previousSearches => _previousSearches;

  void addSearch(String search) {
    if (!_previousSearches.contains(search)) {
      _previousSearches.add(search);
      notifyListeners();
    }
  }

  void clearSearches() {
    _previousSearches.clear();
    notifyListeners();
  }
}
