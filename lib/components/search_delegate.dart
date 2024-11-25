import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> previousSearches;
  final ValueChanged<String> onSearchSubmitted;

  CustomSearchDelegate({
    required this.previousSearches,
    required this.onSearchSubmitted,
  });

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
    onSearchSubmitted(query); // Notify LocationsPage about the query
    close(context, query); // Close the search and return the query
    return const SizedBox.shrink(); // Let parent handle results display
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? previousSearches // Show previous searches if query is empty
        : previousSearches.where((search) => search.contains(query)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            buildResults(context);
          },
        );
      },
    );
  }
}

