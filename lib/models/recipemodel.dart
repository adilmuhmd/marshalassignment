class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> tags;
  final List<String> mealType;
  final String prepTimeMinutes;
  final String cookTimeMinutes;
  final String servings;
  final String? difficulty;
  final String? cuisine;
  final String? caloriesPerServing;
  final String? image;
  final double? rating;
  final int? reviewCount;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.tags,
    required this.mealType,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.instructions,
    this.difficulty,
    this.cuisine,
    this.caloriesPerServing,
    this.image,
    this.rating,
    this.reviewCount,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    name: json['name'] ?? '',
    ingredients: List<String>.from(json['ingredients'] ?? []),
    tags: List<String>.from(json['tags'] ?? []),
    mealType: List<String>.from(json['mealType'] ?? []),
    prepTimeMinutes: json['prepTimeMinutes']?.toString() ?? '',
    cookTimeMinutes: json['cookTimeMinutes']?.toString() ?? '',
    servings: json['servings']?.toString() ?? '',
    difficulty: json['difficulty'],
    cuisine: json['cuisine'],
    caloriesPerServing: json['caloriesPerServing']?.toString(),
    image: json['image'],
    rating: (json['rating'] is int) ? (json['rating'] as int).toDouble() : json['rating']?.toDouble(),
    reviewCount: json['reviewCount'],
    instructions: List<String>.from(json['instructions'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'ingredients': ingredients,
    'tags': tags,
    'mealType': mealType,
    'prepTimeMinutes': prepTimeMinutes,
    'cookTimeMinutes': cookTimeMinutes,
    'servings': servings,
    'difficulty': difficulty,
    'cuisine': cuisine,
    'caloriesPerServing': caloriesPerServing,
    'image': image,
    'rating': rating,
    'reviewCount': reviewCount,
    'instructions': instructions,
  };
}
