import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masrofe/models/transaction_model.dart';
import 'package:masrofe/moudles/home page/home_page_view.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
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
