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

/// Simple pie chart with outside labels example.
import 'dart:math';

// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:life_track/extension/color_to_hax.dart';
import 'package:life_track/models/daily_monthly_weekly_response.dart';

class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  PieOutsideLabelChart(this.seriesList, {this.animate = false});

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory PieOutsideLabelChart.withRandomData(List<PieChartModel> dataEntries) {
    return PieOutsideLabelChart(_createRandomData(dataEntries));
  }

  /// Create random data.
  static List<charts.Series<PieChartModel, int>> _createRandomData(List<PieChartModel> dataEntries) {
    final random = Random();

     // print('COLOR OCDE :: '+dataEntries[0].color.toString());

    if (dataEntries.isNotEmpty)
      for (var i = 0; i< dataEntries.length; i++) {
        print("xsdcsakldkfj"+dataEntries[i].color.toString());

        // dataEntries.add(PieChartModel(i,double.parse(controller.model.value.data!.budgetedData[i].time).toInt()));
      }

    //
    // List<PieChartModel> dataEntries = [];
    //
    // for (var item in data){
    //   dataEntries.add(PieChartModel(sno: 0, value: double.parse(item.budget[index]).toInt()));
    //   dataEntries.add(PieChartModel(sno: 1, value: double.parse(item.budget[index]).toInt()));
    // }
    // [
    //   PieChartModel(sno: 0, value: 30),
    //   PieChartModel(sno: 1, value: 70),
    // ];

    return [
      charts.Series<PieChartModel, int>(
        id: 'Sales',
        domainFn: (PieChartModel sales, _) => sales.sno,
        measureFn: (PieChartModel sales, _) => sales.value,
        colorFn: (PieChartModel sales, _) => charts.Color.fromHex(code: sales.color.toString()),
        data: dataEntries,
        // colorFn: (_, __) => dataEntries,//charts.Color.fromHex(code: '#f2f2f2'),
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (PieChartModel row, _) => 'ball',
      )
    ];
  }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: charts.PieChart(
        seriesList,
        // animate: animate,
        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        //   defaultRenderer: new charts.ArcRendererConfig(
        //        arcWidth: 20,
        //     arcRatio: 20,
        //       arcRendererDecorators: [new charts.ArcLabelDecorator()])
      ),
    );
  }
}

/// Sample linear data type.
class PieChartModel {
  final int sno;
  final int value;
  Color color;

  PieChartModel( {required this.sno, required this.value, required this.color});
}
