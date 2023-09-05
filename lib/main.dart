import 'package:flutter/material.dart';
import 'game_data.dart';

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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
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
              colors: [Color(0xff127a67), Color(0xff363d48)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: Center(
                child: Text(
                  gameData["gameDate"],
                  style: const TextStyle(color: Color(0xff363d48)),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
            const ScoreBoard(),
            const Expanded(child: TimeLine())
          ],
        ),
      ),
    ));
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
                  child: Image.asset(gameData["team1"]["image"]))),
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
                  ),
                ),
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
                  ),
                ),
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
                  child: Image.asset(gameData["team2"]["image"]))),
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
        itemBuilder: (context, index) {
          List gameHistory = gameData["gameHistory"];
          int playTime = gameHistory[index]["time"];
          int playerNumber = gameHistory[index]["team"];
          String title = gameHistory[index]["title"];
          String body = gameHistory[index]["body"];
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
                          : const SizedBox.shrink()),
                  Column(
                    children: [
                      Container(
                        height: sideBoxHeight,
                        width: 2,
                        color: Colors.black,
                      ),
                      if (isHalfTime)
                        const HalfEndDisplayBox(
                          text: "End of the first half",
                        ),
                      if (isEnd)
                        const HalfEndDisplayBox(
                          text: "End of the game. Arsenal won the game.",
                        ),
                      if (!isHalfTime && !isEnd)
                        PlayTimeDisplay(playTime: playTime),
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
                          : const SizedBox.shrink()),
                ],
              ),
              if (index == gameHistory.length - 1)
                const SizedBox(
                  height: 20,
                )
            ],
          );
        });
  }
}

class InfoBox extends StatelessWidget {
  final String title;
  final String body;
  final int teamNumber;

  const InfoBox(
      {super.key,
      required this.title,
      required this.body,
      required this.teamNumber});

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
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (teamNumber == 1)
            Row(
              children: [
                const Expanded(child: SizedBox.shrink()),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                    height: iconSize, width: iconSize, child: selectIcon()),
              ],
            ),
          if (teamNumber == 2)
            Row(
              children: [
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: selectIcon(),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          Text(
            body,
            textAlign: teamNumber == 1 ? TextAlign.end : null,
          )
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
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)),
      child: Text(text),
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
          "$playTime",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
