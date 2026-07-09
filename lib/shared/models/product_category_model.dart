class ProductCategoryModel {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  const ProductCategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProductCategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
