import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'editrecipepage.dart';
import '../models/recipemodel.dart';
import '../providers/recipeprovider.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          TextButton(
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRecipePage(recipe: recipe),
                ),
              );
            },
            child: const Text("Edit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recipe.image != null && recipe.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        recipe.image!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text('Cuisine: ${recipe.cuisine ?? "N/A"}', style: const TextStyle(fontSize: 16)),
                  Text('Difficulty: ${recipe.difficulty ?? "N/A"}'),
                  Text('Calories/Serving: ${recipe.caloriesPerServing ?? "N/A"}'),
                  Text('Prep: ${recipe.prepTimeMinutes} min, Cook: ${recipe.cookTimeMinutes} min'),
                  Text('Servings: ${recipe.servings}'),
                  Text('⭐ Rating: ${recipe.rating ?? "N/A"} (${recipe.reviewCount ?? 0} reviews)'),
                  const Divider(height: 30),
                  const Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...recipe.ingredients.map(_buildBulletItem),
                  const Divider(height: 30),
                  const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...recipe.instructions.map(_buildBulletItem),
                  const Divider(height: 30),
                  Text('Tags: ${recipe.tags.join(', ')}'),
                  Text('Meal Type: ${recipe.mealType.join(', ')}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
