import 'package:barassage_app/features/lead_mod/lead_mod.dart';
import 'package:barassage_app/core/core.dart';
import 'package:flutter/material.dart';

class SearchForMobile extends StatelessWidget {
  const SearchForMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: searchBarTitle(),
        ),
        actions: actionsMenu(context),
      ),
      bottomNavigationBar: LeadAppBottomBar(),
    );
  }

  TextFormField searchBarTitle() {
    return TextFormField(
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        prefixStyle: TextStyle(color: Colors.white),
        labelText: 'Search...',
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'Input the name';
        }
        return null;
      },
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.amber),
    );
  }
}
