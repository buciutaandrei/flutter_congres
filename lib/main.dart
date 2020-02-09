import 'package:congres_app/providers/appState.dart';
import 'package:congres_app/screens/sendFCMScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/schedules.dart';
import './screens/authenticationScreen.dart';
import './screens/customisedScreen.dart';
import './screens/fullProgramScreen.dart';
import './screens/mainScreen.dart';
import 'screens/scheduleDetails.dart';

void main() => runApp(
    ChangeNotifierProvider(create: (context) => AppState(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Schedules>(
          create: (context) => Schedules(),
          update: (context, auth, schedules) => Schedules(userId: auth.userId),
        ),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EFPT & AMRPR 2020',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            dividerColor: Colors.white,
            indicatorColor: Color(0xffFFDE73),
            accentColor: Color(0xffFFDE73),
          ),
          darkTheme: ThemeData.dark().copyWith(
              applyElevationOverlayColor: true,
              buttonTheme: ButtonThemeData(buttonColor: Colors.blueGrey)),
          themeMode: appState.themeMode,
          home: MainScreen(),
          routes: {
            AuthenticationScreen.routeName: (context) => AuthenticationScreen(),
            FullProgramScreen.routeName: (context) => FullProgramScreen(),
            CustomisedScreen.routeName: (context) => CustomisedScreen(),
            ScheduleDetails.routeName: (context) => ScheduleDetails(),
            SendFCMScreen.routeName: (context) => SendFCMScreen()
          },
        ),
      ),
    );
  }
}
