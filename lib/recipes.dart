import 'package:flutter/material.dart';
import 'package:marshalassignment/recipedetailpage.dart';
import 'package:provider/provider.dart';
import '../providers/recipeprovider.dart';

class RecipeListPage extends StatefulWidget {
  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RecipeProvider>(context, listen: false);
    provider.fetchRecipes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        final provider = Provider.of<RecipeProvider>(context, listen: false);
        if (provider.hasMore && !provider.isLoading) {
          provider.searchRecipes(
            query: _searchController.text,
            selectedMealTypes: provider.selectedMealTypes,
            selectedTags: provider.selectedTags,
            loadMore: true,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildIngredientBullet(String ingredient) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ", style: TextStyle(fontSize: 16)),
        Expanded(child: Text(ingredient)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableMealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    final availableTags = ['Pakistani', 'Indian', 'Italian', 'Chinese', 'Mexican']; // You can fetch dynamically

    return Scaffold(
      appBar: AppBar(title: Text('All Recipes')),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, _) {
          final recipes = provider.recipes;

          return Column(
            children: [
              SizedBox(height: 8),

              // Meal Type Filters
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: availableMealTypes.map((type) {
                    final isSelected = provider.selectedMealTypes.contains(type);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          final updated = [...provider.selectedMealTypes];
                          selected ? updated.add(type) : updated.remove(type);
                          provider.updateSelectedMealTypes(updated);
                          provider.searchRecipes(
                            query: _searchController.text,
                            selectedMealTypes: updated,
                            selectedTags: provider.selectedTags,
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 8),

              // Tag Filters
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: availableTags.map((tag) {
                    final isSelected = provider.selectedTags.contains(tag);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          final updated = [...provider.selectedTags];
                          selected ? updated.add(tag) : updated.remove(tag);
                          provider.updateSelectedTags(updated);
                          provider.searchRecipes(
                            query: _searchController.text,
                            selectedMealTypes: provider.selectedMealTypes,
                            selectedTags: updated,
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 8),

              // Search Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search recipes...",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                        Provider.of<RecipeProvider>(context, listen: false)
                            .resetPagination();
                        Provider.of<RecipeProvider>(context, listen: false)
                            .searchRecipes(
                          query: '',
                          selectedMealTypes: Provider.of<RecipeProvider>(context, listen: false).selectedMealTypes,
                          selectedTags: Provider.of<RecipeProvider>(context, listen: false).selectedTags,
                        );
                      },
                    )
                        : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (_) => setState(() {}), // triggers suffixIcon visibility update
                  onSubmitted: (query) {
                    Provider.of<RecipeProvider>(context, listen: false).resetPagination();
                    Provider.of<RecipeProvider>(context, listen: false).searchRecipes(
                      query: query,
                      selectedMealTypes: Provider.of<RecipeProvider>(context, listen: false).selectedMealTypes,
                      selectedTags: Provider.of<RecipeProvider>(context, listen: false).selectedTags,
                    );
                  },
                ),
              ),
              Expanded(
                child: provider.isLoading && recipes.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : recipes.isEmpty
                    ? Center(child: Text('No recipes found'))
                    : GridView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: recipes.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == recipes.length) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final recipe = recipes[index];

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeDetailPage(recipe: recipe),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.name,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Divider(),
                                  Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Expanded(
                                    child: ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: recipe.ingredients
                                          .map((ing) => _buildIngredientBullet(ing))
                                          .toList(),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text('Prep Time: ${recipe.prepTimeMinutes} min'),
                                  Text('Servings: ${recipe.servings}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Delete Button in top-right
                        Positioned(
                          top: 230,
                          right: 10,
                          child: InkWell(
                            onTap: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Delete Recipe"),
                                  content: const Text("Are you sure you want to delete this recipe?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                await Provider.of<RecipeProvider>(context, listen: false)
                                    .deleteRecipe(recipe.id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Recipe deleted')),
                                );
                              }
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black,
                              child: Icon(Icons.delete, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
