import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/recipemodel.dart';
import 'providers/recipeprovider.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController cuisineController;
  late TextEditingController difficultyController;
  late TextEditingController caloriesController;
  late TextEditingController prepTimeController;
  late TextEditingController cookTimeController;
  late TextEditingController servingsController;
  late TextEditingController imageController;
  late TextEditingController ratingController;
  late TextEditingController reviewCountController;
  late TextEditingController ingredientsController;
  late TextEditingController instructionsController;
  late TextEditingController tagsController;
  late TextEditingController mealTypeController;

  @override
  void initState() {
    super.initState();
    final r = widget.recipe;
    nameController = TextEditingController(text: r.name);
    cuisineController = TextEditingController(text: r.cuisine);
    difficultyController = TextEditingController(text: r.difficulty);
    caloriesController = TextEditingController(text: r.caloriesPerServing);
    prepTimeController = TextEditingController(text: r.prepTimeMinutes);
    cookTimeController = TextEditingController(text: r.cookTimeMinutes);
    servingsController = TextEditingController(text: r.servings);
    imageController = TextEditingController(text: r.image);
    ratingController = TextEditingController(text: r.rating?.toString() ?? '');
    reviewCountController = TextEditingController(text: r.reviewCount?.toString() ?? '');
    ingredientsController = TextEditingController(text: r.ingredients.join(', '));
    instructionsController = TextEditingController(text: r.instructions.join(', '));
    tagsController = TextEditingController(text: r.tags.join(', '));
    mealTypeController = TextEditingController(text: r.mealType.join(', '));
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = {
      'name': nameController.text.trim(),
      'cuisine': cuisineController.text.trim(),
      'difficulty': difficultyController.text.trim(),
      'caloriesPerServing': caloriesController.text.trim(),
      'prepTimeMinutes': prepTimeController.text.trim(),
      'cookTimeMinutes': cookTimeController.text.trim(),
      'servings': servingsController.text.trim(),
      'image': imageController.text.trim(),
      'rating': double.tryParse(ratingController.text),
      'reviewCount': int.tryParse(reviewCountController.text),
      'ingredients': ingredientsController.text.split(',').map((e) => e.trim()).toList(),
      'instructions': instructionsController.text.split(',').map((e) => e.trim()).toList(),
      'tags': tagsController.text.split(',').map((e) => e.trim()).toList(),
      'mealType': mealTypeController.text.split(',').map((e) => e.trim()).toList(),
    };

    await Provider.of<RecipeProvider>(context, listen: false)
        .updateRecipe(widget.recipe.id, updated);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe updated')),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Recipe")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField("Name", nameController),
                    _buildField("Cuisine", cuisineController),
                    _buildField("Difficulty", difficultyController),
                    _buildField("Calories", caloriesController),
                    Row(
                      children: [
                        Expanded(child: _buildField("Prep Time", prepTimeController)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildField("Cook Time", cookTimeController)),
                      ],
                    ),
                    _buildField("Servings", servingsController),
                    _buildField("Image URL", imageController),
                    Row(
                      children: [
                        Expanded(child: _buildField("Rating", ratingController)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildField("Review Count", reviewCountController)),
                      ],
                    ),
                    _buildField("Ingredients (comma-separated)", ingredientsController, maxLines: 2),
                    _buildField("Instructions (comma-separated)", instructionsController, maxLines: 2),
                    _buildField("Tags (comma-separated)", tagsController),
                    _buildField("Meal Types (comma-separated)", mealTypeController),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
