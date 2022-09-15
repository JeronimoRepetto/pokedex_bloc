import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/session_bloc.dart';
import '../widgets/data_tile.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _sessionBloc = BlocProvider.of<SessionBloc>(context, listen: false).state.currentSession!;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0XFFE3350D),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            elevation: 2,
            title: Text(
              _sessionBloc.pokemonSelected!.name,
              textScaleFactor: 1,
              style: const TextStyle(color: Colors.white),
            )),
        body: SingleChildScrollView(
          child: Card(
              margin: const EdgeInsets.all(15),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _frontAndBackImage(context,
                            _sessionBloc.pokemonSelected!.sprites.frontDefault),
                        _frontAndBackImage(context,
                            _sessionBloc.pokemonSelected!.sprites.backDefault)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Text(
                        _sessionBloc.pokemonSelected!.name,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                        textScaleFactor: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Text(
                        _sessionBloc.pokemonSelected!.name,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.start,
                        textScaleFactor: 1,
                      ),
                    ),
                    DataTileWidget(
                        icon: Icons.speed_outlined,
                        text:
                        "Peso : ${_sessionBloc.pokemonSelected!.weight} kg"),
                    DataTileWidget(
                        icon: Icons.file_download_done_sharp,
                        text:
                        "Altura : ${_sessionBloc.pokemonSelected!.height} m"),
                  ],
                ),
              )),
        ));
  }

  Widget _frontAndBackImage(BuildContext context, image) {
    return SizedBox(
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width / 2.2
            : 200,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? 200
            : MediaQuery.of(context).size.height / 2.2,
        child: image != null
            ? Image.network(
          image,
          fit: BoxFit.fill,
        )
            : Image.asset("assets/noimg2.jpg")
    );
  }
}
