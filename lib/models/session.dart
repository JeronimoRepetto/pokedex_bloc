import 'package:pokedex_bloc/models/pokemon.dart';

import 'common/basic_data.dart';

class SessionModel {
  Pokemon? pokemonSelected;
  BasicData? filterSelected;
  List<Pokemon> pokemons;
  List<BasicData> filters;

  SessionModel(
      {this.pokemonSelected,
      this.filterSelected,
      required this.pokemons,
      required this.filters});

  SessionModel CopyWith({
    Pokemon? pokemonSelected,
    BasicData? filterSelected,
    List<Pokemon>? pokemons,
    List<BasicData>? filters,
  }) =>
      SessionModel(
          pokemonSelected: pokemonSelected ?? this.pokemonSelected,
          filterSelected: filterSelected ?? this.filterSelected,
          pokemons: pokemons ?? this.pokemons,
          filters: filters ?? this.filters);
}
