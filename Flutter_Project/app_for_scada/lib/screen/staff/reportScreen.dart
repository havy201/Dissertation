import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/topAppBar.dart';
import 'package:app_for_scada/mixin/mixins.dart';
import 'package:app_for_scada/api/OrderAPIServer.dart';
import 'package:app_for_scada/model/Order/ProductionOrder.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with mixinDecoration, mixinWidgetWithFunction {
  final double itemSpacing = Global.spacing;
  final double padding = Global.padding;
  final double _fontSize = 16.0;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  late Future<List<ProductionOrder>> _productOrdersFuture;

  @override
  void initState() {
    super.initState();

    _refreshOrders(); // tạm
  }

  Future<void> _refreshOrders() async {
    final day = _refreshOrdersWithDateRange();
    setState(() {
      _productOrdersFuture = OrderAPIServer.instance.getProductionOrderByTime(
        day.$1,
        day.$2,
      );
    });
  }

  (String, String) _refreshOrdersWithDateRange() {
    DateTime start = DateTime.utc(
      dateRange.start.year,
      dateRange.start.month,
      dateRange.start.day,
    );
    String startDate = DateFormat('yyyy-MM-dd').format(start);
    DateTime end = DateTime.utc(
      dateRange.end.year,
      dateRange.end.month,
      dateRange.end.day,
    );
    String endDate = DateFormat('yyyy-MM-dd').format(end);
    return (startDate, endDate);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Theo dõi đơn hàng'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: screenPadding(),
        child: CustomScrollView(
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: HeaderChooseDate()),
            FutureBuilder<List<ProductionOrder>>(
              future: _productOrdersFuture,
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Global.loadingIndicator(),
                  );
                }
                // Error hoặc rỗng
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  final String message = snapshot.hasError
                      ? 'Lỗi khi tải đơn hàng'
                      : 'Không có đơn hàng nào trong khoảng thời gian này!';
                  return SliverToBoxAdapter(
                    child: Global.errorIndicator(message, context),
                  );
                }

                // Thành công → SliverGrid
                return SliverGrid.count(
                  childAspectRatio:
                      160 / (MediaQuery.of(context).size.height * 0.3),
                  mainAxisSpacing: itemSpacing,
                  crossAxisSpacing: itemSpacing,
                  crossAxisCount: 2,
                  children: List.generate(snapshot.data!.length, (index) {
                    final order = snapshot.data![index];
                    final productNames =
                        order.details
                            ?.map((d) => d.productName ?? '')
                            .toList() ??
                        [];
                    return informationCell(
                      context,
                      order.productionOrderId ?? '',
                      order.fullName ?? '',
                      formatTime(order.orderDay ?? ''),
                      productNames,
                      order.status ?? 0,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/reportDetail',
                        arguments: order,
                      ).then((result) {if (result == true) _refreshOrders();}),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget HeaderChooseDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tra cứu đơn hàng:',
          style: fontStyleBaloo(_fontSize + 5, color: Global.primaryBlue),
        ),
        SizedBox(height: itemSpacing / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: FindDate('Ngày bắt đầu', true)),
            SizedBox(width: itemSpacing),
            Expanded(child: FindDate('Ngày kết thúc', false)),
          ],
        ),
        SizedBox(height: itemSpacing),
        Center(
          child: filledBtn(
            () {
              _refreshOrders();
            },
            'Tra cứu',
            color: const Color(0xFF032B91),
          ),
        ),
        SizedBox(height: itemSpacing),
      ],
    );
  }

  Widget FindDate(String title, bool isStartDate) {
    return TextFormField(
      controller: isStartDate ? _startDateController : _endDateController,
      readOnly: true,
      showCursor: false,
      onTap: _showDateRangeTime,
      style: fontStyleBaloo(_fontSize, color: Colors.grey.shade800),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: title,
        hintStyle: fontStyleBaloo(_fontSize, color: Colors.grey.shade800),
        //contentPadding: contentPadding(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future _showDateRangeTime() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (newDateRange != null) {
      setState(() {
        dateRange = newDateRange;
        _startDateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(dateRange.start);
        _endDateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(dateRange.end);
      });
    }
  }

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 7)),
    end: DateTime.now(),
  );

  String formatTime(String isoString) {
    DateTime parsedDate = DateTime.parse(isoString);
    DateTime localDate = parsedDate.toLocal();
    String result = DateFormat('dd/MM/yy HH:mm:ss').format(localDate);
    return result;
  }
}
