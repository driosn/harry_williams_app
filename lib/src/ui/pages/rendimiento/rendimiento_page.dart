import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/citas_solicitadas/citas_solicitadas_bloc.dart';
import 'package:harry_williams_app/src/core/models/cita_solicitada.dart';
import 'package:harry_williams_app/src/core/services/citas_solicitadas_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RendimientoPage extends StatefulWidget {
  const RendimientoPage({ Key? key }) : super(key: key);

  @override
  State<RendimientoPage> createState() => _RendimientoPageState();
}

class _RendimientoPageState extends State<RendimientoPage> {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final tamanoSize = width > height ? height : width;
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Rendimiento'),
      ),
      body: FutureBuilder<List<CitaSolicitada>>(
        future: CitasSolicitadasService().listar(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final citas = snapshot.data!;

            if (citas.isEmpty) return Center(child: Text('Citas Solicitadas'));

            final cantidadAgendadas = citas.where((cita) => cita.estadoCita == 'agendada').length;
            final cantidadCanceladas = citas.where((cita) => cita.estadoCita == 'cancelada').length;
            final cantidadSinAsistir = citas.where((cita) => cita.estadoCita == 'sin_asistir').length;
            final cantidadAsistidas = citas.where((cita) => cita.estadoCita == 'asistida').length;

            final porcentajeAgendadas = (cantidadAgendadas / citas.length) * 100.0;
            final porcentajeCanceladas = (cantidadCanceladas / citas.length) * 100.0;
            final porcentajeSinAsistir = (cantidadSinAsistir / citas.length) * 100.0;
            final porcentajeAsistidas = (cantidadAsistidas / citas.length) * 100.0;

            final List<ChartDataEstadoCita> chartData = [
              ChartDataEstadoCita('Agendada', porcentajeAgendadas, Colors.grey),
              ChartDataEstadoCita('Cancelada', porcentajeCanceladas, Colors.red),
              ChartDataEstadoCita('Sin Asistir', porcentajeSinAsistir, Colors.blue),
              ChartDataEstadoCita('Asistida', porcentajeAsistidas, Colors.green)
            ];

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Total citas: ${citas.length}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(
                            'Agendadas - $cantidadAgendadas ($porcentajeAgendadas%)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          )
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(
                            'Canceladas - $cantidadCanceladas ($porcentajeCanceladas%)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          )
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(
                            'Sin Asistir - $cantidadSinAsistir ($porcentajeSinAsistir%)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          )
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(
                            'Asistidas - $cantidadAsistidas ($porcentajeAsistidas%)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          )
                        )
                      ],
                    ),
                    Container(
                      height: tamanoSize,
                      width: tamanoSize,
                      child: SfCircularChart(
                                series: <CircularSeries>[
                                    // Renders doughnut chart
                                    DoughnutSeries<ChartDataEstadoCita, String>(
                                        dataLabelMapper: (e, i) => e.x,
                                        name: 'asdf',
                                        dataSource: chartData,
                                        pointColorMapper:(ChartDataEstadoCita data,  _) => data.color,
                                        xValueMapper: (ChartDataEstadoCita data, _) => data.x,
                                        yValueMapper: (ChartDataEstadoCita data, _) => data.y
                                    )
                                ]
                            )
                    )
                  ],
                ),
              )  
            );
          }
          return Center(
            child: Text('No existen citas solicitadas')
          );
        },
      )
    );
  }
}

class ChartDataEstadoCita {
        ChartDataEstadoCita(this.x, this.y, [this.color]);
            final String x;
            final double y;
            Color? color;
    }