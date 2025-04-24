import 'package:app/view/provider/summaryProvider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class cashFlow extends StatelessWidget {
  const cashFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<summaryProvider>(builder: (context, provider, child) {
      // ❌ Removed: provider.defaultValues(0, 0);
      double incoming = provider.incoming.roundToDouble();
      double outgoing = provider.outgoing.roundToDouble() * -1;

      return Container(
        height: 320,
        width: 360,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(124, 161, 159, 0.294),
              offset: Offset(0, 6),
              blurRadius: 12,
              spreadRadius: 6,
            ),
          ],
          color: const Color.fromARGB(255, 243, 237, 247),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: PieChart(
                  checkVal(incoming, outgoing)
                      ? PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: ((incoming / (incoming + outgoing)) * 100)
                            .roundToDouble(),
                        color: Colors.lightGreen,
                        radius: 70,
                        title:
                        "${((incoming / (incoming + outgoing)) * 100).roundToDouble()}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      PieChartSectionData(
                        value: ((outgoing / (incoming + outgoing)) * 100)
                            .roundToDouble(),
                        color: Colors.red,
                        radius: 70,
                        title:
                        "${((outgoing / (incoming + outgoing)) * 100).roundToDouble()}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    startDegreeOffset: 90,
                  )
                      : PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 100,
                        color: Colors.white,
                        showTitle: false,
                        radius: 60,
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(Colors.lightGreen, "Income"),
                  _buildLegendItem(Colors.red, "Expense"),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          height: 13,
          width: 13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }

  bool checkVal(double a, double b) {
    return !(a == 0 && b == 0);
  }
}
