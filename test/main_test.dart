import 'package:flutter/material.dart';
import 'package:football_timeline_flutter/game_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff137a67), Color(0xff363d48)])),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Center(
                    child: Text(
                      gameData["gameDate"],
                  style: const TextStyle(color: Color(0xffa8cbc5)),
                )),
                backgroundColor: Colors.transparent,
              ),
              const ScoreBoard(),
              const Expanded(child: TimeLine()),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: Image.asset("assets/images/Barcelona.svg.png"),
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 50,
                decoration: BoxDecoration(
                    color: const Color(0xff2c524c),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  gameData["team1"]["endScore"].toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
              ),
              Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    gameData["team1"]["name"],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 50,
                decoration: BoxDecoration(
                    color: const Color(0xff2c524c),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  gameData["team2"]["endScore"].toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                )),
              ),
              Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    gameData["team2"]["name"],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: Image.asset("assets/images/FC_Arsenal.svg.png"),
          ))
        ],
      ),
    );
  }
}

class TimeLine extends StatelessWidget {
  const TimeLine({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gameData["gameHistory"].length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        int playTime = gameData["gameHistory"][index]["time"];
        int playerNumber = gameData["gameHistory"][index]["team"];
        String title = gameData["gameHistory"][index]["title"];
        String body = gameData["gameHistory"][index]["body"];
        double bodyLength = body.length.toDouble();
        double sideBoxHeight = bodyLength ~/ 30 * 30;
        bool isHalfTime = title.contains("Halftime");
        bool isEnd = title.contains("End");

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: playerNumber == 1
                      ? InfoBox(
                          title: title,
                          body: body,
                          teamNumber: playerNumber,
                        )
                      : const SizedBox.shrink(),
                ),
                Column(
                  children: [
                    Container(
                      height: sideBoxHeight,
                      width: 2,
                      color: Colors.black,
                    ),
                    if (isHalfTime) const HalfEndDisplayBox(text: "End of the first half"),
                    if (isEnd) const HalfEndDisplayBox(text: "End of the game. Arsenal won the game."),
                    if (!isHalfTime && !isEnd)
                      PlayTimeDisplay(
                        playTime: playTime,
                      ),
                    Container(
                      height: sideBoxHeight,
                      width: 2,
                      color: Colors.black,
                    ),
                  ],
                ),
                Expanded(
                  child: playerNumber == 2
                      ? InfoBox(
                          title: title,
                          body: body,
                          teamNumber: playerNumber,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class PlayTimeDisplay extends StatelessWidget {
  final int playTime;

  const PlayTimeDisplay({super.key, required this.playTime});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
              "$playTime'",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )));
  }
}

class InfoBox extends StatelessWidget {
  final String title;
  final String body;
  final int teamNumber;

  const InfoBox({super.key, required this.title, required this.body, required this.teamNumber});

  @override
  Widget build(BuildContext context) {
    double iconSize = 18;

    selectIcon() {
      bool isFoul = title.contains("Foul");
      bool isYellow = title.contains("Yellow");
      bool isRed = title.contains("Red");
      bool isGoal = title.contains("Gooo");
      bool isHurt = title.contains("Ouch");
      bool isOffside = title.contains("Offside");

      if (isFoul) return Image.asset("assets/icons/pfeifen.png");
      if (isYellow) return Image.asset("assets/icons/yellow-card.png");
      if (isRed) return Image.asset("assets/icons/red-card.png");
      if (isGoal) return Image.asset("assets/icons/soccer.png");
      if (isHurt) return Image.asset("assets/icons/first-aid-box.png");
      if (isOffside) return Image.asset("assets/icons/offside-flag.png");
    }

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(teamNumber == 1) Row(children: [
            const Expanded(child: SizedBox.shrink()),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            SizedBox(height: iconSize, width: iconSize, child: selectIcon()),
          ],),
          if(teamNumber == 2) Row(children: [
            SizedBox(height: iconSize, width: iconSize, child: selectIcon()),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],),
          Text(body, textAlign: teamNumber == 1 ? TextAlign.end : null,)
        ],
      ),
    );
  }
}

class HalfEndDisplayBox extends StatelessWidget {
  final String text;

  const HalfEndDisplayBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10)
    ), child: Text(text));
  }
}

