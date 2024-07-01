import 'package:flutter/material.dart';
import 'package:online_shop/src/models/product.dart';
import 'package:online_shop/src/services/database_services/products_management_service.dart';

class ProductInfoScreen extends StatefulWidget {
  final Product product;
  const ProductInfoScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductInfoScreen> createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  String _selectedSize = '-1';
  var _isLoading = false;

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text(
              widget.product.title,
              style: theme.textTheme.titleLarge,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Hero(
              tag: widget.product.imageUrl,
              child: Image.network(
                widget.product.imageUrl,
                height: 250,
              ),
            ),
          ),
          const Spacer(flex: 2),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 234, 235, 236),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${widget.product.price}',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Align(
                    alignment: Alignment.center,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.sizes?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final size = widget.product.sizes?[index] ?? '';
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSize = size;
                                });
                              },
                              child: Chip(
                                label: Text(
                                  size,
                                ),
                                backgroundColor: _selectedSize == size ? Theme.of(context).colorScheme.primary : null,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            ProductsManagementService.addToCart(context, widget.product, _selectedSize, _toggleLoading);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      fixedSize: const Size(350, 50),
                    ),
                    label: Text(
                      _isLoading ? 'Adding to cart...' : 'Add To Cart',
                      style: const TextStyle(fontSize: 20),
                    ),
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
