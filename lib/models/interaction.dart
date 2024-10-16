import 'package:wildlife_api_connection/models/interaction_type.dart';
import 'package:wildlife_api_connection/models/location.dart';
import 'package:wildlife_api_connection/models/species.dart';
import 'package:wildlife_api_connection/models/user.dart';

class Interaction {
  User user;
  String description;
  Location location;
  Species species;
  InteractionType type;

  Interaction({
    required this.user,
    required this.description,
    required this.location,
    required this.species,
    required this.type,
  });

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
      user: User.fromJson(json['user']),
      description: json['description'],
      location: Location.fromJson(json['location']),
      species: Species.fromJson(json['species']),
      type: InteractionType.fromJson(json['type']),
    );
  }
}
