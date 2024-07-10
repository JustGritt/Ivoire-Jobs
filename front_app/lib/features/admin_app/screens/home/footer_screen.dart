import 'package:flutter/material.dart';

class FooterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;

    return Container(
      color: Color(0xFF0F2027),
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
                        'assets/images/app-logo.png', // Your logo here
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Barassage', // Replace with your app name
                        style: TextStyle(
                          color: Colors.white,
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
                  crossAxisAlignment: CrossAxisAlignment.start, // Align columns at the top
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Notre mission', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Fonctionnalités', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Blog', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Sécurité', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Pour les entreprises', style: TextStyle(color: Colors.white70)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Utiliser Barasseur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Android', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('iPhone', style: TextStyle(color: Colors.white70)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Besoin d\'aide ?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Nous contacter', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Télécharger', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Avis de sécurité', style: TextStyle(color: Colors.white70)),
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
                          Text('Notre mission', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Fonctionnalités', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Blog', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Sécurité', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Pour les entreprises', style: TextStyle(color: Colors.white70)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Utiliser Barasseur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Android', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('iPhone', style: TextStyle(color: Colors.white70)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text('Besoin d\'aide ?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {},
                            child: Text('Nous contacter', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Télécharger', style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Avis de sécurité', style: TextStyle(color: Colors.white70)),
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
                    Text('© 2024 Barassage Inc.', style: TextStyle(color: Colors.white54)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.facebook, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: Colors.white),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: 'français',
                      dropdownColor: Color(0xFF0F2027),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: <String>['français', 'english'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('© 2024 Barassage Inc.', style: TextStyle(color: Colors.white54)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.facebook, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.screen_lock_landscape, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: 'français',
                      dropdownColor: Color(0xFF0F2027),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: <String>['français', 'english'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.white)),
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
