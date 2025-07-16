import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/recipemodel.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  final int _pageSize = 1000;
  int _skip = 0;
  bool _hasMore = true;
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  RecipeProvider() {
    fetchRecipes();
  }

  List<String> _selectedTags = [];
  List<String> _selectedMealTypes = [];

  List<String> get selectedTags => _selectedTags;
  List<String> get selectedMealTypes => _selectedMealTypes;

  void updateSelectedTags(List<String> tags) {
    _selectedTags = tags;
    print(_selectedTags);
    notifyListeners();
  }

  void updateSelectedMealTypes(List<String> types) {
    _selectedMealTypes = types;
    print(_selectedMealTypes);
    notifyListeners();
  }


  Future<void> fetchRecipes({bool loadMore = false}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      if (loadMore) {
        _skip += _pageSize;
      } else {
        _skip = 0;
        _recipes.clear();
        _hasMore = true;
      }

      if (!_hasMore && loadMore) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url = 'https://dummyjson.com/recipes?limit=$_pageSize&skip=$_skip';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> recipesJson = data['recipes'] ?? [];

        final newRecipes = recipesJson.map((json) => Recipe.fromJson(json)).toList();
        _recipes.addAll(newRecipes);

        _hasMore = newRecipes.length == _pageSize;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _hasMore = false;
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> searchRecipes({
    required String query,
    List<String> selectedMealTypes = const [],
    List<String> selectedTags = const [],
    bool loadMore = false,
  }) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      if (loadMore) {
        _skip += _pageSize;
      } else {
        _skip = 0;
        _recipes.clear();
        _hasMore = true;
      }

      final url =
          'https://dummyjson.com/recipes/search?q=$query';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> recipesJson = data['recipes'] ?? [];

        // Filter by mealType
        if (selectedMealTypes.isNotEmpty) {
          recipesJson = recipesJson.where((r) {
            final mtList = (r['mealType'] as List<dynamic>? ?? []).map((e) => e.toString().toLowerCase()).toList();
            return selectedMealTypes.any((sel) => mtList.contains(sel.toLowerCase()));
          }).toList();
        }

        // Filter by tags
        if (selectedTags.isNotEmpty) {
          recipesJson = recipesJson.where((r) {
            final tags = (r['tags'] as List<dynamic>?)?.map((e) => e.toString().toLowerCase()).toList() ?? [];
            return selectedTags.any((tag) => tags.contains(tag.toLowerCase()));
          }).toList();
        }

        final newRecipes = recipesJson.map((json) => Recipe.fromJson(json)).toList();
        _recipes.addAll(newRecipes);
        _hasMore = newRecipes.length == _pageSize;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _hasMore = false;
      debugPrint('❌ Error in searchRecipes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> fetchByMealType(String mealType, {bool loadMore = false}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      if (loadMore) {
        _skip += _pageSize;
      } else {
        _skip = 0;
        _recipes.clear();
        _hasMore = true;
      }

      final url =
            'https://dummyjson.com/recipes/meal-type/$mealType?limit=$_pageSize&skip=$_skip';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> recipesJson = data['recipes'] ?? [];

        final newRecipes = recipesJson.map((json) => Recipe.fromJson(json)).toList();
        _recipes.addAll(newRecipes);
        _hasMore = newRecipes.length == _pageSize;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _hasMore = false;
      debugPrint('❌ Error in fetchByMealType: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchByTag(String tag, {bool loadMore = false}) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      if (loadMore) {
        _skip += _pageSize;
      } else {
        _skip = 0;
        _recipes.clear();
        _hasMore = true;
      }

      final url =
          'https://dummyjson.com/recipes/tag/$tag?limit=$_pageSize&skip=$_skip';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> recipesJson = data['recipes'] ?? [];

        final newRecipes =
        recipesJson.map((json) => Recipe.fromJson(json)).toList();
        _recipes.addAll(newRecipes);
        _hasMore = newRecipes.length == _pageSize;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _hasMore = false;
      debugPrint('❌ Error in fetchByTag: $e');
    }

    _isLoading = false;
    notifyListeners();
  }



  Future<void> addRecipe(Recipe recipe) async {
    final url = 'https://dummyjson.com/recipes/add';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(recipe.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newRecipe = Recipe.fromJson(jsonDecode(response.body));
        _recipes.insert(0, newRecipe);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error adding recipe: $e');
    }
  }


  Future<void> updateRecipe(int id, Map<String, dynamic> updatedFields) async {
    final url = 'https://dummyjson.com/recipes/$id';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedFields),
      );

      if (response.statusCode == 200) {
        final updatedRecipe = Recipe.fromJson(jsonDecode(response.body));
        final index = _recipes.indexWhere((r) => r.id == id);
        if (index != -1) {
          _recipes[index] = updatedRecipe;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('❌ Error updating recipe: $e');
    }
  }


  Future<void> deleteRecipe(int id) async {
    final url = 'https://dummyjson.com/recipes/$id';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _recipes.removeWhere((r) => r.id == id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error deleting recipe: $e');
    }
  }


  void resetPagination() {
    _skip = 0;
    _recipes.clear();
    _hasMore = true;
    notifyListeners();
  }
}
