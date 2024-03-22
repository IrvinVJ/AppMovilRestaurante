import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_restaurante/utils/constants.dart';
import 'package:http/http.dart' as http;

class FrontSheet extends StatefulWidget {
  const FrontSheet({super.key});

  @override
  State<FrontSheet> createState() => _FrontSheetState();
}

class _FrontSheetState extends State<FrontSheet> {
  //Código para dashboard
  String usuarios = "";
  double _usuarios = 0;
  String compras = "";
  double _compras = 0;
  String ventas = "";
  double _ventas = 0;
  String mesas = "";
  double _mesas = 0;
  String pedidos = "";
  double _pedidos = 0;
  String reservaciones = "";
  double _reservaciones = 0;
  String clientes = "";
  double _clientes = 0;
  String platos = "";
  double _platos = 0;

  Future<String> _obtenerDatosDashboard() async {
    final String apiUrl = 'http://192.118.101.15:8000/api/dashboard';
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    return response.body;
  }

  @override
  void initState() {
    super.initState();
    _obtenerDatosDashboard().then((value) {
      setState(() {
        // Parse the JSON response and update the variables accordingly
        final data = json.decode(value);
        usuarios = data['Usuarios'].toString();
        _usuarios = double.parse(usuarios);

        compras = data['Ingresos'].toString();
        _compras = double.parse(compras);

        ventas = data['Ventas'].toString();
        _ventas = double.parse(ventas);

        mesas = data['Mesas'].toString();
        _mesas = double.parse(mesas);

        pedidos = data['Pedidos'].toString();
        _pedidos = double.parse(pedidos);

        reservaciones = data['Reservaciones'].toString();
        _reservaciones = double.parse(reservaciones);

        clientes = data['Clientes'].toString();
        _clientes = double.parse(clientes);

        platos = data['Platos'].toString();
        _platos = double.parse(platos);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _list = List.generate(
        1,
        (i) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height: 610.0,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color.fromARGB(255, 52, 49, 248), Color.fromARGB(255, 101, 238, 101)],
                    ),
                    //color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(30.0)),
                child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      DashboardTile(label: 'Usuarios', value: _usuarios, icon: Icons.people),
                      DashboardTile(label: 'Compras', value: _compras, icon: Icons.shopping_cart),
                      DashboardTile(label: 'Ventas', value: _ventas, icon: Icons.monetization_on),
                      DashboardTile(label: 'Mesas', value: _mesas, icon: Icons.table_chart),
                      DashboardTile(label: 'Pedidos', value: _pedidos, icon: Icons.assignment),
                      DashboardTile(label: 'Reservaciones', value: _reservaciones, icon: Icons.event_available),
                      DashboardTile(label: 'Clientes', value: _clientes, icon: Icons.person),
                      DashboardTile(label: 'Platos', value: _platos, icon: Icons.restaurant)
                      //Código para dashboard
                      /*DashboardWidget(label: 'Usuarios', value: _usuarios),
                  DashboardWidget(label: 'Compras', value: _compras),
                  DashboardWidget(label: 'Ventas', value: _ventas),
                  DashboardWidget(label: 'Mesas', value: _mesas),
                  DashboardWidget(label: 'Pedidos', value: _pedidos),
                  DashboardWidget(
                      label: 'Reservaciones', value: _reservaciones),
                  DashboardWidget(label: 'Clientes', value: _clientes),
                  DashboardWidget(label: 'Platos', value: _platos),*/
                    ]))));

    return Container(
      //height: 800.0,
      decoration: Constants.sheetBoxDecoration(
          Theme.of(context).scaffoldBackgroundColor),
      //child: Image.asset('images/logoRamada.png'),
      child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _list),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;

  const DashboardTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}


/*class DashboardWidget extends StatelessWidget {
  final String label;
  final double value;

  const DashboardWidget({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value.toString()),
    );
  }
}
*/