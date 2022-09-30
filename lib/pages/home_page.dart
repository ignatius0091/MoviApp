import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:movi_app/pages/detail_page.dart';
import 'package:movi_app/pages/widgets/search.dart';
import 'package:movi_app/utils/fonts.dart';
// import 'package:tmdb_api/tmdb_api.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List trendingMovies = [];
 

  final String apiKey = 'db763d7f17da238b29580baeba696685';
  final String url = 'https://api.themoviedb.org/3/trending/movie/day?api_key=';
  final String imagesUrl = 'https://image.tmdb.org/t/p/w200';

 

  Future<String> getMovies() async {
    try {
      var res = await http.get(Uri.parse(url + apiKey), headers: {'accept': 'application/json'});

      if (res.statusCode == 200) {
        var result = jsonDecode(res.body);

        trendingMovies = result['results'];

        print(trendingMovies);

        return 'Berhasil';
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
      getMovies();
    });
    // isLoaded = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      getMovies();
    });
    //  isLoaded = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    setState(() {
      getMovies();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.list,
                size: 32,
              ),
            ),
          ),
        ],
        title: Text(
          'MoviApp',
          style: boldText.copyWith(fontSize: 32),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Todays trending',
                style: boldText.copyWith(
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getMovies(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 30,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: trendingMovies.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                      trendingMovies: trendingMovies[index],
                                      id: trendingMovies[index]['id'].toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                // width: 200,
                                // color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        imagesUrl + trendingMovies[index]['poster_path'],
                                      ),
                                    ),
                                    Text(trendingMovies[index]['original_title'], maxLines: 1, overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 15,),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
