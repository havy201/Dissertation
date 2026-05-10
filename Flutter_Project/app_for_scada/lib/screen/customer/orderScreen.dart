import 'package:app_for_scada/api/ProductAPIServer.dart';
import 'package:app_for_scada/api/OrderAPIServer.dart';
import 'package:app_for_scada/model/Order/ProductionOrder.dart';
import 'package:app_for_scada/model/Order/ProductionOrderDetail.dart';
import 'package:app_for_scada/model/Production/ProductItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/topAppBar.dart';
import 'package:app_for_scada/mixin/mixins.dart';
import '../../global.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ✅ Model cho mỗi dòng đặt hàng
class OrderItem {
  final TextEditingController batchQuantityController;
  String? selectedProductId;
  int quantity;

  OrderItem()
    : batchQuantityController = TextEditingController(text: '1'),
      quantity = 1,
      selectedProductId = null;

  void dispose() => batchQuantityController.dispose();
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with
        mixinDecoration,
        mixinFuntions,
        mixinWidgetWithFunction,
        AutomaticKeepAliveClientMixin {
  static const double _fontSize = 20;
  static const double _slidableExtentRatio = 0.22;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final List<OrderItem> _orderItems = [OrderItem()];
  List<ProductItem> _productItems = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getAllChoices();
  }

  Future<void> _getAllChoices() async {
    try {
      final apiProductItems = await ProductAPIServer.instance
          .getAllProductItems();
      if (!mounted) return; // Debug log
      setState(() {
        _productItems = apiProductItems
            .where((e) {
              final productId = e.productId?.trim();
              final productName = e.productName?.trim();
              return productId != null &&
                  productId.isNotEmpty &&
                  productId != '0' &&
                  productName != null &&
                  productName.isNotEmpty;
            })
            .map(
              (e) => ProductItem(
                productId: e.productId!.trim(),
                productName: e.productName!.trim(),
              ),
            )
            .toList();
        _syncSelectedProductsWithChoices();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _productItems = []);
    }
  }

  void _syncSelectedProductsWithChoices() {
    final productIds = _productItems
        .map((product) => product.productId)
        .whereType<String>()
        .toSet();

    for (final item in _orderItems) {
      if (!productIds.contains(item.selectedProductId)) {
        item.selectedProductId = null;
      }
    }
  }

  List<ProductItem> _availableProducts(int index) {
    final selectedOthers = _orderItems
        .asMap()
        .entries
        .where((e) => e.key != index && e.value.selectedProductId != null)
        .map((e) => e.value.selectedProductId!)
        .toSet();

    return _productItems
        .where((product) => !selectedOthers.contains(product.productId))
        .toList();
  }

  @override
  void dispose() {
    for (final item in _orderItems) {
      item.dispose();
    }
    super.dispose();
  }

  void _addOrderItem() {
    if (_orderItems.length >= _productItems.length) return;
    setState(() => _orderItems.add(OrderItem()));
  }

  void _removeOrderItem(int index) {
    if (index < 0 || index >= _orderItems.length) return;

    final removedItem = _orderItems[index];
    setState(() => _orderItems.removeAt(index));
    removedItem.dispose();
  }

  void _resetOrderForm() {
    // for (final item in _orderItems) {
    //   item.dispose();
    // }

    setState(() {
      _orderItems
        ..clear()
        ..add(OrderItem());
    });

    _formKey.currentState?.reset();
  }

  void _checkValidator() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    showConfirmDialog(
      title: 'Đặt hàng?',
      titleStyle: fontStyleBaloo(_fontSize),
      actionStyle: fontStyleBaloo(_fontSize),
      onConfirm: _handleOrder,
    );
  }

  Future<void> _handleOrder() async {
    setState(() => _isLoading = true);

    final overlay = Overlay.of(context, rootOverlay: true);
    final blocker = OverlayEntry(
      builder: (_) =>
          const ModalBarrier(dismissible: false, color: Colors.transparent),
    );
    overlay.insert(blocker);

    try {
      // ── Snackbar loading ────────────────────────
      final controller = notifyUser(
        context,
        'Đang đặt hàng...',
        fontStyleBaloo(_fontSize, color: Colors.white),
        Global.primaryBlue,
      );
      await controller.closed;
      if (!mounted) return;
      // Debug log
      final details = <ProductionOrderDetail>[];
      for (int i = 0; i < _orderItems.length; i++) {
        final item = ProductionOrderDetail(
          productId: _orderItems[i].selectedProductId!,
          batchQuantity: _orderItems[i].quantity,
          sequenceNo: i + 1,
        );
        details.add(item);
      }

      final productionOrder = ProductionOrder(
        priority: 0,
        plannedStartTime: DateTime.now().toUtc().toIso8601String(),
        plannedEndTime: DateTime.now()
            .add(Duration(days: _orderItems.length))
            .toUtc()
            .toIso8601String(),
        userName: Global.currentUser?.userName,
        details: details,
      );

      bool isCreated = await OrderAPIServer.instance.createProductionOrder(
        productionOrder,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      _resetOrderForm();
      if (isCreated) {
        final success = notifyUser(
          context,
          'Cập nhật thành công!',
          fontStyleBaloo(_fontSize, color: Colors.white),
          Colors.green[900]!,
        );
        await success.closed;
        if (!mounted) return;
      }

      // Navigator.pushReplacementNamed(context, '/trackingScreen');
    } catch (e) {
      if (!mounted) return;
      notifyUser(
        context,
        'Đặt hàng thất bại',
        fontStyleBaloo(_fontSize, color: Colors.white),
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
    final availableProducts = _availableProducts(index);
    final selectedProductId =
        availableProducts.any(
          (product) => product.productId == item.selectedProductId,
        )
        ? item.selectedProductId
        : null;

    return Column(
      key: ObjectKey(item),
      children: [
        // ── Dropdown + Slidable xóa ──────────────
        Slidable(
          key: ObjectKey(item),
          endActionPane: ActionPane(
            extentRatio: _slidableExtentRatio,
            motion: const StretchMotion(),
            dismissible: DismissiblePane(
              onDismissed: () => _removeOrderItem(index),
            ),
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
            child: DropdownButtonFormField<String>(
              icon: Icon(Icons.arrow_drop_down, color: primaryBlue),
              iconSize: 35,
              isExpanded: true,
              style: fontStyleInter(_fontSize, color: primaryBlue),
              borderRadius: BorderRadius.circular(10),
              dropdownColor: Colors.white,
              elevation: 4,
              initialValue: selectedProductId,
              decoration: InputDecoration(
                prefixIcon: prefixIconPadding('lib/icons/recipe_light.png'),
                contentPadding: contentPadding(),
                hintText: _productItems.isEmpty
                    ? 'Không có sản phẩm'
                    : 'Chọn sản phẩm',
                hintStyle: fontStyleInter(_fontSize, color: primaryBlue),
                border: outlineInputBorder(),
                enabledBorder: outlineInputBorder(),
                focusedBorder: outlineInputBorder(),
              ),
              items: availableProducts
                  .map(
                    (product) => DropdownMenuItem(
                      value: product.productId,
                      child: Text(product.productName ?? ''),
                    ),
                  )
                  .toList(),
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => item.selectedProductId = value),
              validator: mesDropdownValidation<String>(
                'Vui lòng chọn sản phẩm',
              ),
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
                          item.batchQuantityController.text = item.quantity
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
                controller: item.batchQuantityController,
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
                      item.batchQuantityController.text = '1';
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
                        item.batchQuantityController.text = item.quantity
                            .toString();
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
    final canAddOrderItem =
        !_isLoading && _orderItems.length < _productItems.length;

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
                        iconBtnCustom(canAddOrderItem ? _addOrderItem : null),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              filledBtn(_isLoading ? null : _checkValidator, 'Đặt hàng'),
            ],
          ),
        ),
      ),
    );
  }
}
