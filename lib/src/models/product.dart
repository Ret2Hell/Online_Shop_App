class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String category;
  final int stockQuantity;
  final List<String>? sizes;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stockQuantity,
    this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      imageUrl: json['image_url'],
      category: json['category'],
      stockQuantity: json['stock_quantity'],
      sizes: json['sizes'] != null ? List<String>.from(json['sizes']) : null,
    );
  }
}
