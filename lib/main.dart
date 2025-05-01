import 'package:app/data/model/Budget.dart';
import 'package:app/data/model/Finance.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/pages/start-screen.dart';
import 'package:app/view/pages/auth.dart'; // Import the Auth page
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
import 'package:app/view/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapter(FinanceAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(UserdataAdapter());

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box financeBox;
  late Box budgetBox;
  late Box userDataBox;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    openBoxes();
  }

  Future<void> openBoxes() async {
    financeBox = await Hive.openBox('Finance');
    budgetBox = await Hive.openBox('Budget');
    userDataBox = await Hive.openBox('User');

    // Once the boxes are opened, remove the splash screen.
    FlutterNativeSplash.remove();
    setState(() {}); // Trigger rebuild once boxes are loaded
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => summaryProvider()),
        ChangeNotifierProvider(create: (context) => transactionProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light().copyWith(
              textTheme: GoogleFonts.libreCaslonTextTextTheme(),
            ),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: GoogleFonts.libreCaslonTextTextTheme(),
            ),
            home: financeBox.isOpen && budgetBox.isOpen && userDataBox.isOpen
                ? (userDataBox.get('user') == null
                ? const Auth() // Show Auth page if no user is logged in
                : const StartScreen()) // Show StartScreen if user exists
                : const Scaffold(), // Display a blank screen while boxes are loading
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    financeBox.close();
    budgetBox.close();
    userDataBox.close();
    super.dispose();
  }
}
