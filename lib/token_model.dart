class Token {
  final int responseCode;
  final String responseMessage;
  final String token;

  Token({
    required this.responseCode,
    required this.responseMessage,
    required this.token
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      responseCode: json['response_code'] as int,
      responseMessage: json['response_message'] as String,
      token: json['token'] as String,
    );
  }
}