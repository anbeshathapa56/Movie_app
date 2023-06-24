import 'package:flutter/material.dart';
import 'package:movie_app/description.dart';
import 'package:movie_app/utils/text.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingMovies extends StatelessWidget {
  final List trending;
  const TrendingMovies({Key? key, required this.trending}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModifiedText(
            text: "Trending Movies",
            size: 23,
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 270,
            child: ListView.builder(
              itemCount: trending.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = trending[index];
                final title = movie['title'];
                final overview = movie['overview'];
                final backdropPath = movie['backdrop_path'];
                final posterPath = movie['poster_path'];
                final voteAverage = movie['vote_average'];
                final releaseDate = movie['release_date'];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: title != null ? title : 'No Title',
                          description:
                              overview != null ? overview : 'No Description',
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
                                posterPath != null
                                    ? 'https://image.tmdb.org/t/p/w500$posterPath'
                                    : '',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
    );
  }
}
