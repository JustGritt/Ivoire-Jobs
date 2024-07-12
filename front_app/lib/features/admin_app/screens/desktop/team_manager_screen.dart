import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/models/admin_user.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

class TeamManagerScreen extends StatefulWidget {
  const TeamManagerScreen({super.key});

  @override
  State<TeamManagerScreen> createState() => _TeamManagerScreenScreenState();
}

class _TeamManagerScreenScreenState extends State<TeamManagerScreen> {
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

  Color _getBadgeColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  DataRow _userDataRow(User user) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              user.profilePicture.isNotEmpty
                  ? CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(user.profilePicture),
                    )
                  : CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Text(
                        '${user.lastName[0]}${user.firstName[0]}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(user.email)),
      ],
    );
  }

  void _showCreateAdminDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final TextEditingController passwordController = TextEditingController();
        final TextEditingController repeatPasswordController = TextEditingController();

        String firstName = '';
        String lastName = '';
        String email = '';
        bool _obscurePassword = true;
        bool _obscureRepeatPassword = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create New Admin'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'First Name'),
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
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Last Name'),
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
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
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
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
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
                      TextFormField(
                        controller: repeatPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Repeat Password',
                          suffixIcon: IconButton(
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _createAdminUser(firstName, lastName, email,
                            passwordController.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Create'),
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                            child: const Text('Create New Admin'),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 32.0,
                          dataRowHeight: 70.0,
                          columns: const [
                            DataColumn(
                              label: Text("Name"),
                            ),
                            DataColumn(
                              label: Text("Email"),
                            ),
                          ],
                          rows: List.generate(
                            users.length,
                            (index) => _userDataRow(users[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
