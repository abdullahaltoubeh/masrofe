import 'package:flutter/material.dart';
import 'package:masrofe/moudles/home page/home_page_view.dart';

void main() {
  runApp(const MasrofeApp());
}

class MasrofeApp extends StatelessWidget {
  const MasrofeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageView(),
    );
  }
}
