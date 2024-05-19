class Product {
  final String id;
  final String productName;
  final String productCode;
  final String image;
  final String unitePrice;
  final String totalPrice;
  final String quantity;

  Product(
      {required this.productName,
        required this.productCode,
        required this.totalPrice,
        required this.image,
        required this.quantity,
        required this.unitePrice,
        required this.id});
}
