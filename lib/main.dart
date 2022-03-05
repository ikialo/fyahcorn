import 'package:flutter/material.dart';
import 'package:fyahcorn/changeNotifierProvider.dart';
import 'dbhelper.dart';
import 'list.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHandler().initializeDB();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderBudget>(
      create: (context)=> ProviderBudget(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Budget',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            debugShowCheckedModeBanner: false,
            home: ListScreen(),
          );
        }
      ),
    );
  }
}
