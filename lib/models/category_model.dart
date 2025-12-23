class CategoryModel {
  final String id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  /// Convert dari Appwrite Document
  factory CategoryModel.fromAppwrite(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['\$id'],
      name: json['name'] ?? '',
    );
  }

  /// Optional: kalau mau kirim balik ke Appwrite
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
