// models/order_model.dart
class OrderModel {
  final String id;
  final String clientId;
  final String description;
  final String address;
  final String entrance;
  final String comment;
  final String phone;
  final double price;
  final String status;
  final String? cleanerId;
  final DateTime? createdAt;

  OrderModel({
    required this.id,
    required this.clientId,
    required this.description,
    required this.address,
    required this.entrance,
    required this.comment,
    required this.phone,
    required this.price,
    required this.status,
    this.cleanerId,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      clientId: json['clientId'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      entrance: json['entrance'] ?? '',
      comment: json['comment'] ?? '',
      phone: json['phone'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      cleanerId: json['cleanerId'],
      // createdAt null емес екенін тексеру
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'description': description,
      'address': address,
      'entrance': entrance,
      'comment': comment,
      'phone': phone,
      'price': price,
      'status': status,
      'cleanerId': cleanerId,
    };
  }
}