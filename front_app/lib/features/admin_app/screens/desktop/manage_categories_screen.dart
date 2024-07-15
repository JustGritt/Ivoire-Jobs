import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/admin_app/providers/categories_provider.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';

AdminService adminService = serviceLocator<AdminService>();

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchCategories();
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Categories',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onPressed: () {
                showAddCategoryDialog(context);
              },
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading categories'));
          } else {
            return Consumer<CategoriesProvider>(
              builder: (context, categoriesProvider, child) {
                if (categoriesProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (categoriesProvider.categories.isEmpty) {
                  return Center(child: Text('No categories available'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3,
                      ),
                      itemCount: categoriesProvider.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoriesProvider.categories[index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 6,
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
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        category.name,
                                        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  category.status ? 'Active' : 'Inactive',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    color: category.status ? Colors.green : Colors.red,
                                  ),
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
    );
  }
}