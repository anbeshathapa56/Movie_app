import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widgets/toprated_movies.dart';
import 'package:movie_app/widgets/trending_movies.dart';
import 'package:movie_app/widgets/tv_movies.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:flutter/services.dart';

import 'description.dart';

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
  TextEditingController searchController = TextEditingController();
  List searchedMovies = [];
  void searchMovies(String query) {
    if (query.isEmpty) {
      setState(() {
        searchedMovies.clear();
      });
      return;
    }

    setState(() {
      searchedMovies = topratedmovies.where((movie) {
        final title = movie['title'] ?? '';
        return title.toLowerCase().startsWith(query.toLowerCase());
      }).toList();
    });
  }

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              controller: searchController,
              style: TextStyle(
                color: Colors.black,
              ),
              onChanged: (value) {
                searchMovies(value);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  )),
            ),
          ),
          SizedBox(height: 16),
          if (searchedMovies.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModifiedText(
                  text: 'Search Results',
                  size: 23,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Container(
                  height: 270,
                  child: ListView.builder(
                    itemCount: searchedMovies.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final movie = searchedMovies[index];
                      final title = movie['title'];
                      final overview = movie['overview'];
                      final backdropPath = movie['backdrop_path'];
                      final posterPath = movie['poster_path'];
                      final voteAverage = movie['vote_average'];
                      final releaseDate = movie['release_date'];
                      // Using the movie details to build the search result widget

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                name: title != null ? title : 'No Title',
                                description: overview != null
                                    ? overview
                                    : 'No Description',
                                bannerurl: backdropPath != null
                                    ? 'https://image.tmdb.org/t/p/w500$backdropPath'
                                    : '',
                                posterurl: posterPath != null
                                    ? 'https://image.tmdb.org/t/p/w500$posterPath'
                                    : '',
                                vote: voteAverage != null
                                    ? voteAverage.toString()
                                    : '0.0',
                                launch_on: releaseDate != null
                                    ? releaseDate
                                    : 'No Release Date',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: 140,
                          child: Column(
                            children: [
                              Container(
                                width: 133.33,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500' +
                                            posterPath),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: ModifiedText(
                                  text: title != null ? title : 'Loading',
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
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
