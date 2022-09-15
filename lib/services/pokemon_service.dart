import 'dart:convert';

import 'package:http/http.dart' as http;

import '../global/environment.dart';
import '../models/common/basic_data.dart';
import '../models/pokemon.dart';

final pokemonService = PokemonService();

class PokemonService {
  int _offset = 0;
  final _limit = 20;

  Future<List<BasicData>> getPokemons() async {
    List<BasicData> listBasicData = [];
    try {
      final result = await http.get(
          Uri.parse(
              '${Environment.apiUrl}/pokemon?offset=${_offset.toString()}&limit=${_limit.toString()}'),
          headers: {
            'Content-type': 'application/json',
          });
      var resultDecode = jsonDecode(result.body);
      if (resultDecode["next"] != null) _offset += _limit;

      listBasicData = _getBasicData(resultDecode["results"]);

      return listBasicData;
    } catch (error) {
      return [];
    }
  }

  Future<List<BasicData>> getPokemonsByFilter(String url) async {
    List<BasicData> listBasicData = [];
    try {
      final result = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      });
      var resultDecode = jsonDecode(result.body);
      listBasicData = _getBasicData(resultDecode["pokemon"]);

      return listBasicData;
    } catch (error) {
      return [];
    }
  }

  Future<List<BasicData>> getFilters() async {
    List<BasicData> filters = [];
    try {
      final result =
          await http.get(Uri.parse('${Environment.apiUrl}/type'), headers: {
        'Content-type': 'application/json',
      });
      for (var element in jsonDecode(result.body)["results"]) {
        filters.add(basicDataFromJson(element));
      }
      return filters;
    } catch (error) {
      return [];
    }
  }

  Future<Pokemon> getPokemonDetail(String url) async {
    try {
      final result = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      });
      Pokemon pokemon = pokemonFromJson(result.body);
      print(pokemon.toJson());
      bool frontDefault = false;
      bool backDefault = false;
      bool dreamFrontDefault = false;
      if (pokemon.sprites.frontDefault != null) {
        frontDefault = await _checkImg(pokemon.sprites.frontDefault);
      }
      if (pokemon.sprites.backDefault != null) {
        backDefault = await _checkImg(pokemon.sprites.backDefault);
      }
      if (pokemon.sprites.other.dreamWorld.frontDefault != null) {
        dreamFrontDefault =
            await _checkImg(pokemon.sprites.other.dreamWorld.frontDefault);
      }
      if (!frontDefault) {
        pokemon.sprites.frontDefault = null;
      }
      if (!backDefault) {
        pokemon.sprites.backDefault = null;
      }
      if (!dreamFrontDefault) {
        pokemon.sprites.other.dreamWorld.frontDefault = null;
      }
      return pokemon;
    } catch (error) {
      print("Error un URL: $url");
      throw Error();
    }
  }

  List<BasicData> _getBasicData(list) {
    List<BasicData> listResult = [];
    for (var pokemon in list) {
      if (pokemon["pokemon"] != null) {
        listResult.add(basicDataFromJson(pokemon["pokemon"]));
      } else {
        listResult.add(basicDataFromJson(pokemon));
      }
    }
    return listResult;
  }

  Future<bool> _checkImg(String link) async {
    final result = await http.get(Uri.parse(link), headers: {
      'Content-type': 'application/json',
    });
    if (result.statusCode != 200) return false;
    return true;
  }
}
