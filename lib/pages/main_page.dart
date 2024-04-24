import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/utilities/page_utilities/mainpage_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Gap(MediaQuery.of(context).size.width * 0.05),
              const Text(
                "Stoodee",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const Gap(40),
              const Text("Did you know...",
                  style: TextStyle(color: Colors.grey)),
              const Gap(5),
              buildFunFactBox(context: context),
              const Gap(30),
              const Text("Today's goal: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              const Gap(20),
              buildGaugeRow(context, LocalDbController().currentUser),
            ],
          ),
        ),
      ),
    );
  }
}
