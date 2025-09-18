import 'dart:math';

// Model class for our items
class Item {
  final int id;
  final String name;

  Item({required this.id, required this.name});
}

// Mock data source that simulates pagination
class MockPaginatedDataSource {
  // Simulate a large dataset
  final List<Item> _allItems = List.generate(
    100,
    (index) => Item(
      id: index + 1,
      name: 'Item ${index + 1}',
    ),
  );

  // Page size for pagination
  final int limit;

  MockPaginatedDataSource({this.limit = 10});

  Future<PaginatedResponse<Item>> getItems({required int page}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Calculate start and end indices for the requested page
    final startIndex = (page - 1) * limit;
    final endIndex = min(startIndex + limit, _allItems.length);

    // Check if we're trying to access beyond available data
    if (startIndex >= _allItems.length) {
      return PaginatedResponse(
        items: [],
        currentPage: page,
        totalPages: (_allItems.length / limit).ceil(),
        hasNextPage: false,
      );
    }

    // Get items for the current page
    final items = _allItems.sublist(startIndex, endIndex);

    return PaginatedResponse(
      items: items,
      currentPage: page,
      totalPages: (_allItems.length / limit).ceil(),
      hasNextPage: endIndex < _allItems.length,
    );
  }
}

// Response class to handle pagination data
class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });
}

// Example usage
void main() async {
  // Create an instance of the mock data source
  final dataSource = MockPaginatedDataSource(limit: 10);

  // Get first page
  final firstPage = await dataSource.getItems(page: 1);
  print('Page ${firstPage.currentPage} items:');
  for (var item in firstPage.items) {
    print('${item.id}: ${item.name}');
  }
  print('Has next page: ${firstPage.hasNextPage}');
  print('Total pages: ${firstPage.totalPages}');

  // Get second page
  final secondPage = await dataSource.getItems(page: 2);
  print('\nPage ${secondPage.currentPage} items:');
  for (var item in secondPage.items) {
    print('${item.id}: ${item.name}');
  }
  print('Has next page: ${secondPage.hasNextPage}');
}
