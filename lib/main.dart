import 'package:flutter/material.dart';
import 'package:note/models/note_database.dart';
import 'package:note/pages/note_page.dart';
import 'package:note/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // INIT THE DB
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
