import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/common/basic_data.dart';
import '../models/pokemon.dart';
import '../models/session.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionInitial()) {
    on<ActivateSession>((event, emit) => emit(StartSession(event.session)));

    on<AddPokemons>((event, emit) {
      final List<Pokemon> pokemons = [
        ...state.currentSession!.pokemons,
        ...event.pokemons
      ];
      emit(StartSession(state.currentSession!.CopyWith(pokemons: pokemons)));
    });

    on<FilterPokemons>((event, emit) => emit(StartSession(
        state.currentSession!.CopyWith(pokemons: event.pokemons))));

    on<SelectPokemon>((event, emit) => emit(StartSession(state.currentSession!
        .CopyWith(pokemonSelected: event.pokemonSelected))));

    on<SelectFilter>((event, emit) => emit(StartSession(
        state.currentSession!.CopyWith(filterSelected: event.filter))));

    on<ResearchPokemons>(
        (event, emit) => emit(Searching(state.currentSession!)));
  }
}
