import 'package:flutter/material.dart';
import 'package:app_for_scada/mixin/mixinFunctions.dart';
import 'package:flutter/services.dart';
import 'package:app_for_scada/widgets/titleAppBar.dart';
import 'package:app_for_scada/global.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';
import 'package:app_for_scada/mixin/mixinWidgetWithFunction.dart';
import 'package:app_for_scada/api/ProductAPIServer.dart';
import 'package:app_for_scada/model/Production/IngredientItem.dart';
import 'package:app_for_scada/model/Production/MaterialItem.dart';
import 'package:app_for_scada/model/Production/Recipe.dart';
import 'package:app_for_scada/model/Production/Product.dart';

class RecipeAdd extends StatefulWidget with mixinNotification {
  const RecipeAdd({super.key});

  @override
  State<RecipeAdd> createState() => _RecipeAddState();
}

class _RecipeAddState extends State<RecipeAdd>
    with
        fontStyleMixin,
        InputFieldDecorationMixin,
        itemDecorationMixin,
        mixinWidgetWithFunction,
        particularFunctionMixin {
  static const double _fontSize = 20;
  static const Color _buttonColor = Color(0xff00F3FF);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  final List<String?> _selectedIngredients = List<String?>.filled(5, null);
  bool _isLoading = false;
  List<IngredientItem> ingredientList = [];

  @override
  void initState() {
    super.initState();
    _getAllIngredients();
  }

  Future<void> _getAllIngredients() async {
    try {
      final apiIngredients = await ProductAPIServer.instance
          .getAllIngredients();
      if (!mounted) return;

      setState(() {
        ingredientList = apiIngredients
            .where((e) => e.materialId != null && e.materialName != null)
            .map(
              (e) => IngredientItem(
                materialId: e.materialId!,
                materialName: e.materialName!,
              ),
            )
            .toList();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => ingredientList = []);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) controller.dispose();
    super.dispose();
  }

  void _checkValidator() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    showConfirmDialog(
      title: 'Thêm công thức?',
      titleStyle: fontStyleBaloo(_fontSize),
      actionStyle: fontStyleBaloo(_fontSize),
      onConfirm: _handleModify,
    );
  }

  List<IngredientItem> _availableIngredients(int index) {
    final selectedOthers = _selectedIngredients
        .asMap()
        .entries
        .where((e) => e.key != index && e.value != null)
        .map((e) => e.value!)
        .toSet();

    return ingredientList
        .where((ing) => !selectedOthers.contains(ing.materialId))
        .toList();
  }

  Future<void> _handleModify() async {
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
      final materials = <MaterialItem>[];
      for (var i = 0; i < _controllers.length; i++) {
        final targetValue =
            calib * (double.tryParse(_controllers[i].text.trim()) ?? 0.0);
        final item = MaterialItem(
          materialId: _selectedIngredients[i]!,
          targetKg: targetValue,
          toleranceMinKg: targetValue - 1.0,
          toleranceMaxKg: targetValue + 1.0,
        );
        materials.add(item);
      }
      final recipe = Recipe(
        grindingTimeSeconds: 10,
        mixingTimeSeconds: 12,
        recipeName: _nameController.text.trim(),
        recipeMaterials: materials,
      );
      final idRecipe = await ProductAPIServer.instance.createRecipe(recipe);
      if (!mounted) return;
      Product product = Product(
        productName: _nameController.text.trim(),
        recipeId: idRecipe,
        weightPerPieceKg: 50,
      );
      print('Da tao product voi recipeId: ${product.recipeId}');
      bool isCreated = await ProductAPIServer.instance.createProduction(
        product,
      );
      print('Da tao production');
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (isCreated) {
        final success = widget.notifyUser(
          context,
          'Cập nhật thành công!',
          fontStyleBaloo(_fontSize, color: Colors.white),
          Colors.green[900]!,
        );
        await success.closed;
        if (!mounted) return;
        Navigator.pop(context,true);
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
          _selectedIngredients.fillRange(0, _selectedIngredients.length, null);
        });
      }
    }
  }

  InputDecoration _fieldDecoration({
    required String icon,
    required String hint,
    String label = '',
  }) {
    final primaryBlue = Global.primaryBlue;
    return InputDecoration(
      prefixIcon: prefixIconPadding(icon),
      labelText: label,
      labelStyle: fontStyleInter(_fontSize, color: primaryBlue),
      contentPadding: contentPadding(),
      hintText: hint,
      hintStyle: fontStyleInter(_fontSize, color: primaryBlue),
      border: outlineInputBorder(),
      enabledBorder: outlineInputBorder(),
      focusedBorder: outlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Global.spacing;
    return Scaffold(
      appBar: TitleAppBar(title: 'Thêm công thức'),
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
                      TextFormField(
                        controller: _nameController,
                        enabled: !_isLoading,
                        decoration: _fieldDecoration(
                          icon: 'lib/icons/percent.png',
                          hint: 'Thức ăn gà mái',
                          label: 'Tên công thức',
                        ),
                        validator: mesIFieldValidator(
                          'Vui lòng nhập tên công thức',
                        ),
                      ),
                      SizedBox(height: spacing),
                      for (var i = 0; i < _controllers.length; i++) ...[
                        _buildIngredientDropdown(i),
                        SizedBox(height: spacing),
                        _buildPercentField(i),
                        if (i < _controllers.length - 1)
                          SizedBox(height: spacing),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            filledBtn(
              _isLoading ? null : _checkValidator,
              'Thêm công thức',
              color: _buttonColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientDropdown(int index) {
    final primaryBlue = Global.primaryBlue;
    // ✅ Lấy danh sách đã lọc cho dropdown này
    final available = _availableIngredients(index);

    // ✅ Nếu giá trị đang chọn bị xóa khỏi available → reset về null
    final currentValue =
        available.any((ing) => ing.materialId == _selectedIngredients[index])
        ? _selectedIngredients[index]
        : null;

    return Theme(
      data: Theme.of(context).copyWith(hintColor: primaryBlue),
      child: DropdownButtonFormField<String>(
        icon: Icon(Icons.arrow_drop_down, color: primaryBlue),
        iconSize: 35,
        isExpanded: true,
        style: fontStyleInter(_fontSize, color: primaryBlue),
        borderRadius: BorderRadius.circular(10),
        dropdownColor: Colors.white,
        elevation: 4,
        value: currentValue, // ✅ Dùng value thay vì selectedValue local
        decoration: _fieldDecoration(
          icon: 'lib/icons/ingredient.png',
          hint: 'Chọn nguyên liệu ${index + 1}',
        ),
        // ✅ Chỉ hiện các ingredient chưa được chọn ở dropdown khác
        items: available
            .map(
              (p) => DropdownMenuItem(
                value: p.materialId,
                child: Text(p.materialName!),
              ),
            )
            .toList(),
        onChanged: _isLoading
            ? null
            : (value) {
                setState(() {
                  // ✅ Gán đúng vào list — rebuild sẽ filter lại tất cả dropdown
                  _selectedIngredients[index] = value;
                });
              },
        validator: mesDropdownValidation<String>('Vui lòng chọn nguyên liệu'),
      ),
    );
  }

  Widget _buildPercentField(int index) {
    return TextFormField(
      controller: _controllers[index],
      enabled: !_isLoading,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
      ],
      decoration: _fieldDecoration(
        icon: 'lib/icons/percent.png',
        hint: '10',
        label: 'Tỷ lệ (%) nguyên liệu ${index + 1}',
      ),
      validator: _percentValidator('Vui lòng nhập phần trăm'),
    );
  }

  FormFieldValidator<String> _percentValidator(String message) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }

      final number = double.tryParse(value.trim());
      if (number == null) {
        return 'Chỉ được nhập số';
      }

      if (number <= 0) {
        return 'Giá trị phải lớn hơn 0';
      }

      return null;
    };
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
