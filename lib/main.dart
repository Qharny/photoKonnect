import 'package:flutter/material.dart';
import 'package:photoconnect/app_color.dart';

void main(){
  runApp(const PhotoConnect());
}

class PhotoConnect extends StatelessWidget {
  const PhotoConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Photo Connect",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhotoConnect"),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          Icon(Icons.person)
        ],
      ),
      drawer: Drawer(),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 30,
              width: 10,
              decoration: BoxDecoration(
                color: AppColors.lightGray
              ),
            )
          ],
        ),
      ),
    );
  }
}
