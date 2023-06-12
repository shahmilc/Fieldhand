import 'package:fieldhand/central/dashboard.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/computation/screen_router.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen() : super();
  
  final String routeName = "LoadingScreen";
  
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      navigate(context: context, page: await findStartScreen(), direction: 'right', fromDrawer: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryRed(),
      body: Center(
        child: loadingIndicator(context: context, color: Colors.white, sizeFactor: 2, showLogo: true),
      ),
    );
  }
}