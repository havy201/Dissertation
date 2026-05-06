import 'package:flutter/material.dart';
import 'package:app_for_scada/mixin/mixinFunctions.dart';
import 'package:flutter/services.dart';
import 'package:app_for_scada/widgets/titleAppBar.dart';
import 'package:app_for_scada/global.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';
import 'package:app_for_scada/mixin/mixinWidgetWithFunction.dart';
import 'package:app_for_scada/api/ProductAPIServer.dart';
import 'package:app_for_scada/model/Production/MaterialItem.dart';
import 'package:app_for_scada/model/Production/Recipe.dart';
import 'package:app_for_scada/model/Production/Product.dart';
import 'package:get/get.dart';

class RecipeChange extends StatefulWidget with mixinNotification {
  const RecipeChange({super.key});

  @override
  State<RecipeChange> createState() => _RecipeChangeState();
}

class _RecipeChangeState extends State<RecipeChange>
    with
        fontStyleMixin,
        InputFieldDecorationMixin,
        itemDecorationMixin,
        mixinWidgetWithFunction,
        particularFunctionMixin {
  static const double _fontSize = 20;
  static const Color _buttonColor = Color(0xff00F3FF);

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  bool _isLoading = false;

  @override
  void dispose() {
    for (final controller in _controllers) controller.dispose();
    super.dispose();
  }

  void _checkValidator(Product product) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    showConfirmDialog(
      title: 'Cập nhật công thức?',
      titleStyle: fontStyleBaloo(_fontSize),
      actionStyle: fontStyleBaloo(_fontSize),
      onConfirm: () => _handleChange(product),
    );
  }

  Future<void> _handleChange(Product product) async {
    String? recipeId = product.recipe?.recipeId ?? product.recipeId;
    List<MaterialItem> materials = product.recipe?.materials ?? [];
    setState(() => _isLoading = true);

    final overlay = Overlay.of(context, rootOverlay: true);
    final blocker = OverlayEntry(
      builder: (_) =>
          const ModalBarrier(dismissible: false, color: Colors.transparent),
    );
    overlay.insert(blocker);

    try {
      final loading = widget.notifyUser(
        context,
        'Đang cập nhật...',
        fontStyleBaloo(_fontSize, color: Colors.white),
        Global.primaryBlue,
      );
      await loading.closed;
      if (!mounted) return;
      final calib = _adaptPercent(_controllers);
      final materialsSend = <MaterialItem>[];
      final materialCount = materials.length < _controllers.length
          ? materials.length
          : _controllers.length;
      for (var i = 0; i < materialCount; i++) {
        final targetValue =
            calib * (double.tryParse(_controllers[i].text.trim()) ?? 0.0);
        final item = MaterialItem(
          materialId: materials[i].materialId,
          targetKg: targetValue,
          toleranceMinKg: targetValue - 1.0,
          toleranceMaxKg: targetValue + 1.0,
        );
        materialsSend.add(item);
      }

      final recipe = Recipe(recipeId: recipeId, recipeMaterials: materialsSend);

      bool isUpdated = await ProductAPIServer.instance.updateRecipe(recipe);

      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (isUpdated) {
        final success = widget.notifyUser(
          context,
          'Cập nhật thành công!',
          fontStyleBaloo(_fontSize, color: Colors.white),
          Colors.green[900]!,
        );
        await success.closed;
        if (!mounted) return;
        Get.back(result: recipe);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final error = widget.notifyUser(
        context,
        'Cập nhật thất bại!',
        fontStyleBaloo(_fontSize, color: Colors.white),
        Colors.red[900]!,
      );
      await error.closed;
    } finally {
      blocker.remove();
      if (mounted) {
        _formKey.currentState?.reset();
        for (final controller in _controllers) controller.clear();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final recipe = product.recipe;
    final List<MaterialItem> materials = recipe?.materials ?? [];
    final materialCount = materials.length < _controllers.length
        ? materials.length
        : _controllers.length;
    final spacing = Global.spacing;
    return Scaffold(
      appBar: TitleAppBar(title: 'Cập nhật công thức'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(spacing),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      for (var i = 0; i < materialCount; i++) ...[
                        _buildPercentField('${materials[i].materialName}:', i),
                        if (i < materialCount - 1) SizedBox(height: spacing),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            filledBtn(
              _isLoading ? null : () => _checkValidator(product),
              'Cập nhật',
              color: _buttonColor,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration() {
    final primaryBlue = Global.primaryBlue;
    return InputDecoration(
      labelStyle: fontStyleInter(_fontSize, color: primaryBlue),
      contentPadding: contentPadding(),
      hintText: 'Cập nhật tỷ lệ (%)',
      hintStyle: fontStyleInter(_fontSize, color: primaryBlue),
      border: outlineInputBorder(),
      enabledBorder: outlineInputBorder(),
      focusedBorder: outlineInputBorder(),
    );
  }

  Widget _buildPercentField(String title, int index) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(title, style: fontStyleBaloo(_fontSize)),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: _controllers[index],
            enabled: !_isLoading,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
            ],
            decoration: _fieldDecoration(),
            validator: mesIFieldValidator('Vui lòng nhập tỷ lệ!'),
          ),
        ),
      ],
    );
  }

  double _adaptPercent(List<TextEditingController> controllers) {
    double sum = 0.0;
    for (final controller in controllers) {
      final value = double.tryParse(controller.text.trim());
      sum += value ?? 0;
    }
    return sum == 0 ? 0 : 100.0 / sum;
  }
}
