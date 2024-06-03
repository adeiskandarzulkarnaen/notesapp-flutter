
class UserModel {
  final String id;
  final String username;
  final String fullname;
  final String? image;

  UserModel({
    required this.id,
    required this.username, 
    required this.fullname,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['id'], 
      username: json['username'], 
      fullname: json['fullname'],
      image: json['image'],
    );
  }
}