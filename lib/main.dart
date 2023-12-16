import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:workshop/provider/auth_provider.dart';
import 'package:workshop/provider/home_items_provider.dart';
import 'package:workshop/provider/home_services_provider.dart';
import 'package:workshop/provider/profile_provider.dart';
import 'package:workshop/provider/subscription_provider.dart';
import 'package:workshop/provider/user_bookings_provider.dart';
import 'package:workshop/provider/user_cart_provider.dart';
import 'package:workshop/provider/user_complain_provider.dart';
import 'package:workshop/provider/user_order_provider.dart';
import 'package:workshop/provider/users_provider.dart';
import 'package:workshop/provider/vehicles_provider.dart';
import 'package:workshop/provider/workshop_bookings_provider.dart';
import 'package:workshop/provider/workshop_details_provider.dart';
import 'package:workshop/provider/workshop_items_provider.dart';
import 'package:workshop/provider/workshop_order_provider.dart';
import 'package:workshop/provider/workshops_provider.dart';
import 'package:workshop/screen/packages_screen.dart';
import 'package:workshop/screen/splash_screen.dart';
import 'package:workshop/utils/color_resources.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
late final FirebaseDatabase firebaseDatabase;
late final FirebaseStorage firebaseStorage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB6LiATre3dtv3bkSkt3cXAmERygu6vDWE",
      appId: "1:27283240093:android:ce66b2e716636fd6fe5074",
      messagingSenderId: "27283240093",
      projectId: "wanasah-splash",
    ),
  );
  auth = FirebaseAuth.instance;
  firebaseDatabase = FirebaseDatabase.instance;
  firebaseStorage = FirebaseStorage.instance;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => WorkShopsItemsProvider(
            databaseReference: firebaseDatabase.ref("Items")),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            HomeItemsProvider(databaseReference: firebaseDatabase.ref("Items")),
      ),
      ChangeNotifierProvider(
        create: (context) => UserBookingsProvider(
            databaseReference: firebaseDatabase.ref("Bookings")),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            UserCartProvider(databaseReference: firebaseDatabase.ref("Carts")),
      ),
      ChangeNotifierProvider(
        create: (context) => UserOrderProvider(
            databaseReference: firebaseDatabase.ref("Orders")),
      ),
      ChangeNotifierProvider(
        create: (context) => WorkshopOrderProvider(
            databaseReference: firebaseDatabase.ref("Orders")),
      ),
      ChangeNotifierProvider(
        create: (context) => UserComplainProvider(
            databaseReference: firebaseDatabase.ref("Complaints")),
      ),
      ChangeNotifierProvider(
        create: (context) => HomeServicesProvider(
            databaseReference: firebaseDatabase.ref("Service_Schedules")),
      ),
      ChangeNotifierProvider(
        create: (context) => WorkshopDetailsProvider(
            itemsReference: firebaseDatabase.ref("Items"),
            scheduleReference: firebaseDatabase.ref("Service_Schedules")),
      ),
      ChangeNotifierProvider(
        create: (context) => WorkshopBookingsProvider(
            databaseReference: firebaseDatabase.ref("Bookings")),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            WorkshopsProvider(databaseReference: firebaseDatabase.ref("Users")),
      ),
      ChangeNotifierProvider(
        create: (context) => VehiclesProvider(
            databaseReference: firebaseDatabase.ref("Service_Schedules")),
      ),
      ChangeNotifierProvider(
        create: (context) => ProfileProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            UsersProvider(databaseReference: firebaseDatabase.ref("Users")),
      ),
      ChangeNotifierProvider(
        create: (context) =>
            SubscriptionProvider(databaseReference: firebaseDatabase.ref("Subscriptions")),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: ColorResources.PRIMARY_MATERIAL,
      ),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
