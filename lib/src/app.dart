

import 'package:flutter/material.dart';
import 'package:flutter_application_restaurante/providers/ui_provider.dart';
import 'package:flutter_application_restaurante/src/balance_page.dart';
import 'package:flutter_application_restaurante/src/charts.dart';
import 'package:flutter_application_restaurante/src/inventario.dart';
import 'package:flutter_application_restaurante/widgets/home_wt/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

class MyAppForm extends StatefulWidget {
  const MyAppForm({super.key});

  @override
  State<MyAppForm> createState() => _MyAppFormState();
}

class _MyAppFormState extends State<MyAppForm> {
  

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      body: _HomePage(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      /*body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 90.0
        ),
        children: const <Widget> [
          Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100.0,
                backgroundColor: Color.fromARGB(255, 228, 104, 2),
                backgroundImage: AssetImage('images/logoRamada.png'),
              ),
              Text(
                'BIENVENIDO AL SISTEMA',
                style: TextStyle(
                  fontFamily: 'cursive',
                  fontSize: 30.0
                ),
              ),
              ],
          )
        ],
      ),
    */);
  }
}


class _HomePage extends StatelessWidget {
  const _HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    final currentIndex = uiProvider.bnbIndex;

    switch(currentIndex){
      case 0:
        return const BalancePage();
      case 1:
        return const InventarioPage();
      default:
      return const ChartsPage();
    }
  }
}