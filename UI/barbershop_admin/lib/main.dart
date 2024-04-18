// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_build_context_synchronously
import 'package:barbershop_admin/providers/product_provider.dart';
import 'package:barbershop_admin/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/account_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/user_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/product_brand_provider.dart';
import 'providers/product_type_provider.dart';
import 'providers/service_provider.dart';
import 'screens/login_screen.dart';
import 'screens/navigation.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => ProductBrandProvider()),
      ChangeNotifierProvider(create: (_) => ProductTypeProvider()),
      ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Barbershop admin',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(57, 131, 120, 1),
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: const Color.fromRGBO(213, 178, 99, 1)),
          fontFamily: GoogleFonts.roboto().fontFamily,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 50),
              backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: Size(150, 50),
              foregroundColor: Color.fromRGBO(57, 131, 120, 1),
              side: BorderSide(
                color: Color.fromRGBO(57, 131, 120, 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
          ),
        ),
        initialRoute: '/login',
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          Navigation.routeName: (context) => const Navigation(),
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen()
        });
  }
}
