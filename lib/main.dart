import 'dart:async';

import 'package:flutter/material.dart';
import 'trivia_page.dart';
import 'native_share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Three Screen Navigation',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/questions': (context) => const TriviaQuestionsPage(
            title: 'Flutter Demo Home Page', numberOfTriviaQuestions: 10),
        '/end': (context) => const EndScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/questions');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // Start color
              Colors.purple // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
        ),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/questions'); // Navigate to Questions
          },
          child: const Text('Start Questions'),
        ),
      ),
    );
  }
}

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Result result = ModalRoute.of(context)?.settings.arguments as Result;

    return Scaffold(
        body: Stack(children: [
      Container(
        color: Colors.purple, // Colore del background
      ),
      Column(children: [
        Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, // Status bar height
              left: 16,
              right: 16,
              bottom: 12,
            ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20), // Rounded corners at the bottom
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Icon Action
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  // Action for the button
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 8),
              // Title
              const Text(
                'Trimoji',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        // Content of the page
        Expanded(
            child: Center(
          child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getMessage(result.correctAnswers),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/questions"); // Go back to Start
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Enabled color
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                padding: const EdgeInsets.all(10),
              ),
              child: const Text(style: TextStyle(color: Colors.black87),'Restart'),
            ),
            ElevatedButton(
              onPressed: () {
                NativeShare.shareText(
                    "Guarda che punteggio! Ho ottenuto ${result.correctAnswers} su ${result.totNumberOfQuestions}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Enabled color
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                padding: const EdgeInsets.all(10),
              ),
              child: const Text(style: TextStyle(color: Colors.black87),'Share'),
            ),
          ]),
       ])
            ))
      ])
    ]));
  }
}

class Result {
  final int correctAnswers;
  final int totNumberOfQuestions;

  Result({required this.correctAnswers, required this.totNumberOfQuestions});
}

String getMessage(int? number) {
    if(number==null) return '';
    return switch (number) {
    <= 0 => "Well, at least you tried. \uD83D\uDE05",
    < 5 => "Nice try! \uD83D\uDE04",
    < 10 => "Good job, you're on fire! \uD83D\uDD25",
    == 10 => "PERFECT! \uD83E\uDD29",
    _ => "Wait... did you hack something? \uD83E\uDDD1\u200D\uD83D\uDCBB"
  };
}