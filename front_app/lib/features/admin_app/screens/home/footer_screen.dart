import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';


class FooterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;

    return Container(
      color: background,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/app-logo.png',
                        height: 60,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Barassage',
                        style: TextStyle(
                          color: tertiary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Navigation links
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Notre mission', style: TextStyle(color: tertiary, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Fonctionnalités', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Blog', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Sécurité', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Pour les entreprises', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Utiliser Barasseur', style: TextStyle(color: tertiary, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Android', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('iPhone', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Besoin d\'aide ?', style: TextStyle(color: tertiary, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Nous contacter', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Télécharger', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Avis de sécurité', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align columns at the start
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Notre mission', style: TextStyle(color: tertiary, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Fonctionnalités', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Blog', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Sécurité', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Pour les entreprises', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Utiliser Barasseur', style: TextStyle(color: tertiary, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Android', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('iPhone', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Besoin d\'aide ?', style: TextStyle(color: tertiary, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Nous contacter', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Télécharger', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Avis de sécurité', style: TextStyle(color: tertiary.withOpacity(0.8))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              // Social media links and language selector
              if (isDesktop)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('© 2024 Barassage Inc.', style: TextStyle(color: tertiary)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: tertiary),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: tertiary),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.facebook, color: tertiary),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: tertiary),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: 'français',
                      dropdownColor: Color(0xFF0F2027),
                      icon: Icon(Icons.arrow_drop_down, color: tertiary),
                      items: <String>['français', 'english'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: tertiary)),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text('© 2024 Barassage Inc.', style: TextStyle(color: tertiary)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: tertiary),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: tertiary),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.facebook, color: tertiary),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: tertiary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: 'français',
                      dropdownColor: Color(0xFF0F2027),
                      icon: Icon(Icons.arrow_drop_down, color: tertiary),
                      items: <String>['français', 'english'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: tertiary)),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
