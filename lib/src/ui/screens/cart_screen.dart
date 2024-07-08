import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:online_shop/src/services/database_services/products_management_service.dart';
import 'package:online_shop/src/services/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void deleteCartItem(BuildContext context, String id) {
    ProductsManagementService.removeFromCart(context, id);
    context.read<CartProvider>().removeProduct(id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ProductsManagementService.fetchCartItems(context);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final cartItem = cart[index];

                return Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => deleteCartItem(context, cartItem.id),
                        label: 'Delete',
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(cartItem.imageUrl),
                      radius: 30,
                    ),
                    title: Text(
                      cartItem.title,
                      style: theme.textTheme.titleSmall,
                    ),
                    subtitle: cartItem.size != '-1' ? Text('Size: ${cartItem.size}') : null,
                    trailing: Text(
                      'x${cartItem.orderQuantity}',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${ProductsManagementService.calculateTotal(context)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70, top: 10, bottom: 15),
                    child: ElevatedButton.icon(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        fixedSize: const Size(230, 50),
                      ),
                      label: const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 20),
                      ),
                      icon: const Icon(Icons.arrow_forward_sharp, size: 30),
                      iconAlignment: IconAlignment.end,
                    ),
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
