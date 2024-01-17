import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slim/main.dart';
import 'package:slim/services/firestore_database.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/home_screen.dart';
import 'package:slim/widgets/Dashboard/Screens/FoodRecommendationScreen/recommendation_input.dart';
import 'package:slim/widgets/Dashboard/Screens/my_account.dart';
import 'package:slim/widgets/Dashboard/Screens/my_drawer_header.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/dinner.dart';
import 'package:slim/widgets/Dashboard/Screens/steps_screen.dart';
import 'package:slim/widgets/Dashboard/Screens/WorkoutScreen/workout_screen.dart';
import 'package:slim/widgets/Dashboard/NavigationBloc/tab_bar_bloc.dart';
import 'package:slim/onboarding_screen/onboarding_screen1.dart';
import 'package:slim/themes/theme_ui.dart';
import 'package:slim/widgets/Dashboard/Screens/HomeScreen/food_detection_model.dart';


import 'Screens/favourites.dart';
import 'Screens/history.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  DatabaseService databaseService = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  late DateTime date;

  checkLogout() async {
    FirebaseAuth.instance.authStateChanges().listen((_user) {
      if (_user == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyApp()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    _CheckDate();
    super.initState();
  }

  _CheckDate() async {
    date = await getDate();

    // if date.month == currentDate.month && date.day == currentDate.day {

    if (date.month != DateTime.now().month || date.day != DateTime.now().day) {
      print("im in");
      databaseService.resetAllData(auth.currentUser!.uid);
      databaseService.updateDate(auth.currentUser!.uid, DateTime.now());
    }
  }

  getDate() async {
    return await databaseService.getDateFromFirestore(auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabBarBloc>(
      create: (BuildContext context) => TabBarBloc(0),
      child: BlocBuilder<TabBarBloc, int>(
        builder: (context, state) {
          final bloc = BlocProvider.of<TabBarBloc>(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Slim"),
            ),
            drawer: Container(
              width: 250,
              child: Drawer(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyHeaderDrawer(),
                      myDrawerList(),
                    ],
                  ),
                ),
              ),
            ),
             //return the index of the screen i want to route
            backgroundColor: Colors.white,
            bottomNavigationBar: _createdBottomTabBar(context),
          );
        },
      ),
    );
  }

  Widget myDrawerList() {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("My Account"),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyAccountScreen()));
          },
        ),

        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Sign Out"),
          onTap: () {
            auth.signOut();
            checkLogout();
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_a_photo),
          title: const Text("Slim detection"),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FoodDetectionModel()));
          },
        ),
      ],
    );
  }
  int _currenttIndex = 0;
  List<Widget> _widgetOptions= <Widget>
  [
    HomePage(),
    StepsScreen(),
    const WorkoutsPage(),
    Screen1(),
    Recipes()];
  Widget _createdBottomTabBar(BuildContext context) {

    final bloc = BlocProvider.of<TabBarBloc>(context);
    return Scaffold(
      body:_widgetOptions.elementAt(_currenttIndex) ,
      bottomNavigationBar: BottomNavigationBar(

      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/dashboard/home.png',
            scale: 2.6,
          ),
          label: "Home",


        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/dashboard/shoe.png',
            scale: 2,
          ),
          label: 'Steps',
        
        ),
        
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/dashboard/workout.png',
            scale: 2.6,
          ),
          label: 'Workout',

        ),
        BottomNavigationBarItem(
          icon: Image.asset(

            'assets/dashboard/geofence.png',
            scale: 2.6,
          ),
          label: 'WaterRemainder',

        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/dashboard/food_recommendation.png',
            scale: 2,
          ),
            label:'Recipes',
        ),
      ],

      selectedLabelStyle: FitnessAppTheme.navScreen,
      fixedColor: Colors.green,
      onTap: _changeItem,
       currentIndex:_currenttIndex ,
      unselectedItemColor:Colors.grey ,
    ),
    );
  }

 /* Widget _createBody(BuildContext context, int index) {
    final children = [
      HomePage(),
      StepsScreen(),
      const WorkoutsPage(),
      const FoodRecommendationScreen()
    ];
    return children[index];
  }*/
  void _changeItem(int value)
  {
    setState(() {
      _currenttIndex = value;
    });
  }
}
