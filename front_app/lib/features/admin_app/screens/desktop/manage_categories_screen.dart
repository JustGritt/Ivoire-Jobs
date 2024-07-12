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
  late Future<void> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchCategories();
  }

  Future<void> fetchCategories() async {
    final categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    await categoriesProvider.getAllCategories();
  }

  Future<void> showAddCategoryDialog(BuildContext context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    int duration = 0;
    bool isActive = false;
    DateTime createdAt = DateTime.now();
    DateTime updatedAt = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Set the width to 80% of the screen width
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Category Name'),
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
                  final newCategory = CategoryRequest(
                    name: name,
                  );
                  final categoriesProvider =
                      Provider.of<CategoriesProvider>(context, listen: false);
                  await categoriesProvider.addCategory(newCategory.name);
                  Navigator.of(context).pop();
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
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              showAddCategoryDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
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
                  return ListView.builder(
                    itemCount: categoriesProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoriesProvider.categories[index];
                      return ListTile(
                        title: Text(category.name),
                        subtitle: Text(category.description),
                        onTap: () {
                          //
                        },
                      );
                    },
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
