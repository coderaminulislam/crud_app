

import 'package:crud_app/add_product_screen.dart';
import 'package:crud_app/product_list_screen.dart';
import 'package:crud_app/update_product_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CrudApp());
}

class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,

      ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                fixedSize: const Size.fromWidth(double.maxFinite),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)
            ),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
          )
      ),
    );
  }
}


