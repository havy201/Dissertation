import 'package:app_for_scada/api/OrderAPIServer.dart';
import 'package:app_for_scada/global.dart';
import 'package:app_for_scada/model/Order/ProductionOrder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import 'package:app_for_scada/mixin/mixins.dart';

final double itemSpacing = Global.spacing;
final double padding = Global.padding;

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen>
    with mixinDecoration, mixinWidgetWithFunction {
  late Future<List<ProductionOrder>> _productOrdersFuture;

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _productOrdersFuture = OrderAPIServer.instance
          .getProductionOrderByUsername(Global.currentUser?.userName ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Theo dõi đơn hàng'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: screenPadding(),
        child: RefreshIndicator(
          color: Color(0xFF032B91),
          strokeWidth: 3,
          onRefresh: _refreshOrders,
          child: FutureBuilder<List<ProductionOrder>>(
            future: _productOrdersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Global.loadingIndicator();
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                String message = snapshot.hasError
                    ? 'Lỗi khi tải đơn hàng'
                    : 'Quý khách chưa có đơn hàng nào. Hãy đặt hàng ngay để trải nghiệm sản phẩm của chúng tôi!';
                return Global.errorIndicator(message, context);
              } else {
                return GridView.count(
                  clipBehavior: Clip.none,
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
                      onTap: () =>
                          Navigator.pushNamed(
                            context,
                            '/reportDetail',
                            arguments: order,
                          ).then((result) {
                            if (result == true && result != null) {
                              _refreshOrders();
                            }
                          }),
                    );
                  }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

String formatTime(String isoString) {
  DateTime parsedDate = DateTime.parse(isoString);
  DateTime localDate = parsedDate.toLocal();
  String result = DateFormat('dd/MM/yy HH:mm:ss').format(localDate);
  return result;
}
