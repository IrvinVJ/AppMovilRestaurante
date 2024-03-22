import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_restaurante/widgets/balance_wt/back_sheet.dart';
import 'package:flutter_application_restaurante/widgets/balance_wt/front_sheet.dart';
import 'package:http/http.dart' as http;

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final _scrollController = ScrollController();
  double _offset = 0;
  String ingreso = "";
  double _ing = 0;
  String venta = "";
  double _vent = 0;
  

  void _listener() {
    setState(() {
      _offset = _scrollController.offset / 100;
    });
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
  void initState() {
    _scrollController.addListener(_listener);
    _max;
    super.initState();
    _obtenerDatosIngresos().then((value) {
      setState(() {
        ingreso = value;
        _ing = double.parse(ingreso);
      });
    }); // Llama a la función al inicializar el estado
    _obtenerDatosVentas().then((value) {
      setState(() {
        venta = value;
        _vent = double.parse(venta);
      });
    });
    
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listener);
    _scrollController.dispose();
    super.dispose();
  }

  double get _max => max(90 - _offset * 90, 0.0);

  //convierte string a double?

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          elevation: 0.0,
          expandedHeight: 120.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (_vent - _ing).toString(),
                  style: const TextStyle(
                      fontSize: 30.0, color: Color.fromARGB(255, 47, 0, 255)),
                ),
                const Text(
                  'Balance',
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                  //Crea un boton que consuma una funcion?
                ),
              ],
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Stack(
            children: [
              BackSheet(),
              Padding(
                padding: EdgeInsets.only(top: _max),
                child: const FrontSheet(),
              )
            ],
          ),
          
        ]))
      ],
    );
  }
}


