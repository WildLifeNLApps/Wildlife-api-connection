class InteractionType {
  final int id;
  final String name;
  final String description;

  InteractionType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory InteractionType.fromJson(Map<String, dynamic> json) {
    return InteractionType(
      id: json['ID'],
      name: json['nameNL'],
      description: json['descriptionNL'],
    );
  }
}
