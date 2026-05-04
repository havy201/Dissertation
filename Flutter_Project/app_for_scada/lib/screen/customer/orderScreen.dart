import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/topAppBar.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';
import '../../global.dart';
import 'package:app_for_scada/mixin/mixinFunctions.dart';
import 'package:app_for_scada/mixin/mixinWidgetWithFunction.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ✅ Model sản phẩm — import từ file models/product.dart sau này
class Product {
  final int id;
  final String name;
  const Product({required this.id, required this.name});
}

// ✅ Danh sách sản phẩm tách ra ngoài — sau này thay bằng API
const List<Product> kProductList = [
  Product(id: 0, name: 'Sản phẩm 1'),
  Product(id: 1, name: 'Sản phẩm 2'),
  Product(id: 2, name: 'Sản phẩm 3'),
];

// ✅ Model cho mỗi dòng đặt hàng
class OrderItem {
  final TextEditingController quantityController;
  int? selectedProductId;
  int quantity;

  OrderItem()
    : quantityController = TextEditingController(text: '1'),
      quantity = 1,
      selectedProductId = null;

  void dispose() => quantityController.dispose();
}

class OrderScreen extends StatefulWidget with mixinNotification {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with
        itemDecorationMixin,
        fontStyleMixin,
        InputFieldDecorationMixin,
        particularFunctionMixin,
        AutomaticKeepAliveClientMixin {
  static const double _fontSize = 20;
  static const double _slidableExtentRatio = 0.22;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final List<OrderItem> _orderItems = [OrderItem()];

  // ✅ Bắt buộc khi dùng AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    for (final item in _orderItems) {
      item.dispose();
    }
    super.dispose();
  }

  void _addOrderItem() {
    setState(() => _orderItems.add(OrderItem()));
  }

  void _removeOrderItem(int index) {
    if (_orderItems.length <= 1) return;
    _orderItems[index].dispose();
    setState(() => _orderItems.removeAt(index));
  }

  void _resetOrderForm() {
    for (final item in _orderItems) {
      item.dispose();
    }

    setState(() {
      _orderItems
        ..clear()
        ..add(OrderItem());
    });

    _formKey.currentState?.reset();
  }

  Future<void> _handleOrder() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    final overlay = Overlay.of(context, rootOverlay: true);
    final blocker = OverlayEntry(
      builder: (_) =>
          const ModalBarrier(dismissible: false, color: Colors.transparent),
    );
    overlay.insert(blocker);

    try {
      // ── Snackbar loading ────────────────────────
      final controller = widget.notifyUser(
        context,
        'Đang đặt hàng...',
        fontStyleBaloo(_fontSize, color: Colors.white),
        Colors.grey,
      );
      await controller.closed;
      if (!mounted) return;

      // final payload = _orderItems
      //     .map((item) => {
      //           'product_id': item.selectedProductId,
      //           'quantity': item.quantity,
      //         })
      //     .toList();

      // // TODO: đổi sang API thật, ví dụ:
      // // final isSuccess = await ApiService.placeOrder(payload);
      // final isSuccess = payload.isNotEmpty;

      // if (!isSuccess) {
      //   throw Exception('Đặt hàng thất bại từ API');
      // }

      _resetOrderForm();

      widget.notifyUser(
        context,
        'Đặt hàng thành công',
        fontStyleBaloo(_fontSize, color: Colors.white),
        Colors.green,
      );

      // Navigator.pushReplacementNamed(context, '/trackingScreen');
    } catch (e) {
      if (!mounted) return;
      widget.notifyUser(
        context,
        'Đặt hàng thất bại',
        fontStyleBaloo(_fontSize),
        Colors.red,
      );
    } finally {
      blocker.remove();
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildOrderRow(int index) {
    final primaryBlue = Global.primaryBlue;
    final spacing = Global.spacing;
    final item = _orderItems[index];
    return Column(
      key: ValueKey(index),
      children: [
        // ── Dropdown + Slidable xóa ──────────────
        Slidable(
          key: ValueKey('slidable_$index'),
          endActionPane: ActionPane(
            extentRatio: _slidableExtentRatio,
            motion: const StretchMotion(),
            children: [
              CustomSlidableAction(
                onPressed: (_) => _removeOrderItem(index),
                backgroundColor: Colors.red[400]!,
                child: const Icon(Icons.delete, size: 35, color: Colors.white),
              ),
            ],
          ),
          // ✅ Không bọc Expanded ở đây — Slidable không phải Row
          child: Theme(
            data: Theme.of(context).copyWith(hintColor: primaryBlue),
            child: DropdownButtonFormField<int>(
              icon: Icon(Icons.arrow_drop_down, color: primaryBlue),
              iconSize: 35,
              isExpanded: true,
              style: fontStyleInter(_fontSize, color: primaryBlue),
              borderRadius: BorderRadius.circular(10),
              dropdownColor: Colors.white,
              elevation: 4,
              value: item.selectedProductId, // ✅ Dùng value thay initialValue
              decoration: InputDecoration(
                prefixIcon: prefixIconPadding('lib/icons/recipe_light.png'),
                contentPadding: contentPadding(),
                hintText: 'Chọn sản phẩm',
                hintStyle: fontStyleInter(_fontSize, color: primaryBlue),
                border: outlineInputBorder(),
                enabledBorder: outlineInputBorder(),
                focusedBorder: outlineInputBorder(),
              ),
              // ✅ Import từ kProductList
              items: kProductList
                  .map(
                    (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                  )
                  .toList(),
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => item.selectedProductId = value),
              validator: mesDropdownValidation<int>('Vui lòng chọn sản phẩm'),
            ),
          ),
        ),
        SizedBox(height: spacing),

        // ── Số lượng mẻ ──────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Số lượng mẻ:',
              style: fontStyleBaloo(_fontSize, color: primaryBlue),
            ),
            IconButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (item.quantity > 1) {
                        setState(() {
                          item.quantity--;
                          item.quantityController.text = item.quantity
                              .toString();
                        });
                      }
                    },
              icon: Icon(Icons.remove, color: primaryBlue, size: 20),
            ),
            Expanded(
              child: TextFormField(
                textAlign: TextAlign.center,
                style: fontStyleInter(15, color: primaryBlue),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: item.quantityController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  border: outlineInputBorder(),
                  enabledBorder: outlineInputBorder(),
                  focusedBorder: outlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    item.quantity = int.tryParse(value) ?? 1;
                    if (item.quantity < 1) {
                      item.quantity = 1;
                      item.quantityController.text = '1';
                    }
                  });
                },
                validator: mesIFieldValidator('Vui lòng nhập số lượng'),
              ),
            ),
            IconButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() {
                        item.quantity++;
                        item.quantityController.text = item.quantity.toString();
                      });
                    },
              icon: Icon(Icons.add, color: primaryBlue, size: 20),
            ),
          ],
        ),
        SizedBox(height: spacing),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ Bắt buộc khi dùng AutomaticKeepAliveClientMixin
    final spacing = Global.spacing;

    return Scaffold(
      appBar: TopAppBar(title: 'Đặt hàng'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: screenPadding(),
        child: SlidableAutoCloseBehavior(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        for (var i = 0; i < _orderItems.length; i++)
                          _buildOrderRow(i),
                        iconBtnCustom(_isLoading ? null : _addOrderItem),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              filledBtn(_isLoading ? null : _handleOrder, 'Đặt hàng'),
            ],
          ),
        ),
      ),
    );
  }
}
