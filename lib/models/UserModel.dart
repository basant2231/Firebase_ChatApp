


//i am making a model the same fields in the firestore
class UserModel {
  String? id;
  String? name;
  String? email;
  String? imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageURL': imageUrl,
    };
  }

 static fromJson({required Map<String, dynamic> data}) {
    return UserModel(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      imageUrl: data['imageURL'] as String,
    );
  }

  
}
