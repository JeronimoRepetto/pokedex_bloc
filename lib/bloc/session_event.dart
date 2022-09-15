part of 'session_bloc.dart';

@immutable
abstract class SessionEvent {}

class ActivateSession extends SessionEvent {
  final SessionModel session;
  ActivateSession(this.session);
}

class AddPokemons extends SessionEvent {
  final List<Pokemon> pokemons;
  AddPokemons(this.pokemons);
}

class FilterPokemons extends SessionEvent {
  final List<Pokemon> pokemons;
  FilterPokemons(this.pokemons);
}

class SelectPokemon extends SessionEvent {
  final Pokemon pokemonSelected;
  SelectPokemon(this.pokemonSelected);
}

class AddFilters extends SessionEvent {
  final List<BasicData> filters;
  AddFilters(this.filters);
}

class SelectFilter extends SessionEvent {
  final BasicData filter;
  SelectFilter(this.filter);
}

class ResearchPokemons extends SessionEvent {
  ResearchPokemons();
}
