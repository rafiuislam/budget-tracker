import 'package:budget_tracker/item_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SpendingChart extends StatelessWidget {
  final List<Item> items;

  const SpendingChart({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spending = <String, double>{};

    items.forEach(
      (item) => spending.update(
        item.category,
        (value) => value + item.price,
        ifAbsent: () => item.price,
      ),
    );

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 360,
        child: PieChart(PieChartData(
          sections: spending
              .map(
                (category, amountSpent) => MapEntry(
                  category,
                  PieChartSectionData(
                    color: getCategoryColor(category),
                    title: '\$${amountSpent.toStringAsFixed(2)}',
                    value: amountSpent,
                  ),
                ),
              )
              .values
              .toList(),
          sectionsSpace: 0,
        )),
      ),
    );
  }
}
