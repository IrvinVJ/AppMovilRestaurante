import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key}) : super(key: key);

  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  List<Plato> _platos = [];
  List<AtencionDiaria> _atencionesDiarias = [];

  Future<void> _fetchData() async {
    final platosResponse =
        await http.get(Uri.parse('http://192.118.101.15:8000/api/demandaplatos'));
    final atencionesResponse =
        await http.get(Uri.parse('http://192.118.101.15:8000/api/atencionesdiarias'));

    if (platosResponse.statusCode == 200 && atencionesResponse.statusCode == 200) {
      final platosData = json.decode(platosResponse.body)['data'];
      final atencionesData = json.decode(atencionesResponse.body) as List<dynamic>;

      setState(() {
        _platos = (platosData as List<dynamic>)
            .map((item) => Plato.fromJson(item))
            .toList();

        _atencionesDiarias = atencionesData
            .map((item) => AtencionDiaria.fromJson(item))
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
    var platosSeries = [
      charts.Series(
        id: 'Platos',
        data: _platos,
        domainFn: (Plato plato, _) => plato.nombrePlato,
        measureFn: (Plato plato, _) => plato.cantPlatosPedidos,
      ),
    ];

    var platosChart = charts.BarChart(
      platosSeries,
      animate: true,
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 60, // Rotar las etiquetas en 60 grados
        ),
      ),
    );

    var atencionesSeries = [
      charts.Series<AtencionDiaria, DateTime>(
        id: 'Atenciones',
        data: _atencionesDiarias,
        domainFn: (AtencionDiaria atencion, _) => atencion.fecha,
        measureFn: (AtencionDiaria atencion, _) => atencion.cantidad,
      ),
    ];

    var atencionesChart = charts.TimeSeriesChart(
      atencionesSeries,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gráficos'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gráfico de Demanda de Platos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 750,
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
                child: _platos.isNotEmpty
                    ? platosChart
                    : CircularProgressIndicator(),
              ),
              SizedBox(height: 20),
              Text(
                'Gráfico de N° Atenciones Diarias',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 400,
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
                child: _atencionesDiarias.isNotEmpty
                    ? atencionesChart
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Plato {
  final String nombrePlato;
  final int cantPlatosPedidos;

  Plato({required this.nombrePlato, required this.cantPlatosPedidos});

  factory Plato.fromJson(Map<String, dynamic> json) {
    return Plato(
      nombrePlato: json['NombrePlato'],
      cantPlatosPedidos: int.parse(json['cant_platos_pedidos']),
    );
  }
}

class AtencionDiaria {
  final DateTime fecha;
  final int cantidad;

  AtencionDiaria({required this.fecha, required this.cantidad});

  factory AtencionDiaria.fromJson(Map<String, dynamic> json) {
    return AtencionDiaria(
      fecha: DateTime.parse(json['fechas']),
      cantidad: json['cantidad'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChartsPage(),
  ));
}
