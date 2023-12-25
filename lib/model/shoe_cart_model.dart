
class ShoeCartModel{
  ShoeCartModel({
    required this.id,
    required this.shoeCode,
    required this.image,
    required this.name,
    required this.price,
    required this.size,
    required this.quantity,
    required this.idUser,
  });
  String id;
  String shoeCode;
  String name;
  String price;
  String image;
  double size;
  int quantity;
  final String? idUser;

  factory ShoeCartModel.fromJson(Map<String, dynamic> json) => ShoeCartModel(
    shoeCode: json["shoeCode"],
    image: json["image"],
    name: json["name"],
    price: json["price"],
    size: json["size"],
    quantity: json["quantity"],
    idUser: json["idUser"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "shoeCode": shoeCode,
    "name": name,
    "image": image,
    "price": price,
    "size": size,
    "quantity": quantity,
    "idUser": idUser,
    "id": id,
  };
}
