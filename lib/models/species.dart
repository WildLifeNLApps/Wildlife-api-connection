class Species {
  final String id;
  final String name;
  final String commonNameNL;
  final String commonNameEN;

  Species({
    required this.id,
    required this.name,
    required this.commonNameNL,
    required this.commonNameEN,
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      id: json['ID'],
      name: json['name'],
      commonNameNL: json['commonNameNL'],
      commonNameEN: json['commonNameEN'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'commonNameNL': commonNameNL,
      'commonNameEN': commonNameEN,
    };
  }
}
