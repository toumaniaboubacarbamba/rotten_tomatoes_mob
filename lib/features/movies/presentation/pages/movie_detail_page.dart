import 'package:flutter/material.dart';
import 'package:rotten_tomatoes/features/movies/domain/entities/movie.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [SliverAppBar(expandedHeight: 400, pinned: true)],
      ),
    );
  }
}
