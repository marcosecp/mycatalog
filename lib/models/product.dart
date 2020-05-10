import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String description;
  String category;
  String image;
  int price;
  Timestamp createdAt;
  Timestamp updatedAt;

  Product();

  Product.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    category = data['category'];
    image = data['image'];
    price = data['price'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name' : name,
      'description' : description,
      'category' : category,
      'image' : image,
      'price' : price,
      'createdAt' : createdAt,
      'updatedAt' : updatedAt,
    };
  }
}