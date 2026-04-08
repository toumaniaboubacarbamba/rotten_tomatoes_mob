import 'package:flutter/material.dart';
import 'package:rotten_tomatoes/entities/movie.dart';
import 'package:rotten_tomatoes/ui/widgets/movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController? controller;
  final bool isLoadingMore;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const MovieGrid({
    super.key,
    required this.movies,
    this.controller,
    this.isLoadingMore = false,
    this.padding = const EdgeInsets.fromLTRB(12, 0, 12, 12),
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => MovieCard(movie: movies[index]),
              childCount: movies.length,
            ),
          ),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }
}
