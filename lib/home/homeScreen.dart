import 'package:flutter/material.dart';
import 'package:music/home/playerBlock.dart';
import 'package:music/musicList/musiclist.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  SongInfo songInfo;
  HomeScreen({required this.songInfo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool isPlaying = false;
  bool isRepeat = false;
  Color color = Colors.black;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSongs(widget.songInfo);
  }

  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void setSongs(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await audioPlayer.setUrl(widget.songInfo.uri);
  }

  void changeState() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      audioPlayer.play();
    } else {
      audioPlayer.pause();
    }

    audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 206, 192, 192),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Column(
            children: [
              //back and menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 58,
                    width: 58,
                    child: Player(
                        child: GestureDetector(
                      child: Icon(Icons.arrow_back),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Musiclist()));
                      },
                    )),
                  ),
                  Text(
                    "M U S I C  FOR  L I F E",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 8, 22, 177),
                    ),
                  ),
                  SizedBox(
                    height: 58,
                    width: 58,
                    child: Player(child: Icon(Icons.menu)),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Player(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: AssetImage('assets/images/cover.jpg'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Music is Magic",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "Vibe Today",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Icon(Icons.favorite)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),

              //cover art,artist name and song name

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(_position.toString().split(".")[0]),
                  IconButton(
                      onPressed: () {
                        audioPlayer.shuffleModeEnabled;
                      },
                      icon: Icon(Icons.shuffle)),
                  IconButton(
                      color: color,
                      onPressed: () {
                        if (isRepeat == false) {
                          audioPlayer.setLoopMode(LoopMode.one);
                          setState(() {
                            isRepeat = true;
                            color = Colors.blue;
                          });
                        } else if (isRepeat == true) {
                          audioPlayer.setLoopMode(LoopMode.off);
                          color = Colors.black;
                        }
                      },
                      icon: Icon(Icons.repeat)),
                  Text(_duration.toString().split(".")[0])
                ],
              ),

              //linear bar

              SizedBox(
                height: 30,
              ),
              Slider(
                  inactiveColor: Colors.black12,
                  activeColor: Colors.black,
                  min: 0.0,
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      changeToseconds(value.toInt());
                      value = value;
                    });
                  }),
              SizedBox(
                height: 30,
              ),

              //a box containing next,pause and previous optioned player unit
              SizedBox(
                height: 85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Player(
                          child: IconButton(
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          size: 40,
                        ),
                        onPressed: () {
                          audioPlayer.setSpeed(-1.5);
                        },
                      )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Player(
                          child: IconButton(
                              onPressed: () {
                                changeState();
                              },
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle
                                    : Icons.play_arrow,
                                size: 40,
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Player(
                          child: IconButton(
                              onPressed: () {
                                audioPlayer.setSpeed(1.5);
                              },
                              icon: Icon(
                                Icons.skip_next_rounded,
                                size: 40,
                              ))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeToseconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }
}
