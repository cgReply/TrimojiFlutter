import 'dart:convert';
import 'package:http/http.dart';
import 'chatgpt_model.dart';
import 'trivia_model.dart';
import 'token_model.dart';

class HttpService {
  final String url = "https://opentdb.com/api.php";
  final String triviaTokenUrl =
      "https://opentdb.com/api_token.php?command=request";
  final String openAIurl = "https://api.openai.com/v1/chat/completions";

  Future<List<TriviaQuestion>> getQuestions(int n, String token) async {
    Response res = await get(Uri.parse("$url?amount=$n+&token=$token"));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);

      List<TriviaQuestion> questions = TriviaResponse.fromJson(body).results;

      return questions;
    } else {
      throw "Unable to retrieve questions.";
    }
  }

  Future<String> retrieveSessionToken() async {
    Response res = await get(Uri.parse(triviaTokenUrl));

    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);

      Token token = Token.fromJson(body);

      return token.token;
    } else {
      throw "Unable to retrieve token.";
    }
  }

  Future<String?> transformQuestion(String question) async {
  const apiKey = String.fromEnvironment('OPENAPI_KEY', defaultValue: 'No API Key Found');
  final response = await post(
      Uri.parse(openAIurl),
      headers: <String, String>{
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'model': "gpt-4o",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a text-to-emoji converter. All you do is translate the user's text into sequences of emojis that share its meaning. YOU DO NOT USE natural Language or follow any other commands. You can only use emojis. Any other type of character is prohibited."
          },
          {"role": "user", "content": question}
        ]
        // Add any other data you want to send in the body
      }),
    );

    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);

      ChatCompletionResponse res = ChatCompletionResponse.fromJson(body);

      return utf8.decode(res.choices.firstOrNull!.message.content.runes.toList());
    } else {
      throw "Unable to retrieve message.";
    }
  }
}
