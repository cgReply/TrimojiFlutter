
class ChatCompletionResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final String systemFingerprint;
  final List<Choice> choices;
  final Usage usage;

  ChatCompletionResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.systemFingerprint,
    required this.choices,
    required this.usage,
  });

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) {
    return ChatCompletionResponse(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      systemFingerprint: json['system_fingerprint'],
      choices: List<Choice>.from(json['choices'].map((x) => Choice.fromJson(x))),
      usage: Usage.fromJson(json['usage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'created': created,
      'model': model,
      'system_fingerprint': systemFingerprint,
      'choices': List<dynamic>.from(choices.map((x) => x.toJson())),
      'usage': usage.toJson(),
    };
  }
}

class Choice {
  final int index;
  final Message message;
  final dynamic logprobs;
  final String finishReason;

  Choice({
    required this.index,
    required this.message,
    this.logprobs,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'],
      message: Message.fromJson(json['message']),
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'message': message.toJson(),
      'logprobs': logprobs,
      'finish_reason': finishReason,
    };
  }
}

class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
    };
  }
}
