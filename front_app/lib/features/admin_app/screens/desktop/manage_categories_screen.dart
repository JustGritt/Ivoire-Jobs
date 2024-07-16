import 'package:barassage_app/features/admin_app/providers/categories_provider.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/search_input.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/admin_app/models/category.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

AdminService adminService = serviceLocator<AdminService>();

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  late Future<List<Category>> categoriesFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Category> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchCategories();
    categoriesFuture.then((categories) {
      setState(() {
        _filteredCategories = categories;
      });
    });
  }

  Future<List<Category>> fetchCategories() async {
    final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    await categoriesProvider.getAllCategories();
    return categoriesProvider.categories;
  }

  Future<void> showAddCategoryDialog(BuildContext context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String name = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Category Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        name = value ?? '';
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newCategory = CategoryRequest(name: name);
                  final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
                  await categoriesProvider.addCategory(newCategory.name);
                  Navigator.of(context).pop();
                  setState(() {
                    categoriesFuture = fetchCategories();
                  });
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _handleSearch(String query) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    final filtered = categoriesProvider.categories.where((category) {
      final categoryName = category.name.toLowerCase();
      final searchQuery = query.toLowerCase();
      return categoryName.contains(searchQuery);
    }).toList();
    setState(() {
      _filteredCategories = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  onPressed: () {
                    showAddCategoryDialog(context);
                  },
                  child: const Text(
                    'New category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchInput(
              textController: _searchController,
              hintText: 'Search Categories',
              onChanged: _handleSearch,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading categories'));
                } else {
                  return Consumer<CategoriesProvider>(
                    builder: (context, categoriesProvider, child) {
                      if (categoriesProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (_filteredCategories.isEmpty) {
                        return const Center(child: Text('No categories available'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3,
                            ),
                            itemCount: _filteredCategories.length,
                            itemBuilder: (context, index) {
                              final category = _filteredCategories[index];
                              return Card(
                                color: Colors.grey[100],
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4,
                                shadowColor: Colors.grey.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: theme.primaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.category,
                                              color: theme.primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              category.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: primary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Icon(
                                            category.status ? Icons.check_circle : Icons.cancel,
                                            color: category.status ? Colors.green : Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            category.status ? 'Active' : 'Inactive',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontSize: 14,
                                              color: category.status ? Colors.green : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
