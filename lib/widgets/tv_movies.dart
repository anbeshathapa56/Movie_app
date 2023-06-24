import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';

import '../description.dart';

class TV extends StatelessWidget {
  final List tv;
  const TV({Key? key, required this.tv}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModifiedText(
            text: "TV Shows",
            size: 23,
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 250,
            // width: 250,
            // height: 140,
            child: ListView.builder(
                itemCount: tv.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final movie = tv[index];
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
                      padding: EdgeInsets.all(10),
                      // decoration: BoxDecoration(
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Color(0xFF1E1E2C),
                      //       Color(0xFF111128),
                      //     ],
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //   ),
                      // ),
                      // width: 250,
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
                                        tv[index]['backdrop_path']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: ModifiedText(
                              text: tv[index]['original_name'] != null
                                  ? tv[index]['original_name']
                                  : 'Loading',
                              color: Colors.white,
                              size: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
