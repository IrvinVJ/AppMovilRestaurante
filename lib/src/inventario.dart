import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class InventarioPage extends StatefulWidget {
  const InventarioPage({Key? key}) : super(key: key);

  @override
  _InventarioPageState createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  List<Producto> _productos = [];

  Future<void> _fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.118.101.15:8000/api/producto'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _productos = (jsonData as List)
            .map((item) => Producto.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        domainFn: (Producto producto, _) => producto.nombreProducto,
        measureFn: (Producto producto, _) => producto.stock,
        id: 'Stock',
        data: _productos,
      ),
    ];

    var chart = charts.BarChart(
      series,
      vertical: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Inventario'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400,
                Colors.green.shade400,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gráfico Productos vs Stock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 700,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(20),
                    minScale: 0.1,
                    maxScale: 5.0,
                    constrained: true,
                    child: _productos.isNotEmpty
                        ? chart
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Tabla de Productos vs Stock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                _productos.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Producto',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Stock',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            rows: _productos.map((producto) {
                              return DataRow(cells: [
                                DataCell(
                                  Text(
                                    producto.nombreProducto,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    producto.stock.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Producto {
  final String nombreProducto;
  final int stock;

  Producto({required this.nombreProducto, required this.stock});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      nombreProducto: json['NombreProducto'],
      stock: json['Stock'],
    );
  }
}
