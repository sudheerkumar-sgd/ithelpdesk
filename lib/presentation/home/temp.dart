import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sample();
  }
}

class Sample extends StatelessWidget {
  const Sample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: SideMenu(),
        // use new MaterialApp to push new (sub)screens on top of that area and preserve the same drawer
        body: MaterialApp(
          navigatorKey: navigatorKey,
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Text('Home screen')),
      ),
    );
  }
}

class SideMenu extends Drawer {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(child: Icon(Icons.android)),
          SideMenuItem(
              title: 'dashboard',
              leadingIcon: Icons.dashboard,
              press: () {
                Navigator.push(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()));
              }),
          SideMenuItem(
              title: 'users',
              leadingIcon: Icons.person,
              press: () {
                Navigator.push(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                        builder: (context) => const UserScreen()));
              }),
        ],
      ),
    );
  }
}

class SideMenuItem extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final Function() press;

  const SideMenuItem({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.press,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      onTap: press,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: Center(child: Text('Dashboard screen')),
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(child: Text('User screen')),
      ),
    );
  }
}
