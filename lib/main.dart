import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widgets/toprated_movies.dart';
import 'package:movie_app/widgets/trending_movies.dart';
import 'package:movie_app/widgets/tv_movies.dart';
import 'package:tmdb_api/tmdb_api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List trendingmovies = [];
  List topratedmovies = [];
  List tv = [];
  String apikey = '60f7ca755acc621ce6afec5f886b76ee';
  final readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MGY3Y2E3NTVhY2M2MjFjZTZhZmVjNWY4ODZiNzZlZSIsInN1YiI6IjY0OTMxNTZiNjVlMGEyMDE0NDQyMjY3NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.IRZokVZSzmA1iw8Y5TXun722VHaYmV59JSdmjvn8jmQ';

  @override
  void initState() {
    loadmovies();
    super.initState();
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apikey, readaccesstoken),
        logConfig: ConfigLogger(
          showLogs: true,
          showErrorLogs: true,
        ));
    Map trendingresult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topratedresult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvresult = await tmdbWithCustomLogs.v3.tv.getPopular();

    setState(() {
      trendingmovies = trendingresult['results'];
      topratedmovies = topratedresult['results'];
      tv = tvresult['results'];
    });
    print(trendingmovies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Center(
          child: ModifiedText(
            text: 'Movie List',
            color: Color(0xffe50915),
            size: 30,
          ),
        ),
      ),
      body: ListView(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                // For Responsive
                // Wide screen layout
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TopRated(toprated: topratedmovies),
                    ),
                    Expanded(
                      flex: 1,
                      child: TV(tv: tv),
                    ),
                  ],
                );
              } else {
                // Narrow screen layout
                return Column(
                  children: [
                    TopRated(toprated: topratedmovies),
                    TV(tv: tv),
                  ],
                );
              }
            },
          ),
          TrendingMovies(trending: trendingmovies),
        ],
      ),
    );
  }
}
