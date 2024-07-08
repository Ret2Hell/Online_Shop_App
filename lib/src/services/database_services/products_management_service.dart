import 'package:flutter/material.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/src/models/cart_item.dart';
import 'package:online_shop/src/models/product.dart';
import 'package:online_shop/src/services/providers/cart_provider.dart';
import 'package:online_shop/src/ui/components/show_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsManagementService {
  static Future<void> fetchProducts(Function(List<Product>) updateProducts, Function(bool) toggleLoading) async {
    toggleLoading(true);

    final products = await supabase.from('products').select() as List<dynamic>;

    updateProducts(products.map((json) => Product.fromJson(json)).toList());
    toggleLoading(false);
  }

  static List<Product> filterProducts(List<Product> products, String selectedCategory, String searchProduct) {
    return products.where((product) {
      final matchesCategory = selectedCategory == "All" || product.category == selectedCategory;
      final matchesSearchQuery = searchProduct.isEmpty || product.title.toLowerCase().contains(searchProduct.toLowerCase());
      return matchesCategory && matchesSearchQuery;
    }).toList();
  }

  static Future<void> fetchCartItems(BuildContext context) async {
    final userId = supabase.auth.currentUser!.id;
    try {
      final data = await supabase.from('cart').select().eq('user_id', userId) as List<dynamic>;

      for (final item in data) {
        final convertedItem = item as Map<String, dynamic>;
        final productId = convertedItem['product_id'];
        final productData = await supabase.from('products').select().eq('id', productId).single();
        final product = Product.fromJson(productData);
        final cartItem = CartItem(
          id: item['id'].toString(),
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          category: product.category,
          orderQuantity: item['quantity'],
          size: item['size'],
        );
        if (context.mounted) {
          context.read<CartProvider>().addProduct(cartItem);
        }
      }
    } on AuthException catch (error) {
      if (context.mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (context.mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    }
  }

  static Future<void> addToCart(BuildContext context, Product product, String selectedSize, Function(bool) toggleLoading) async {
    if (selectedSize != '-1' || product.sizes == null) {
      toggleLoading(true);
      final userId = supabase.auth.currentUser?.id;
      final productId = product.id;
      final size = selectedSize;
      final data = await supabase.from('cart').select('quantity').eq('user_id', userId!).eq('product_id', productId).eq('size', size).select().maybeSingle();
      if (data != null) {
        final cartItemId = data['id'];
        try {
          await supabase.from('cart').update({
            'quantity': (data['quantity'] + 1)
          }).eq('id', cartItemId);
          if (context.mounted) {
            context.read<CartProvider>().increaseQuantity(cartItemId.toString());
            context.showSnackBar('Successfully added to cart!');
          }
        } on PostgrestException catch (error) {
          if (context.mounted) context.showSnackBar(error.message, isError: true);
        } catch (error) {
          if (context.mounted) {
            context.showSnackBar('Unexpected error occurred', isError: true);
          }
        } finally {
          if (context.mounted) {
            toggleLoading(false);
          }
        }
      } else {
        final orderedItem = {
          'user_id': userId,
          'product_id': productId,
          'size': size,
          'quantity': 1,
        };
        try {
          await supabase.from('cart').upsert(orderedItem);
          final cartItemData = await supabase.from('cart').select().eq('user_id', userId).eq('product_id', productId).eq('size', size).single();

          if (context.mounted) {
            context.read<CartProvider>().addProduct(CartItem(
                  id: cartItemData['id'].toString(),
                  title: product.title,
                  price: product.price,
                  imageUrl: product.imageUrl,
                  category: product.category,
                  orderQuantity: 1,
                  size: size,
                ));
            context.showSnackBar('Successfully added to cart!');
          }
        } on PostgrestException catch (error) {
          if (context.mounted) context.showSnackBar(error.message, isError: true);
        } catch (error) {
          if (context.mounted) {
            context.showSnackBar('Unexpected error occurred', isError: true);
          }
        } finally {
          if (context.mounted) {
            toggleLoading(false);
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a size!"),
        ),
      );
    }
  }

  static Future<void> removeFromCart(BuildContext context, String id) async {
    try {
      await supabase.from('cart').delete().eq('id', id);
    } on AuthException catch (error) {
      if (context.mounted) {
        context.showSnackBar(error.message, isError: true);
      }
    } catch (error) {
      if (context.mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    }
  }

  static String calculateTotal(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    double total = 0;
    for (final item in cart) {
      total += item.price * item.orderQuantity;
    }
    return total.toStringAsFixed(2);
  }
}
