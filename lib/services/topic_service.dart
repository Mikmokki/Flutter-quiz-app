import 'package:http/http.dart' as http;
import 'dart:convert';

class TopicService {
  final http.Client client;
  TopicService({http.Client? client}) : client = client ?? http.Client();
  final _endpoint = 'https://dad-quiz-api.deno.dev';

  Future<List<Topic>> getTopics() async {
    var response = await client.get(Uri.parse("$_endpoint/topics"));
    List<dynamic> data = jsonDecode(response.body);
    List<Topic> res = data
        .map(
          (topic) => Topic(
            topic['id'] as int,
            topic['name'] as String,
            topic['question_path'] as String,
          ),
        )
        .toList();

    return res;
  }

  Future<Question> getQuestion(int id) async {
    var response =
        await client.get(Uri.parse('$_endpoint/topics/$id/questions'));
    var data = jsonDecode(response.body);
    return Question(
        data["id"],
        data["question"],
        (data["options"] as List<dynamic>).cast<String>(),
        data["answer_post_path"],
        data["image_url"]);
  }

  Future<bool> sendAnswer(String postPath, String answer) async {
    var response = await client.post(Uri.parse('$_endpoint$postPath'),
        body: jsonEncode({"answer": answer}));
    var data = jsonDecode(response.body);
    return data["correct"];
  }
}

class Topic {
  int id;
  String name;
  String questionPath;
  Topic(this.id, this.name, this.questionPath);

  @override
  String toString() {
    return "{id: $id, name: $name, questionPath: $questionPath}";
  }
}

class Question {
  int id;
  String question;
  List<String> options;
  String answerPostPath;
  String? imageUrl;
  Question(
      this.id, this.question, this.options, this.answerPostPath, this.imageUrl);

  @override
  String toString() {
    return "{id: $id, question: $question, options: $options, answerPostPath: $answerPostPath, imageUrl: $imageUrl}";
  }
}
