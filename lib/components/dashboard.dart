import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/movieService.dart';
import '../services/serviceException.dart';
import 'movie.dart';

final moviesFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;

  final movieService = ref.watch(movieServiceProvider);
  final movies = await movieService.getMovies();
  return movies;
});

class Dashboard extends ConsumerWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cinfo Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.red],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: ref.watch(moviesFutureProvider).when(
            error: (e, s) {
              if (e is ServiceException) {
                return _ErrorBody(message: '${e.message}');
              }
              return const _ErrorBody(
                  message: "Oops, something unexpected happened");
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (movies) {
              return RefreshIndicator(
                onRefresh: () async {
                  return ref.refresh(moviesFutureProvider);
                },
                child: GridView.extent(
                  maxCrossAxisExtent: 400,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 0.7,
                  children:
                      movies.map((movie) => _MovieBox(movie: movie)).toList(),
                ),
              );
            },
          ),
    );
  }
}

class _ErrorBody extends ConsumerWidget {
  const _ErrorBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => ref.refresh(moviesFutureProvider),
            child: const Text("Try again"),
          ),
        ],
      ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final Movie movie;

  const _MovieBox({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.maxFinite,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _FrontBanner(text: movie.movieTitle),
        ),
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  const _FrontBanner({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  final heading = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
          height: 50,
          child: Center(
            child: Text(
              text,
              style: heading,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
