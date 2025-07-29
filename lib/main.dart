import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_app/pages/home/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tutor_app/styles/colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080,2220),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Study Buddy',
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarySage,
              secondary: AppColors.lightSage,
              tertiary: AppColors.accentGreen,
              onPrimary: AppColors.textLight,
              onSecondary: AppColors.textDark,
              onTertiary: AppColors.textLight,
              background: AppColors.backgroundLight,
            ),
            scaffoldBackgroundColor: AppColors.backgroundLight,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primarySage,
              foregroundColor: AppColors.textLight,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: AppColors.textLight,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: AppColors.textDark,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(
                color: AppColors.textDark,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: TextStyle(
                color: AppColors.textDark,
                fontSize: 16.sp,
              ),
              bodyMedium: TextStyle(
                color: AppColors.textDark,
                fontSize: 14.sp,
              ),
            ),
            useMaterial3: true,
          ),
          home: Homepage(),
        );
      }
    );
  }
}

