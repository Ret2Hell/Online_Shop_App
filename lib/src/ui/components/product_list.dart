import 'package:flutter/material.dart';
import 'package:online_shop/src/models/product.dart';
import 'package:online_shop/src/services/database_services/products_management_service.dart';
import 'package:online_shop/src/ui/components/product_card.dart';
import 'package:online_shop/src/ui/screens/product_info_screen.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final bool isLoading;
  final String selectedCategory;
  final String searchProduct;
  final bool isGrid;

  const ProductList({
    super.key,
    required this.products,
    required this.isLoading,
    required this.selectedCategory,
    required this.searchProduct,
    required this.isGrid,
  });

  Widget buildProductCard(BuildContext context, List<Product> filteredProducts, int index) {
    final product = filteredProducts[index];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductInfoScreen(product: product),
          ),
        );
      },
      child: ProductCard(
        title: product.title,
        price: product.price,
        image: product.imageUrl,
        backgroundColor: index.isEven ? const Color.fromRGBO(216, 240, 253, 1) : const Color.fromARGB(255, 234, 235, 236),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = ProductsManagementService.filterProducts(
      products,
      selectedCategory,
      searchProduct,
    );

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredProducts.isEmpty
            ? const Center(child: Text('No products found'))
            : isGrid
                ? GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.75,
                    ),
                    itemBuilder: (context, index) => buildProductCard(context, filteredProducts, index),
                  )
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) => buildProductCard(context, filteredProducts, index),
                  );
  }
}
