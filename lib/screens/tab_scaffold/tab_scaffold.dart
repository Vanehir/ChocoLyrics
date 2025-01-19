import 'package:choco_lyrics/screens/explore/explore_cubit.dart';
import 'package:choco_lyrics/screens/favorites/favorite_screen.dart';
import 'package:choco_lyrics/screens/favorites/favorites_cubit.dart';
import 'package:choco_lyrics/screens/home/home_screen.dart';
import 'package:choco_lyrics/screens/explore/explore_screen.dart';
import 'package:choco_lyrics/ui/navigation/tabbar/tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:choco_lyrics/data/repositories/spotify/spotify_repository.dart';
import 'package:choco_lyrics/ui/favorites/favorite_handler.dart';

class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoritesCubit(
            favoriteHandler: FavoriteHandler(),
          )..loadFavorites(),
        ),
      ],
      child: CupertinoTabScaffold(
        tabBar: getCustomTabBar(),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              // Ora forniamo solo l'ExploreCubit qui, perché è specifico per l'ExploreScreen
              if (index == 1) {
                // ExploreScreen
                return BlocProvider(
                  create: (context) => ExploreCubit(
                    spotifyRepository: SpotifyRepository(),
                    favoritesCubit: context.read<FavoritesCubit>(),
                  ),
                  child: const ExploreScreen(),
                );
              }
              return _buildScreen(index);
            },
          );
        },
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ExploreScreen(); // Non dovrebbe mai essere chiamato
      case 2:
        return const FavoriteScreen();
      default:
        return const HomeScreen();
    }
  }
}
