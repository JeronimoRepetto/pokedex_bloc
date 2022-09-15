import 'dart:convert';

import '../global/environment.dart';
import '../models/common/basic_data.dart';
import 'package:http/http.dart' as http;

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class ScreenController{

  Future<List<BasicData>> getFilters() async {
    List<BasicData> filters = await pokemonService.getFilters();
    return filters;
  }

  Future<List<Pokemon>> getPokemons() async {
    List<BasicData> basicData = await pokemonService.getPokemons();
    final List<Pokemon> newList = [];
    for (var element in basicData) {
      newList.add(await pokemonService.getPokemonDetail(element.url));
    }
    return newList;
  }

  Future<List<Pokemon>> getPokemonsByFilter(BasicData filter) async {
    List<BasicData> basicData = await pokemonService.getPokemonsByFilter(filter.url);
    final List<Pokemon> newList = [];
    for (var element in basicData) {
      newList.add(await pokemonService.getPokemonDetail(element.url));
    }
    return newList;
  }
}