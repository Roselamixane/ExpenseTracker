// import 'package:app/view/pages/Budget-tab.dart';
// import 'package:app/view/pages/Summary-tab.dart';
// import 'package:app/view/pages/Transactions-tab.dart';
// import 'package:app/view/pages/home-screen.dart';
// import 'package:app/view/pages/start-screen.dart';
// import 'package:app/view/pages/transaction-datadisplay-tab.dart';
// import 'package:flutter/material.dart';

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     //final args1 = settings.arguments;
//     final args2 = [];

//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (context) => const StartScreen());
//       case '/Home':
//         return MaterialPageRoute(builder: (context) => const HomeScreen());
//       case '/Summary':
//         return MaterialPageRoute(builder: (context) => SummaryTab());
//       case '/Transaction':
//         return MaterialPageRoute(builder: (context) => const TransactionTab());
//       case '/Budget':
//         return MaterialPageRoute(builder: (context) => const BudgetTab());
//       case '/TransactionData':
//         return MaterialPageRoute(
//             builder: (context) => TransactionData(
//                   data: [],
//                   account: args2, selectedTotal: null, selectedMonth: null, , selectedYear: '',
//                 ));
//       default:
//         return _errorRoute();
//     }
//   }

//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(builder: (context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('ERROR'),
//         ),
//         body: const Center(
//           child: Text('ERROR'),
//         ),
//       );
//     });
//   }
// }
