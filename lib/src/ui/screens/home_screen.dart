import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:online_shop/src/config/constants.dart';
import 'package:online_shop/src/models/product.dart';
import 'package:online_shop/src/services/database_services/products_management_service.dart';
import 'package:online_shop/src/ui/components/product_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _selectedCategory;
  String _searchProduct = '';
  List<Product> _products = [];
  bool _isLoading = false;

  final TextEditingController searchTextController = TextEditingController();

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _updateProducts(List<Product> products) {
    setState(() {
      _products = products;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories[0];
    ProductsManagementService.fetchProducts(_updateProducts, _toggleLoading);

    searchTextController.addListener(
      () {
        setState(() {
          _searchProduct = searchTextController.text;
        });
      },
    );
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: theme.colorScheme.secondary,
      ),
    );

    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Shop\nNow",
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: searchTextController,
                  style: theme.textTheme.titleSmall,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Chip(
                      backgroundColor: _selectedCategory == category ? Theme.of(context).colorScheme.primary : const Color.fromARGB(255, 234, 235, 236),
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      label: Text(category),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return LiquidPullToRefresh(
                  onRefresh: () async {
                    await ProductsManagementService.fetchProducts(_updateProducts, _toggleLoading);
                  },
                  color: Theme.of(context).colorScheme.primary,
                  child: ProductList(
                    products: _products,
                    isLoading: _isLoading,
                    selectedCategory: _selectedCategory,
                    searchProduct: _searchProduct,
                    isGrid: constraints.maxWidth > 1080,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
