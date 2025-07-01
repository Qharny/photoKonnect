import 'dart:io';

void main() {
  final directories = [
    'lib/auth',
    'lib/models',
    'lib/screens/auth',
    'lib/screens/client',
    'lib/screens/photographer',
    'lib/widgets',
    'lib/services',
    'lib/controllers',
    'lib/utils',
    'lib/routes',
    'lib/theme',
  ];

  for (var dir in directories) {
    final directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      print('✅ Created: $dir');
    } else {
      print('⚠️ Already exists: $dir');
    }
  }

  final files = {
    'lib/main.dart': '''
import 'package:flutter/material.dart';

void main() {
  runApp(const PhotoConnectApp());
}

class PhotoConnectApp extends StatelessWidget {
  const PhotoConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Placeholder(), // Replace with actual home screen
    );
  }
}
''',
    'lib/routes/app_routes.dart': '// Define your named routes here',
    'lib/theme/app_theme.dart': '// Define color schemes and text styles',
    'lib/utils/constants.dart': '// Define constants (e.g., image paths, URLs)',
    'lib/services/supabase_service.dart': '// Handle Supabase integration here',
  };

  files.forEach((path, content) {
    final file = File(path);
    if (!file.existsSync()) {
      file.writeAsStringSync(content);
      print('📄 Created: $path');
    } else {
      print('⚠️ File already exists: $path');
    }
  });

  print('\n🎉 Project structure generated successfully!');
}
