import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_bloc/bloc/session_bloc.dart';
import 'package:pokedex_bloc/controller/screen_controller.dart';
import 'package:pokedex_bloc/models/session.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/common/basic_data.dart';
import '../../models/pokemon.dart';
import '../../services/pokemon_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late final sessionBloc;
  ScreenController controller = ScreenController();
  @override
  void initState() {
    sessionBloc = BlocProvider.of<SessionBloc>(context, listen: false);
    _startSession();
    super.initState();
  }

  _startSession() async {
    List<BasicData> filtersList = await controller.getFilters();
    List<Pokemon> pokemonsList = await controller.getPokemons();
    final SessionModel currentSession =
        SessionModel(pokemons: pokemonsList, filters: filtersList);
    sessionBloc.add(ActivateSession(currentSession));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0XFFE3350D),
          elevation: 2,
          title: Row(
            children: [
              SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset("assets/pokeball.png")),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  (sessionBloc.state is StartSession ||
                              sessionBloc.state is Searching) &&
                          sessionBloc.state.currentSession!.filterSelected !=
                              null
                      ? "Pokédex ${sessionBloc.state.currentSession!.filterSelected!.name}"
                      : "Pokédex",
                  style: const TextStyle(color: Colors.white),
                  textScaleFactor: 1,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (sessionBloc.state is StartSession ||
                      sessionBloc.state is Searching) {
                    _showFilters();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Espere a que se cargue el contenido",
                          textAlign: TextAlign.center),
                    ));
                  }
                },
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ))
          ],
        ),
        body: BlocBuilder<SessionBloc, SessionState>(
            builder: (_, state) => state is! StartSession
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.red,
                  ))
                : SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: state.currentSession!.pokemons.isNotEmpty,
                    enablePullDown: false,
                    onLoading: () async {
                      sessionBloc
                          .add(AddPokemons(await controller.getPokemons()));
                      _refreshController.loadComplete();
                    },
                    child: state.currentSession!.pokemons.isNotEmpty
                        ? ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.currentSession!.pokemons.length,
                            separatorBuilder: (_, index) =>
                                const Divider(indent: 80),
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: _imgPokemon(
                                      state.currentSession!.pokemons[index]),
                                ),
                                title: Text(
                                    state.currentSession!.pokemons[index].name,
                                    textScaleFactor: 1,
                                    style: TextStyle(color: Colors.grey[800])),
                                onTap: () {
                                  sessionBloc.add(SelectPokemon(
                                      state.currentSession!.pokemons[index]));
                                  Navigator.pushNamed(context, "detail");
                                },
                              );
                            })
                        : Center(
                            child: Text(
                                "No hay pokemons de tipo ${state.currentSession!.filterSelected!.name}"),
                          ),
                  )));
  }

  _imgPokemon(Pokemon pokemon) {
    return pokemon.sprites.other.dreamWorld.frontDefault != null
        ? SvgPicture.network(pokemon.sprites.other.dreamWorld.frontDefault)
        : pokemon.sprites.frontDefault != null
            ? Image.network(pokemon.sprites.frontDefault)
            : Image.asset("assets/noimg1.png");
  }

  _showFilters() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child:
                  BlocBuilder<SessionBloc, SessionState>(builder: (_, state) {
                return Scaffold(
                    appBar: AppBar(
                      elevation: 1,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Selecciona el tipo",
                              style: TextStyle(color: Colors.grey[800])),
                        ],
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey[800],
                            ))
                      ],
                    ),
                    body: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.currentSession!.filters.length,
                        separatorBuilder: (_, index) => const Divider(),
                        itemBuilder: (context, index) =>
                            _filterTile(state, index)));
              }));
        });
  }

  _filterTile(SessionState state, int i) {
    return ListTile(
      title: Text(state.currentSession!.filters[i].name,
          textScaleFactor: 1,
          style: TextStyle(
              color: state.currentSession!.filterSelected != null &&
                      state.currentSession!.filters[i].name ==
                          state.currentSession!.filterSelected!.name
                  ? Colors.blue
                  : Colors.grey[800])),
      onTap: () {
        _dataFilter(state, state.currentSession!.filters[i]);
        setState(() {});
      },
    );
  }

  _dataFilter(SessionState state, BasicData filterSelected) async {
    sessionBloc.add(SelectFilter(filterSelected));
    sessionBloc.add(ResearchPokemons());
    sessionBloc.add(
        FilterPokemons(await controller.getPokemonsByFilter(filterSelected)));
  }
}
