// ignore_for_file: prefer_const_constructors

import 'package:bloc_api/data/api/bloc/live_game_bloc.dart';
import 'package:bloc_api/data/api/cubit/genre_cubit.dart';
import 'package:bloc_api/data/model/game.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> genres = ['Shooter', 'MMORPG', 'ARPG', 'Strategy', 'Fighting'];
  @override
  void initState() {
    super.initState();
    context.read<LiveGameBloc>().add(OnFetchLiveGame());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Live Games')),
        body: Column(
          children: [
            BlocBuilder<GenreCubit, String>(
              builder: (context, state) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: genres.map((genre) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              context.read<GenreCubit>().onSelected(genre);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(8),
                                  color: genre == state
                                      ? Theme.of(context).primaryColor
                                      : Colors.white),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Text(genre,
                                  style: TextStyle(
                                      color: genre == state
                                          ? Colors.white
                                          : Colors.black)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<LiveGameBloc, LiveGameState>(
                builder: (context, state) {
                  if (state is LiveGameLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LiveGameFailure) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  } else if (state is LiveGameLoaded) {
                    List<Game> games = state.games;
                    if (games.isEmpty) {
                      const Center(child: Text('Game is empty!'));
                    }

                    return BlocBuilder<GenreCubit, String>(
                      builder: (context, genreState) {
                        List<Game> list = games
                            .where((element) => element.genre == genreState)
                            .toList();
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8),
                            itemCount: list.length,
                            padding: const EdgeInsets.all(4),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              Game game = list[index];
                              return Stack(children: [
                                Positioned.fill(
                                  child: ExtendedImage.network(game.thumbnail,
                                      fit: BoxFit.cover, width: 300),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: const [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.center)),
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.all(4),
                                    child: Text(game.title,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                )
                              ]);
                            });
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ));
  }
}
