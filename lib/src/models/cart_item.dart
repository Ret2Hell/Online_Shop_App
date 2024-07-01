class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String category;
  int orderQuantity;
  final String size;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.orderQuantity,
    required this.size,
  });
}
