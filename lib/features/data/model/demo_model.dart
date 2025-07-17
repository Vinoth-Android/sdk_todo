// only for response model
class DemoModel {
  int? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? website;

  DemoModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
  });

  // Factory constructor -> usage : DemoModel.fromJson(json)
  factory DemoModel.fromJson(Map<String, dynamic> json) {
    return DemoModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}
