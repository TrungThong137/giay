class Users {
  Users({
    this.idUser,
    this.fullName,
    this.emailAddress,
    this.pass,
  });

  final String? idUser;
  final String? fullName;
  final String? emailAddress;
  final String? pass;

  static Users fromJson(Map<String, dynamic> json) => Users(
        idUser: json['id'],
        fullName: json['name'],
        emailAddress: json['email'],
        pass: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'id': idUser,
        'name': fullName,
        'email': emailAddress,
        'password': pass,
      };
}
