import 'package:collection/collection.dart';

class Trend {
  // String orderBatchId;
  // String materialName;
  double value;
  double time;
  Trend({
    // required this.orderBatchId,
    // required this.materialName,
    required this.value,
    required this.time,
  });
}
List<Trend> get trends {
  final data = <double>[10, 20, 15, 30, 25];
  return data
      .mapIndexed(
        ((index, element) => Trend(value: element, time: index.toDouble())),
      )
      .toList();
}
