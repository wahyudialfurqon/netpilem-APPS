import 'package:Netpilem/screens/detail_screen.dart';
import 'package:Netpilem/screens/home_screen.dart';
import 'package:Netpilem/screens/profile_screen.dart';
import 'package:Netpilem/screens/search_screen.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized(); 
   await SharedPrefHelper.init(); //Jika error SharedPreferences
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey
        )
      ),
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screen = [
    const HomeScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 255, 17, 0),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon:
          Icon(Icons.home),
          label: 'Home',
          ),
          BottomNavigationBarItem(icon:
          Icon(Icons.search),
          label: 'Search',
          ),
          BottomNavigationBarItem(icon:
          Icon(Icons.person),
          label: 'Profile',
          ),
        ],
      ),
      
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _scale = 0.9;
  double _opacity = 1.0;

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 500), (){
      setState(() {
        _scale = 1.2;
      });
    });

    super.initState(); // Fade out mulai
    Future.delayed(Duration (seconds: 4), (){
      setState(() {
        _opacity = 0.0;
      });
    });

    super.initState();
    Future.delayed(const Duration(seconds: 5), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOut,
          child: AnimatedScale(
            scale: _scale,
            duration: Duration(seconds: 1),
            curve: Curves.easeOut,
            child: Hero(
              tag: "LogoHero",
              child: Image.asset(
                'images/netLogo.png',
                width: 244,
                height: 244,
              ),
            ),
          ),
        ),
      ),
    );
  }
}