import 'package:flutter/material.dart';
import 'package:flutter_application_restaurante/providers/ui_provider.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {

    final uiProvider = Provider.of<UIProvider>(context);

    return BottomNavigationBar(
      currentIndex: uiProvider.bnbIndex,
      onTap: (int i) => uiProvider.bnbIndex = i,
      items: const [
        BottomNavigationBarItem(label: 'Balance', icon: Icon(Icons.account_balance_outlined)),
        BottomNavigationBarItem(label: 'Inventario', icon: Icon(Icons.inventory)),
        BottomNavigationBarItem(label: 'Gráficos', icon: Icon(Icons.bar_chart_outlined))
      ]
      );
  }
}