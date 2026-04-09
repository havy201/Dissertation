import 'dart:convert';

class Recipe {
  String name;
  String ingredient1;
  int ratio1;
  String ingredient2;
  int ratio2;
  String ingredient3;
  int ratio3;
  String spice;
  int ratioSpice;
  String water;
  int ratioWater;

  Recipe({
    required this.name,
    required this.ingredient1,
    required this.ratio1,
    required this.ingredient2,
    required this.ratio2,
    required this.ingredient3,
    required this.ratio3,
    required this.spice,
    required this.ratioSpice,
    required this.water,
    required this.ratioWater,
  });

  Map<String, dynamic> toData() {
    return {
      'name': name,
      'ingredient1': ingredient1,
      'ratio1': ratio1,
      'ingredient2': ingredient2,
      'ratio2': ratio2,
      'ingredient3': ingredient3,
      'ratio3': ratio3,
      'spice': spice,
      'ratioSpice': ratioSpice,
      'water': water,
      'ratioWater': ratioWater,
    };
  }

  Map<String, dynamic> toMap() => toData();

  String toJson() => jsonEncode(toData());

  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(
      name: data['name'],
      ingredient1: data['ingredient1'],
      ratio1: data['ratio1'],
      ingredient2: data['ingredient2'],
      ratio2: data['ratio2'],
      ingredient3: data['ingredient3'],
      ratio3: data['ratio3'],
      spice: data['spice'],
      ratioSpice: data['ratioSpice'],
      water: data['water'],
      ratioWater: data['ratioWater'],
    );
  }

  factory Recipe.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return Recipe(
      name: map['name'],
      ingredient1: map['ingredient1'],
      ratio1: map['ratio1'],
      ingredient2: map['ingredient2'],
      ratio2: map['ratio2'],
      ingredient3: map['ingredient3'],
      ratio3: map['ratio3'],
      spice: map['spice'],
      ratioSpice: map['ratioSpice'],
      water: map['water'],
      ratioWater: map['ratioWater'],
    );
  }

  @override
  String toString() {
    return 'Recipe(name: $name, ingredient1: $ingredient1, ratio1: $ratio1, ingredient2: $ingredient2, ratio2: $ratio2, ingredient3: $ingredient3, ratio3: $ratio3, spice: $spice, ratioSpice: $ratioSpice, water: $water, ratioWater: $ratioWater)';
  }
}
