import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movi_app/utils/fonts.dart';

import 'package:http/http.dart' as http;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, this.trendingMovies, this.id}) : super(key: key);

  final trendingMovies;
  final id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String youtubeKey = '';
  late YoutubePlayerController _controller;

  final String apiKey = '/videos?api_key=db763d7f17da238b29580baeba696685&language=en-US';
  final String video = 'https://api.themoviedb.org/3/movie/';

  Future<String> getVideosKey() async {
    try {
      var res = await http.get(Uri.parse(video + widget.id + apiKey), headers: {'accept': 'application/json'});

      if (res.statusCode == 200) {
        var result = jsonDecode(res.body);
        youtubeKey = result['results'][1]['key'];
        print(youtubeKey);
        if (mounted) {
          _controller = YoutubePlayerController(
              initialVideoId: youtubeKey,
              params: const YoutubePlayerParams(
                showControls: true,
              ));
        }

        return 'berhasil';
      } else {
        return 'Gagal';
      }
    } catch (e) {
      print(e);
      return 'Terjadi Kesalahan, Periksa Jaringan';
    }
  }

  @override
  void initState() {
    setState(() {
      getVideosKey();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      getVideosKey();
      _controller = YoutubePlayerController(
          initialVideoId: youtubeKey,
          params: const YoutubePlayerParams(
            showControls: true,
          ));
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Details',
          style: boldText.copyWith(fontSize: 32),
        ),
      ),
      body: FutureBuilder(
        future: getVideosKey(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .4,
                  child: YoutubePlayerIFrame(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListView(
                      children: [
                        Text(
                          widget.trendingMovies['original_title'],
                          style: boldText.copyWith(fontSize: 32),
                        ),
                        Divider(),
                        Text(
                          widget.trendingMovies['overview'],
                          style: normalText.copyWith(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Release Date:',
                              style: normalText.copyWith(fontSize: 14, color: Colors.grey[400]),
                            ),
                            Text(
                              widget.trendingMovies['release_date'],
                              style: normalText.copyWith(fontSize: 14, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Popularity:',
                              style: normalText.copyWith(fontSize: 14, color: Colors.grey[400]),
                            ),
                            Text(
                              widget.trendingMovies['popularity'].toString(),
                              style: normalText.copyWith(fontSize: 14, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rating:',
                              style: normalText.copyWith(fontSize: 14, color: Colors.grey[400]),
                            ),
                            Text(
                              widget.trendingMovies['vote_average'].toString(),
                              style: normalText.copyWith(fontSize: 14, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
