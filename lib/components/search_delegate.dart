import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  List<String> previousSearches;
  final ValueChanged<String> onSearchSubmitted;

  CustomSearchDelegate({
    required this.previousSearches,
    required this.onSearchSubmitted,
  });

  // Load previous searches from SharedPreferences
  static Future<List<String>> loadPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('previousSearches') ?? [];
  }

  // Save previous searches to SharedPreferences
  Future<void> _savePreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('previousSearches', previousSearches);
  }

  // Add a new search to the list and save
  Future<void> _addSearch(String query) async {
    if (query.isNotEmpty && !previousSearches.contains(query)) {
      previousSearches.add(query);
      await _savePreviousSearches();
    }
  }

  // Remove a search from the list and save
  Future<void> _removeSearch(String query) async {
    previousSearches.remove(query);
    await _savePreviousSearches();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the query
          onSearchSubmitted(''); // Notify LocationsPage that query is blank
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close and notify query is blank
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchSubmitted(query); 
    _addSearch(query); // Save the search
    close(context, query); // Close the search and return the query
    return const SizedBox.shrink(); // Let parent handle results display
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? previousSearches // Show previous searches if query is empty
        : previousSearches.where((search) => search.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await _removeSearch(suggestions[index]);
              showSuggestions(context);
            },
          ),
          onTap: () {
            query = suggestions[index];
            buildResults(context);
          },
        );
      },
    );
  }
}
