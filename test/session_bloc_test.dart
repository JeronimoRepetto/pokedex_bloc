import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_bloc/bloc/session_bloc.dart';
import 'package:pokedex_bloc/controller/screen_controller.dart';
import 'package:pokedex_bloc/models/common/basic_data.dart';
import 'package:pokedex_bloc/models/pokemon.dart';
import 'package:pokedex_bloc/models/session.dart';

class MockScreenController extends MockBloc implements ScreenController {
  List<Pokemon> pokemons = [
    Pokemon.fromJson(
      {
        "height": 7,
        "id": 1,
        "name": "Bulbasaur",
        "sprites": {
          "back_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
          "front_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
          "other": {
            "dream_world": {
              "front_default":
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg"
            }
          }
        },
        "weight": 69
      },
    ),
    Pokemon.fromJson(
      {
        "height": 7,
        "id": 1,
        "name": "Bulbasaur",
        "sprites": {
          "back_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
          "front_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
          "other": {
            "dream_world": {
              "front_default":
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg"
            }
          }
        },
        "weight": 69
      },
    ),
    Pokemon.fromJson({
      "height": 10,
      "id": 2,
      "name": "Ivysaur",
      "sprites": {
        "back_default":
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/2.png",
        "front_default":
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png",
        "other": {
          "dream_world": {
            "front_default":
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/2.svg"
          }
        }
      },
      "weight": 130
    })
  ];

  @override
  Future<List<BasicData>> getFilters() async {
    List<BasicData> filters = [
      BasicData.fromJson(
          {"name": "normal", "url": "https://pokeapi.co/api/v2/type/1/"}),
      BasicData.fromJson(
          {"name": "fighting", "url": "https://pokeapi.co/api/v2/type/2/"}),
      BasicData.fromJson(
          {"name": "flying", "url": " https://pokeapi.co/api/v2/type/3/"}),
      BasicData.fromJson(
          {"name": "poison", "url": "https://pokeapi.co/api/v2/type/4/"}),
      BasicData.fromJson(
          {"name": "ground", "url": "https://pokeapi.co/api/v2/type/5/"}),
      BasicData.fromJson(
          {"name": "rock", "url": "https://pokeapi.co/api/v2/type/6/"}),
      BasicData.fromJson(
          {"name": "bug", "url": "https://pokeapi.co/api/v2/type/7/"})
    ];
    return await Future.delayed(const Duration(seconds: 1))
        .then((value) => filters);
  }

  @override
  Future<List<Pokemon>> getPokemons() async {
    return await Future.delayed(const Duration(seconds: 2))
        .then((value) => pokemons);
  }

  @override
  Future<List<Pokemon>> getPokemonsByFilter(BasicData filter) async {
    return await Future.delayed(const Duration(seconds: 2))
        .then((value) => pokemons);
  }
}

void main() {
  sessionBlocTest();
}

void sessionBlocTest() {
  late SessionModel mockSessionModel;
  List<Pokemon> mockPokemons;
  List<BasicData> mockFilters;
  final SessionBloc sessionBloc = SessionBloc();
  final MockScreenController mockController = MockScreenController();

  group("SessionBloc Test", () {
    test("initial values are empty and de state is SessionInitial", () {
      expect(sessionBloc.state, isA<SessionInitial>());
      expect(sessionBloc.state.existPokemons, false);
      expect(sessionBloc.state.currentSession, null);
    });

    blocTest<SessionBloc, SessionState>(
      "Test all Events of SessionBloc",
      build: () {
        return sessionBloc;
      },
      act: (SessionBloc bloc) async {
        mockPokemons = await mockController.getPokemons();
        mockFilters = await mockController.getFilters();
        mockSessionModel =
            SessionModel(pokemons: mockPokemons, filters: mockFilters);
        return bloc
          ..add(ActivateSession(mockSessionModel))
          ..add(SelectFilter(mockFilters[0]))
          ..add(SelectPokemon(mockPokemons[0]))
          ..add(ResearchPokemons());
        /*..add(
            FilterPokemons(
                await mockController.getPokemonsByFilter(mockFilters[0])),
          );*/
      },
      expect: () => [
        isA<StartSession>(),
        isA<StartSession>(),
        isA<StartSession>(),
        isA<Searching>(),
        //isA<StartSession>()
      ],
    );

    test("""when state is Searching all values are full except existPokemons""",
        () {
      expect(sessionBloc.state, isA<Searching>());
      expect(sessionBloc.state.existPokemons, isFalse);
      expect(sessionBloc.state.currentSession, isNotNull);
      expect(sessionBloc.state.currentSession!.pokemonSelected, isNotNull);
      expect(sessionBloc.state.currentSession!.filterSelected, isNotNull);
      expect(sessionBloc.state.currentSession!.pokemons, isNotEmpty);
      expect(sessionBloc.state.currentSession!.filters, isNotEmpty);
    });
  });
}
