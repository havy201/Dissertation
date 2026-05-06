import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import '../../model/Production/Product.dart';
import '../../api/ProductAPIServer.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double itemSpacing = Global.spacing;
final double padding = Global.padding;
final double fontSize = 20;

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen>
    with fontStyleMixin, itemDecorationMixin {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = ProductAPIServer.instance.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Công thức'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: screenPadding(),
        child: RefreshIndicator(
          color: Color(0xFF032B91),
          strokeWidth: 3,
          onRefresh: _refreshProducts,
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Global.loadingIndicator();
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                print('Lỗi: ${snapshot.error}'); // Debug log
                print('Dữ liệu: ${snapshot.data}'); // Debug log

                String message = snapshot.hasError
                    ? 'Lỗi khi tải sản phẩm'
                    : 'Không có sản phẩm nào';
                return Global.errorIndicator(message, context);
              } else {
                return ListView(
                  reverse: false,
                  clipBehavior: Clip.none,
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => recipeCard(context, snapshot.data![index]),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: Global.currentUser?.role == 2
          ? Padding(
              padding: EdgeInsets.only(bottom: Global.spacing),
              child: floatingBtn(() {
                Navigator.pushNamed(context, '/recipeAdd').then((result) {
                  if (result == true) _refreshProducts();
                });
              }),
            )
          : null,
    );
  }

  GestureDetector recipeCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/recipeDetail', arguments: product).then((
          result,
        ) {
          if (result == true) _refreshProducts();
        });
      },
      child: Card(
        color: Color(0xffC2FCFF),
        margin: EdgeInsets.only(bottom: itemSpacing, top: 0, left: 0, right: 0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            product.productName ?? '',
            style: fontStyleBaloo(fontSize),
          ),
        ),
      ),
    );
  }
}
