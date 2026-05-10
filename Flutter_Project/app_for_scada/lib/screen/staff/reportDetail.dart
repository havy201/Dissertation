import 'package:app_for_scada/api/OrderAPIServer.dart';
import 'package:app_for_scada/model/Order/ProductionOrderDetail.dart';
import 'package:app_for_scada/model/Order/RecipeSnapshot.dart';
import 'package:app_for_scada/model/Production/MaterialItem.dart';
import 'package:app_for_scada/model/Production/Product.dart';
import 'package:app_for_scada/widgets/titleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../global.dart';
import 'package:app_for_scada/mixin/mixins.dart';
import 'package:app_for_scada/model/Order/ProductionOrder.dart';

final double spacing = Global.spacing;
final double padding = Global.padding;
final double sizeAvatar = 50;
final double fontSize = 20;
final double fontSizeTitle = 18;
final double fontSizeContent = 16;

class ReportDetail extends StatefulWidget {
  const ReportDetail({super.key});

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail>
    with mixinDecoration, mixinWidgetWithFunction<ReportDetail> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as ProductionOrder;
    final statusTag = statusTagText(order.status ?? 10);
    List<ProductionOrderDetail> details = order.details ?? [];
    int role = Global.currentUser?.role ?? 10;
    return Scaffold(
      appBar: const TitleAppBar(title: 'Chi tiết đơn hàng'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(spacing),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffEDEDED),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    children: [
                      Image.asset(
                        'lib/icons/animalfood.png',
                        width: sizeAvatar,
                        height: sizeAvatar,
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Mã đơn hàng',
                              style: fontStyleBaloo(fontSize),
                            ),
                            Text(
                              'ID: ${order.productionOrderId}',
                              style: fontStyleBaloo(
                                fontSize,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEDEDED),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'lib/icons/customer.png',
                          Color(0xff2196F3),
                          'Khách hàng',
                          order.fullName ?? 'Không có thông tin',
                        ),
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/phonenumber.png',
                          Color(0xff006923),
                          'Số điện thoại',
                          order.phone ?? 'Không có thông tin',
                        ),
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/orderDay.png',
                          Color(0xff6155F5),
                          'Thời gian đặt hàng',
                          formatTime(order.orderDay ?? 'Không có thông tin'),
                        ),
                        for (int i = 0; i < details.length; i++) ...[
                          _divider(),
                          _buildInfoRow(
                            'lib/icons/fooditem.png',
                            Color(0xffFF9800),
                            'Tên sản phẩm',
                            details[i].productName ?? 'Không có thông tin',
                            detail: details[i],
                          ),
                        ],
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/shoppingBasket.png',
                          statusTag.$2,
                          'Trạng thái',
                          statusTag.$1,
                        ),
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/startTime.png',
                          Color(0xff9D9D9D),
                          order.actualStartTime != null
                              ? 'Thời gian bắt đầu thực tế'
                              : 'Thời gian bắt đầu dự kiến',
                          formatTime(order.plannedStartTime ?? ''),
                        ),
                        _divider(),
                        _buildInfoRow(
                          'lib/icons/endTime.png',
                          Color(0xff9D9D9D),
                          order.actualEndTime != null
                              ? 'Thời gian kết thúc thực tế'
                              : 'Thời gian kết thúc dự kiến',
                          formatTime(order.plannedEndTime ?? ''),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              if (Global.currentUser?.role == 0 &&
                  (order.status == 0 || order.status == 1))
                filledBtn(
                  _isLoading
                      ? null
                      : () {
                          _confirmAction(
                            role,
                            order,
                          ); // 2 represents the delete action
                        },
                  'Hủy đơn hàng',
                  color: const Color(0xFFFF0000),
                )
              else if (Global.currentUser?.role == 2 && order.status == 0)
                filledBtn(
                  _isLoading
                      ? null
                      : () {
                          _confirmAction(
                            role,
                            order,
                          ); // 3 represents the confirm order action
                        },
                  'Nhận đơn hàng',
                  color: const Color(0xFF032B91),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmAction(int role, ProductionOrder? order) {
    showConfirmDialog(
      title: role == 0
          ? 'Hủy đơn hàng?'
          : (role == 2 ? 'Xác nhận đơn hàng?' : 'Bị lỗi'),
      titleStyle: fontStyleBaloo(fontSize),
      actionStyle: fontStyleBaloo(fontSize),
      onConfirm: () => _handleChange(role, order),
    );
  }

  Future<void> _handleChange(int role, ProductionOrder? order) async {
    setState(() => _isLoading = true);
    final primaryBlue = Global.primaryBlue;
    final overlay = Overlay.of(context, rootOverlay: true);
    final blocker = OverlayEntry(
      builder: (_) =>
          const ModalBarrier(dismissible: false, color: Colors.transparent),
    );
    overlay.insert(blocker);

    try {
      final messageWidget = notifyUser(
        context,
        'Đang cập nhật...',
        fontStyleBaloo(fontSize, color: Colors.white),
        primaryBlue,
      );
      await messageWidget.closed;
      if (!mounted) return;

      bool isUpdated = false;
      if (role == 0) {
        final updateOrder = ProductionOrder(
          productionOrderId: order?.productionOrderId,
          status: 8,
        );
        isUpdated = await OrderAPIServer.instance.updateProductionOrder(
          updateOrder,
        );
      } else if (role == 2) {
        final orderId = ProductionOrder(
          productionOrderId: order?.productionOrderId,
        );
        isUpdated = await OrderAPIServer.instance.confirmOrder(orderId);
        print('Xác nhận đơn hàng ${isUpdated ? 'thành công' : 'thất bại'}');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (isUpdated) {
        final success = notifyUser(
          context,
          role == 0
              ? 'Hủy đơn hàng thành công!'
              : (role == 2
                    ? 'Xác nhận đơn hàng thành công!'
                    : 'Thao tác thành công!'),
          fontStyleBaloo(fontSize, color: Colors.white),
          Colors.green[900]!,
        );
        await success.closed;
        if (!mounted) return;
        Navigator.pop(context, true); // Trả về true để trigger set
      } else {
        print('Thất bại');
        throw Exception('Thất bại');
      }
    } catch (e) {
      if (!mounted) return;
      notifyUser(
        context,
        role == 0
            ? 'Hủy đơn hàng thất bại!'
            : (role == 2
                  ? 'Xác nhận đơn hàng thất bại!'
                  : 'Thao tác thất bại!'),
        fontStyleBaloo(fontSize, color: Colors.white),
        Colors.red,
      );
    } finally {
      blocker.remove();
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildInfoRow(
    String path,
    Color color,
    String title,
    String value, {
    ProductionOrderDetail? detail,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: spacing / 2),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Image.asset(
                path,
                height: 24,
                width: 24,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: fontStyleInter(fontSizeTitle)),
                Text(
                  value,
                  style: fontStyleInter(
                    fontSizeContent,
                    isItalic: true,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (detail != null)
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 24,
                color: Colors.black,
              ),
              onPressed: () {
                _showProductDetails(context, detail);
              },
            ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.white, height: 2);

  void _showProductDetails(BuildContext context, ProductionOrderDetail detail) {
    RecipeSnapshot snapshot = detail.recipeSnapshot!;
    List<MaterialItem>? materials = snapshot.materials;
    showDialog(
      context: context,
      barrierDismissible: true, // Bấm ra ngoài để đóng
      builder: (BuildContext context) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: spacing),
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF032B91),
                width: 3,
              ), // Viền xanh đậm
            ),
            child: Material(
              // Cần Material để Text không bị gạch chân vàng
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Để bảng cao vừa khít nội dung
                children: [
                  Text(
                    '${detail.productName ?? 'Sản phẩm'}',
                    style: fontStyleBaloo(
                      fontSize,
                      color: const Color(0xFF032B91),
                    ),
                  ),
                  SizedBox(height: padding),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tỷ lệ thành phần:',
                      style: fontStyleBaloo(fontSizeTitle),
                    ),
                  ),
                  SizedBox(height: padding),
                  Text(
                    materials != null
                        ? materials
                                  .map(
                                    (m) =>
                                        '${m.targetKg ?? 0}% ${m.materialName?.toLowerCase()}',
                                  )
                                  .join(', ') +
                              '.'
                        : 'Không có thông tin',
                    textAlign: TextAlign.justify,
                    style: fontStyleBaloo(fontSizeContent, color: Colors.black),
                  ),
                  SizedBox(height: padding),
                  _rowInfo(
                    'Số lượng đặt hàng',
                    detail.targetBatch?.toString() ?? '0',
                  ),
                  SizedBox(height: padding),
                  _rowInfo(
                    'Số lượng đã sản xuất',
                    detail.currentBatch?.toString() ?? '0',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _rowInfo(String title, String content) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$title:',
            style: fontStyleBaloo(fontSizeTitle),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: fontStyleBaloo(fontSizeContent, color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String formatTime(String isoString) {
    if (isoString.isEmpty) return 'Không có thông tin';
    try {
      DateTime parsedDate = DateTime.parse(isoString);
      DateTime localDate = parsedDate.toLocal();
      String result = DateFormat('dd/MM/yy HH:mm:ss').format(localDate);
      return result;
    } catch (e) {
      return isoString;
    }
  }
}
