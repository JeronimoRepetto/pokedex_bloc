
class Sprites {
  Sprites({
    this.backDefault,
    this.frontDefault,
    required this.other,
  });

  dynamic backDefault;
  dynamic frontDefault;
  Other other;

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
      backDefault: json["back_default"],
      frontDefault: json["front_default"],
      other: Other.fromJson(json["other"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "back_default": backDefault,
        "front_default": frontDefault,
        "other": other.toJson(),
      };
}

class Other {
  Other({
    required this.dreamWorld,
  });

  DreamWorld dreamWorld;

  factory Other.fromJson(Map<String, dynamic> json) => Other(
        dreamWorld: DreamWorld.fromJson(json["dream_world"]),
      );

  Map<String, dynamic> toJson() => {
        "dream_world": dreamWorld.toJson(),
      };
}

class DreamWorld {
  DreamWorld({
    this.frontDefault,
  });

  dynamic frontDefault;

  factory DreamWorld.fromJson(Map<String, dynamic> json) {
    return DreamWorld(
      frontDefault: json["front_default"],
    );
  }

  Map<String, dynamic> toJson() => {
        "front_default": frontDefault,
      };
}
