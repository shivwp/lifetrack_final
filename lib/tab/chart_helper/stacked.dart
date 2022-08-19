// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Bar chart example
import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  StackedBarChart(this.seriesList, {this.animate = false});

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory StackedBarChart.withRandomData(List<BarCharModel> dataEntriesBarChart) {
    return StackedBarChart(_createRandomData(dataEntriesBarChart));
  }

  /// Create random data.
  static List<charts.Series<BarCharModel, String>> _createRandomData(List<BarCharModel> dataEntriesBarChart) {
    final random = Random();

    // final dataEntriesBarChart = [
    //   BarCharModel(xAxisUnits: 'rth', yAxisUnits: random.nextInt(100)),
    //   BarCharModel(xAxisUnits: '02/04', yAxisUnits: random.nextInt(100)),
    //   BarCharModel(xAxisUnits: '03/04', yAxisUnits: random.nextInt(100)),
    //   BarCharModel(xAxisUnits: '04/04', yAxisUnits: random.nextInt(100)),
    // ];

    // final dataEntriesBarChart = [
    //   BarCharModel(xAxisUnits: '01/04', yAxisUnits: random.nextInt(100)),
    //   BarCharModel(xAxisUnits: '02/04', yAxisUnits: random.nextInt(100)),
    //   BarCharModel(xAxisUnits: '03/04', yAxisUnits: random.nextInt(100)),
    //   BarCharModel(xAxisUnits: '04/04', yAxisUnits: random.nextInt(100)),
    // ];

    return [
      charts.Series<BarCharModel, String>(
        id: 'Goal',
        domainFn: (BarCharModel sales, _) => sales.xAxisUnits,
        measureFn: (BarCharModel sales, _) => sales.yAxisUnits,
        data: dataEntriesBarChart,
      ),
      charts.Series<BarCharModel, String>(
        id: 'Actual',
        domainFn: (BarCharModel sales, _) => sales.xAxisUnits,
        measureFn: (BarCharModel sales, _) => sales.yAxisUnits,
        data: dataEntriesBarChart,
      ),
    ];
  }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: const charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
              // Tick and Label styling here.
              labelStyle: charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.white),
              // Change the line colors to match text color.
              lineStyle:
                  charts.LineStyleSpec(color: charts.MaterialPalette.white))),
      domainAxis: const charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(

              // Tick and Label styling here.
            labelRotation: 20,
              labelStyle: charts.TextStyleSpec(
                  fontSize: 12, //// size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle:
                  charts.LineStyleSpec(color: charts.MaterialPalette.white))),
    );
  }
}

/// Sample ordinal data type.
class BarCharModel {
  final String xAxisUnits;
  final int yAxisUnits;

  BarCharModel({required this.xAxisUnits, required this.yAxisUnits});
}
