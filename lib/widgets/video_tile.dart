import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube_app/bloc/FavoriteBloc.dart';
import 'package:flutter_tube_app/models/video.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import '../api.dart';

class VideoTile extends StatelessWidget {

  final bloc = BlocProvider.getBloc<FavoriteBloc>();
  final Video video;

  VideoTile(this.video);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FlutterYoutube.playYoutubeVideoById(apiKey: API_KEY, videoId: video.id);
      },
      child: Container(
        color: Colors.white70,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text(
                            video.title,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            video.channel,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ],
                    )),
                StreamBuilder<Map<String,Video>>(
                  stream : bloc.outFav,
                  initialData: {},
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return IconButton(
                          color: Colors.grey,
                          iconSize: 38,
                          icon: Icon(snapshot.data.containsKey(video.id) ?
                          Icons.star : Icons.star_border
                          ),
                          onPressed: () {
                            bloc.toggleFavorite(video);
                          });
                    }else
                      return CircularProgressIndicator();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
