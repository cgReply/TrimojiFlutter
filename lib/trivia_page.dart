import 'dart:io';

import 'package:collection/collection.dart';
import 'package:emoji_trivia_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'http_service.dart';
import 'trivia_model.dart';

class TriviaQuestionsPage extends StatefulWidget {
  const TriviaQuestionsPage(
      {super.key, required this.title, required this.numberOfTriviaQuestions});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final int numberOfTriviaQuestions;

  @override
  State<TriviaQuestionsPage> createState() => _TriviaQuestionsPageState();
}

class _TriviaQuestionsPageState extends State<TriviaQuestionsPage>
    with TickerProviderStateMixin {
  List<Question> questions = [];
  int _counter = 0;
  String token = "";
  String? emojiQuestion;

  final HttpService httpService = HttpService();

  late AnimationController _controller;
  late Animation<Offset> _animation;
  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    super.initState();
    _startSession();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start off-screen to the right
      end: const Offset(0.0, 0.0), // Slide into its position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation2 = Tween<Offset>(
      begin: const Offset(0.0, -1.0), // Start off-screen to the right
      end: const Offset(0.0, 0.0), // Slide into its position
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeInOut));
  }

  void _incrementPage() async {
    if (_counter < widget.numberOfTriviaQuestions - 1) {
      var emoji =
          await httpService.transformQuestion(questions[_counter + 1].question);

      triggerAnimation();
      setState(() {
        _counter++;
        emojiQuestion = emoji;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void triggerAnimation() {
    _controller.reset(); // Reset the animation to the starting position
    _controller.forward(); // Play the animation
  }

  void triggerAnimationText() {
    _controller2.reset(); // Reset the animation to the starting position
    _controller2.forward(); // Play the animation
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            // "No" Button with Emoji
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('❌ No'),
            ),
            // "Yes" Button with Emoji
            TextButton(
              onPressed: () {
                // Close the app
                if (Platform.isAndroid) {
                  SystemNavigator.pop(); // For Android
                } else if (Platform.isIOS) {
                  exit(0); // For iOS
                }
              },
              child: const Text('✅ Yes'),
            ),
          ],
        );
      },
    );
  }

  void _startSession() async {
    var resToken = await httpService.retrieveSessionToken();
    var res = await httpService.getQuestions(
        widget.numberOfTriviaQuestions, resToken);
    var q = responseToQuestions(res);
    var emoji = await httpService.transformQuestion(q[0].question);

    triggerAnimation();
    setState(() {
      _counter = 0;
      questions = q;
      token = resToken;
      emojiQuestion = emoji;
    });
  }

  void _answer(int answerIndex) {
    var q = questions.mapIndexed((i, e) {
      if (i == _counter) {
        var eNew = Question(
            type: e.type,
            difficulty: e.difficulty,
            category: e.category,
            question: e.question,
            correctAnswerIndex: e.correctAnswerIndex,
            allAnswers: e.allAnswers,
            answered: answerIndex);
        return eNew;
      } else {
        return e;
      }
    }).toList();
    triggerAnimationText();
    setState(() {
      questions = q;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        body: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 0), // Padding around the column
            // Inner padding inside the column
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the column
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32)), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, // Status bar height
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    // Left Icon Action
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _showExitDialog(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    // Title
                    const Text(
                      'Trimoji',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
              // Content of the page
              Expanded(
                  child: Center(
                      child: questions.isNotEmpty
                          ?
                          // Column with Rounded Borders
                          Align(
                              alignment: Alignment.center,
                              child: SlideTransition(
                                  position: _animation,
                                  child: Column(children: [
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                emojiQuestion, // emoji characters
                                            style: const TextStyle(
                                                fontFamily: 'EmojiOne',
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ClipRect(
                                        child: SlideTransition(
                                            position: _animation2,
                                            child: questions[_counter]
                                                        .answered !=
                                                    null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30),
                                                    child: Text(
                                                      questions[_counter]
                                                          .question,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ))
                                                : null)),
                                    Column(
                                        children: questions[_counter]
                                            .allAnswers
                                            .mapIndexed((i, label) {
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                              bottom: 10),
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  questions[_counter]
                                                              .answered ==
                                                          i
                                                      ? const Color.fromARGB(
                                                          255, 132, 57, 144)
                                                      : null,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: questions[_counter]
                                                                .answered !=
                                                            null
                                                        ? Colors.grey
                                                        : Colors.black54,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        22), // <-- Radius
                                              ),
                                              minimumSize: const Size
                                                  .fromHeight(
                                                  60), // fromHeight use double.infinity as width and 40 is the height
                                            ),
                                            onPressed: () {
                                              questions[_counter].answered ==
                                                      null
                                                  ? _answer(i)
                                                  : () {};
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    child: questions[_counter]
                                                                    .answered !=
                                                                null &&
                                                            questions[_counter]
                                                                    .correctAnswerIndex ==
                                                                i
                                                        ? const CircleDot(
                                                            color: Colors.green)
                                                        : questions[_counter]
                                                                    .answered ==
                                                                i
                                                            ? const CircleDot(
                                                                color:
                                                                    Colors.red)
                                                            : const CircleDot(
                                                                color: Colors
                                                                    .white)),
                                                Text(
                                                  label,
                                                  style: TextStyle(
                                                      color: questions[_counter]
                                                                  .answered ==
                                                              null
                                                          ? Colors.black87
                                                          : questions[_counter]
                                                                      .answered ==
                                                                  i
                                                              ? Colors.white
                                                              : Colors.black54),
                                                )
                                              ],
                                            ),
                                          ));
                                    }).toList())
                                  ])),
                            )
                          : const CircularProgressIndicator()))
            ])),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.purple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (questions.isNotEmpty) // Left Text and Progress Bar
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Question ${_counter + 1} of ${widget.numberOfTriviaQuestions}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 130,
                        child: LinearProgressIndicator(
                          value:
                              (_counter + 1) / widget.numberOfTriviaQuestions,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.yellow),
                        ),
                      )
                    ],
                  ),
                ),
              if (questions.isNotEmpty)
                // Right Button
                ElevatedButton(
                  onPressed: () {
                    if (questions[_counter].answered != null) {
                      if (_counter >= widget.numberOfTriviaQuestions - 1) {
                        Navigator.pushReplacementNamed(context, '/end',
                            arguments: Result(
                                correctAnswers: questions
                                    .where((q) =>
                                        q.correctAnswerIndex == q.answered)
                                    .length,
                                totNumberOfQuestions: widget
                                    .numberOfTriviaQuestions)); // Navigate to End screen
                      } else {
                        _incrementPage();
                      }
                    }
                  }, // Button is disabled when condition is not met
                  style: ElevatedButton.styleFrom(
                    backgroundColor: questions[_counter].answered != null
                        ? Colors.yellow
                        : Colors.grey, // Enabled color
                    elevation: questions[_counter].answered != null ? 5 : 1,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Icon(
                    Icons.keyboard_double_arrow_right,
                    color: Colors.purple,
                  ),
                ),
            ],
          ),
        ));
  }
}

class CircleDot extends StatelessWidget {
  final Color color;

  const CircleDot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    double size = 20.0;

    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ));
  }
}
