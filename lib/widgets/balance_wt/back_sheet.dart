import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_restaurante/utils/constants.dart';
import 'package:http/http.dart' as http;

class BackSheet extends StatefulWidget {
  BackSheet({super.key});

  @override
  State<BackSheet> createState() => _BackSheetState();
}

class _BackSheetState extends State<BackSheet> {
  String ingreso = "";
  String venta = "";

  @override
  void initState() {
    super.initState();
    _obtenerDatosIngresos().then((value) {
      setState(() {
        ingreso = value;
      });
    }); // Llama a la función al inicializar el estado
    _obtenerDatosVentas().then((value) {
      setState(() {
        venta = value;
      });
    });// Llama a la función al inicializar el estado
  }

  Future<String> _obtenerDatosIngresos() async {
    final String apiUrl = 'http://192.118.101.15:8000/api/ingreso';
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    return response.body;
  }

  Future<String> _obtenerDatosVentas() async {
    final String apiUrl = 'http://192.118.101.15:8000/api/venta';
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    _headers(String name, String amount, Color color) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 13.0, bottom: 5.0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18.0,
                letterSpacing: 1.5,
                //color: Theme.of(context).cardColor
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 20.0, letterSpacing: 1.5, color: color),
            //color: Theme.of(context).cardColor),
          )
        ],
      );
    }

    return Container(
      height: 250.0,
      decoration:
          Constants.sheetBoxDecoration(Theme.of(context).primaryColorDark),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _headers('Ingresos', 'S/.${venta}', Color.fromARGB(255, 0, 255, 8)),
          const VerticalDivider(
            thickness: 2.0,
          ),
          _headers('Gastos', 'S/.${ingreso}', Color.fromARGB(255, 255, 21, 0))
        ],
      ),
    );
  }
}
