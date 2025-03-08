// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jwt_decode/jwt_decode.dart';

// //screens
// import './event_list_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final List<String> eventImages = [
//     'assets/images/events/corporate_event.png',
//     'assets/images/events/sports_event.png',
//     'assets/images/events/seminars.png',
//     'assets/images/events/wedding.png',
//     'assets/images/events/exhibition.png',
//     'assets/images/events/family_events.png',
//   ];

//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // Login function to handle authentication
//   Future<void> login(BuildContext context) async {
//     const String apiUrl =
//         "http://192.168.0.108:5000/api/auth/login"; // Replace with your backend URL

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "username": usernameController.text,
//           "password": passwordController.text,
//         }),
//       );

//       print("Response Status: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final token = data['token'];
//         Map<String, dynamic> payload = Jwt.parseJwt(token);
//         final role = payload['role'];

//         // Save the token and role in SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token);
//         await prefs.setString('user_role', role);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Login Successful!")),
//         );

//         // Navigate to EventListScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const EventListScreen()),
//         );
//       } else {
//         final data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? "Invalid credentials")),
//         );
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("An error occurred. Please try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               // Logo Section
//               Container(
//                 margin: const EdgeInsets.only(top: 20, bottom: 10),
//                 child: FadeInDown(
//                   duration: const Duration(milliseconds: 800),
//                   child: Image.asset(
//                     'assets/images/logo.png', // Replace with the correct logo path
//                     height: 80,
//                   ),
//                 ),
//               ),
//               // Image Carousel Section
//               SizedBox(
//                 height: 280,
//                 child: CarouselSlider(
//                   options: CarouselOptions(
//                     height: 280.0,
//                     autoPlay: true,
//                     autoPlayInterval: const Duration(seconds: 3),
//                     enlargeCenterPage: true,
//                     enableInfiniteScroll: true,
//                   ),
//                   items: eventImages.map((imagePath) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             image: DecorationImage(
//                               image: AssetImage(imagePath),
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                           margin: const EdgeInsets.symmetric(horizontal: 10),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // Login Title Section
//               FadeInUp(
//                 duration: const Duration(milliseconds: 1200),
//                 child: const Text(
//                   "Login",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1475BC),
//                   ),
//                 ),
//               ),
//               // Login UI Section
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: <Widget>[
//                     // Input Fields
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 1800),
//                       child: Container(
//                         padding: const EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: const Color(0xFF1475BC),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF1475BC).withOpacity(0.2),
//                               blurRadius: 20.0,
//                               offset: const Offset(0, 10),
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               padding: const EdgeInsets.all(8.0),
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                     color: Color(0xFF1475BC),
//                                   ),
//                                 ),
//                               ),
//                               child: TextField(
//                                 controller: usernameController,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Email/Username",
//                                   hintStyle: TextStyle(color: Colors.grey[700]),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(8.0),
//                               child: TextField(
//                                 controller: passwordController,
//                                 obscureText: true,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Password",
//                                   hintStyle: TextStyle(color: Colors.grey[700]),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     // Login Button
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 1900),
//                       child: GestureDetector(
//                         onTap: () => login(context),
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             gradient: LinearGradient(
//                               colors: [
//                                 const Color(0xFF1475BC),
//                                 const Color(0xFF1475BC).withOpacity(0.6),
//                               ],
//                             ),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Login",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     // Contact Us Text
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 2000),
//                       child: const Text(
//                         "Contact us?",
//                         style: TextStyle(
//                           color: Color(0xFF1475BC),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// new code
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jwt_decode/jwt_decode.dart';

// //screens
// import './event_list_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final List<String> eventImages = [
//     'assets/images/events/corporate_event.png',
//     'assets/images/events/sports_event.png',
//     'assets/images/events/seminars.png',
//     'assets/images/events/wedding.png',
//     'assets/images/events/exhibition.png',
//     'assets/images/events/family_events.png',
//   ];

//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> login(BuildContext context) async {
//     const String apiUrl = "http://192.168.0.108:5000/api/auth/login";

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "username": usernameController.text,
//           "password": passwordController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final token = data['token'];
//         Map<String, dynamic> payload = Jwt.parseJwt(token);
//         final role = payload['role'];

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token);
//         await prefs.setString('user_role', role);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Login Successful!")),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const EventListScreen()),
//         );
//       } else {
//         final data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? "Invalid credentials")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("An error occurred. Please try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 // Logo Section
//                 Container(
//                   margin: const EdgeInsets.only(top: 20, bottom: 10),
//                   child: FadeInDown(
//                     duration: const Duration(milliseconds: 800),
//                     child: Image.asset(
//                       'assets/images/logo.png',
//                       height: 80,
//                     ),
//                   ),
//                 ),
//                 // Image Carousel Section
//                 SizedBox(
//                   height: 280,
//                   child: CarouselSlider(
//                     options: CarouselOptions(
//                       height: 280.0,
//                       autoPlay: true,
//                       autoPlayInterval: const Duration(seconds: 3),
//                       enlargeCenterPage: true,
//                       enableInfiniteScroll: true,
//                     ),
//                     items: eventImages.map((imagePath) {
//                       return Builder(
//                         builder: (BuildContext context) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               image: DecorationImage(
//                                 image: AssetImage(imagePath),
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                             margin: const EdgeInsets.symmetric(horizontal: 10),
//                           );
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 FadeInUp(
//                   duration: const Duration(milliseconds: 1200),
//                   child: const Text(
//                     "Login",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1475BC),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: <Widget>[
//                       FadeInUp(
//                         duration: const Duration(milliseconds: 1800),
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: const Color(0xFF1475BC)),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0xFF1475BC).withOpacity(0.2),
//                                 blurRadius: 20.0,
//                                 offset: const Offset(0, 10),
//                               )
//                             ],
//                           ),
//                           child: Column(
//                             children: <Widget>[
//                               Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 decoration: const BoxDecoration(
//                                   border: Border(
//                                     bottom:
//                                         BorderSide(color: Color(0xFF1475BC)),
//                                   ),
//                                 ),
//                                 child: TextField(
//                                   controller: usernameController,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "Email/Username",
//                                     hintStyle:
//                                         TextStyle(color: Colors.grey[700]),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextField(
//                                   controller: passwordController,
//                                   obscureText: true,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "Password",
//                                     hintStyle:
//                                         TextStyle(color: Colors.grey[700]),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       FadeInUp(
//                         duration: const Duration(milliseconds: 1900),
//                         child: GestureDetector(
//                           onTap: () => login(context),
//                           child: Container(
//                             height: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               gradient: LinearGradient(
//                                 colors: [
//                                   const Color(0xFF1475BC),
//                                   const Color(0xFF1475BC).withOpacity(0.6),
//                                 ],
//                               ),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Login",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//////////////////
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jwt_decode/jwt_decode.dart';

// // Screens
// import './event_list_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final List<String> eventImages = [
//     'assets/images/events/corporate_event.png',
//     'assets/images/events/sports_event.png',
//     'assets/images/events/seminars.png',
//     'assets/images/events/wedding.png',
//     'assets/images/events/exhibition.png',
//     'assets/images/events/family_events.png',
//   ];

//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> login(BuildContext context) async {
//     const String apiUrl = "http://192.168.0.108:5000/api/auth/login";

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "username": usernameController.text.trim(),
//           "password": passwordController.text.trim(),
//         }),
//       );

//       // Debugging: Print response details
//       print("Response Status: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         try {
//           final data = jsonDecode(response.body);

//           // Ensure token exists before proceeding
//           if (!data.containsKey('token') || data['token'] == null) {
//             throw Exception("Token not found in response.");
//           }

//           final token = data['token'];
//           Map<String, dynamic> payload = Jwt.parseJwt(token);
//           final role = payload['role'];

//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('auth_token', token);
//           await prefs.setString('user_role', role);

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Login Successful!")),
//           );

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const EventListScreen()),
//           );
//         } catch (e) {
//           print("JSON Parsing Error: $e");
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Invalid server response.")),
//           );
//         }
//       } else {
//         final data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? "Invalid credentials")),
//         );
//       }
//     } catch (e) {
//       print("Network/Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("An error occurred. Please try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               // Logo Section
//               Container(
//                 margin: const EdgeInsets.only(top: 20, bottom: 10),
//                 child: FadeInDown(
//                   duration: const Duration(milliseconds: 800),
//                   child: Image.asset(
//                     'assets/images/logo.png',
//                     height: 80,
//                   ),
//                 ),
//               ),
//               // Image Carousel Section
//               SizedBox(
//                 height: 280,
//                 child: CarouselSlider(
//                   options: CarouselOptions(
//                     height: 280.0,
//                     autoPlay: true,
//                     autoPlayInterval: const Duration(seconds: 3),
//                     enlargeCenterPage: true,
//                     enableInfiniteScroll: true,
//                   ),
//                   items: eventImages.map((imagePath) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             image: DecorationImage(
//                               image: AssetImage(imagePath),
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                           margin: const EdgeInsets.symmetric(horizontal: 10),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               FadeInUp(
//                 duration: const Duration(milliseconds: 1200),
//                 child: const Text(
//                   "Login",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1475BC),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: <Widget>[
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 1800),
//                       child: Container(
//                         padding: const EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: const Color(0xFF1475BC)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF1475BC).withOpacity(0.2),
//                               blurRadius: 20.0,
//                               offset: const Offset(0, 10),
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               padding: const EdgeInsets.all(8.0),
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(color: Color(0xFF1475BC)),
//                                 ),
//                               ),
//                               child: TextField(
//                                 controller: usernameController,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Email/Username",
//                                   hintStyle: TextStyle(color: Colors.grey[700]),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(8.0),
//                               child: TextField(
//                                 controller: passwordController,
//                                 obscureText: true,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   hintText: "Password",
//                                   hintStyle: TextStyle(color: Colors.grey[700]),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 1900),
//                       child: GestureDetector(
//                         onTap: () => login(context),
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             gradient: LinearGradient(
//                               colors: [
//                                 const Color(0xFF1475BC),
//                                 const Color(0xFF1475BC).withOpacity(0.6),
//                               ],
//                             ),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "Login",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//////////////
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:url_launcher/url_launcher.dart';

// Screens
import './event_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> eventImages = [
    'assets/images/events/corporate_event.png',
    'assets/images/events/sports_event.png',
    'assets/images/events/seminars.png',
    'assets/images/events/wedding.png',
    'assets/images/events/exhibition.png',
    'assets/images/events/family_events.png',
  ];

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    const String apiUrl = "http://192.168.0.108:5000/api/auth/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": usernameController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      // Debugging: Print response details
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          // Ensure token exists before proceeding
          if (!data.containsKey('token') || data['token'] == null) {
            throw Exception("Token not found in response.");
          }

          final token = data['token'];
          Map<String, dynamic> payload = Jwt.parseJwt(token);
          final role = payload['role'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_role', role);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Successful!")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EventListScreen()),
          );
        } catch (e) {
          print("JSON Parsing Error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid server response.")),
          );
        }
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Invalid credentials")),
        );
      }
    } catch (e) {
      print("Network/Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  void _showEventsNationDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "EventsNation Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final url = 'https://eventsnation.in';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    "Website: https://eventsnation.in/",
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Contact Info: +91 8779671014",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Email Info: info@eventsnation.com",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Logo Section
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                    width: 250,
                  ),
                ),
              ),
              // Image Carousel Section
              SizedBox(
                height: 280,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 280.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                  ),
                  items: eventImages.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.fill,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1475BC),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1475BC)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1475BC).withOpacity(0.2),
                              blurRadius: 20.0,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: "Email/Username",
                                labelStyle:
                                    const TextStyle(color: Colors.blueAccent),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1475BC)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle:
                                    const TextStyle(color: Colors.blueAccent),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF1475BC)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: GestureDetector(
                        onTap: () => login(context),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF1475BC),
                                const Color(0xFF1475BC).withOpacity(0.6),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      duration: const Duration(milliseconds: 2000),
                      child: GestureDetector(
                        onTap: _showEventsNationDetails,
                        child: Text(
                          "Don't have an account? Contact us",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
