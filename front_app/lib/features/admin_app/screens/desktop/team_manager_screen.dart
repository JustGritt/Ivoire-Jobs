import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/user_card.dart';
import 'package:barassage_app/features/admin_app/models/admin_user.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

class TeamManagerScreen extends StatefulWidget {
  const TeamManagerScreen({super.key});

  @override
  State<TeamManagerScreen> createState() => _TeamManagerScreenState();
}

class _TeamManagerScreenState extends State<TeamManagerScreen> {
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    setState(() {
      isLoading = true;
    });

    AdminService as = AdminService();
    try {
      var values = await as.getAllAdminUsers();
      if (values != null) {
        debugPrint('values: $values');
        setState(() {
          users = values.cast<User>();
          isLoading = false;
        });
      } else {
        debugPrint('Error: Unexpected response type');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }

  void _showCreateAdminDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final TextEditingController passwordController =
            TextEditingController();
        final TextEditingController repeatPasswordController =
            TextEditingController();

        String firstName = '';
        String lastName = '';
        String email = '';
        bool _obscurePassword = true;
        bool _obscureRepeatPassword = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Create New Admin',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstName = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          lastName = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          } else if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                              .hasMatch(value)) {
                            return 'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: repeatPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Repeat Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: IconButton(
                              icon: Icon(
                                _obscureRepeatPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureRepeatPassword =
                                      !_obscureRepeatPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        obscureText: _obscureRepeatPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please repeat the password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.redAccent,
                    shadowColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _createAdminUser(
                          firstName, lastName, email, passwordController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.blue,
                    shadowColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createAdminUser(
      String firstName, String lastName, String email, String password) async {
    AdminUser newUser = AdminUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      profilePicture: '',
      bio: '',
      id: '',
      role: 'admin',
      password: password,
    );

    AdminService as = AdminService();
    try {
      await as.createAdminUser(newUser);
      getUsers();
    } catch (e) {
      _showErrorDialog('Failed to create admin user: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDetailsPressed(User user) {
    debugPrint('View details of user: ${user.firstName} ${user.lastName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: getUsers,
                      ),
                      ElevatedButton(
                        onPressed: _showCreateAdminDialog,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: Colors.blue,
                          shadowColor: Colors.blue,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          'Create New Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return UserCard(
                          user: users[index],
                          onDetailsPressed: _handleDetailsPressed,
                          badgeText: 'Admin',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
