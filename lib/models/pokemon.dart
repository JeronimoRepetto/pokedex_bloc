import 'dart:convert';

import '../models/sprites.dart';

Pokemon pokemonFromJson(String str) => Pokemon.fromJson(json.decode(str));

String pokemonToJson(Pokemon data) => json.encode(data.toJson());

class Pokemon {
  Pokemon({
    required this.height,
    required this.id,
    required this.name,
    required this.sprites,
    required this.weight,
  });

  final int height;
  final int id;
  final String name;
  final Sprites sprites;
  final int weight;

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      Pokemon(
        height: json["height"],
        id: json["id"],
        name: json["name"].toString()[0].toUpperCase() +
            json["name"]
                .toString()
                .substring(1, json["name"]
                .toString()
                .length),
        sprites: Sprites.fromJson(json["sprites"]),
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() =>
      {
        "height": height,
        "id": id,
        "name": name,
        "sprites": sprites.toJson(),
        "weight": weight,
      };
}