import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music/home/homeScreen.dart';
import 'package:permission_handler/permission_handler.dart';

class Musiclist extends StatefulWidget {
  const Musiclist({super.key});

  @override
  State<Musiclist> createState() => _MusiclistState();
}

class _MusiclistState extends State<Musiclist> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  int currentIndex = 0;

  List<SongInfo> songs = [];
  void getSongs() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSongs();
    requestPermission();
  }

  void requestPermission() async {
    await Permission.storage.request();
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          "Sangri-Musics",
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
        )),
      ),
      body: Stack(
        children: [
          ListView.separated(
              itemBuilder: (context, index) => ListTile(
                    leading: Icon(Icons.music_note_rounded),
                    title: Text(songs[index].title),
                    subtitle: Text(songs[index].artist),
                    trailing: Icon(Icons.more_horiz_outlined),
                    onTap: () {
                      currentIndex = index;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            songInfo: songs[currentIndex],
                          ),
                        ),
                      );
                    },
                  ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: songs.length),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: (){},
              child: CircleAvatar(
                radius: 25,
                child: Icon(Icons.play_arrow),
              ),
            ),
          )
        ],
      ),
    );
  }
}
