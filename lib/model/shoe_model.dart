
class ShoeModel{
  ShoeModel({
    required this.shoeCode,
    required this.image,
    required this.name,
    required this.price,
  });
  String shoeCode;
  String name;
  String price;
  String image;

  factory ShoeModel.fromJson(Map<String, dynamic> json) => ShoeModel(
    shoeCode: json["shoeCode"],
    image: json["image"],
    name: json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "shoeCode": shoeCode,
    "name": name,
    "image": image,
    "price": price,
  };
}
