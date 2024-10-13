import 'questions.dart'; // Make sure this import is correct

class EasyQuestions {
  // Original questions
  List<Map<String, dynamic>> _questions = [
    {
      'questionText': 'Remember and repeat the sequence of objects. Apple, Table, Penny.',
      'answer': 'apple table penny'
    },
    {
      'questionText': 'Subtract 7 from 100 and repeat.',
      'answer': '93'
    },
    {
      'questionText': 'Spell the word "WORLD" backwards.',
      // 'answer': ''['dlrow','d lrow','dl row','dlr ow','dlro w','dlro w','d l r o w','d l row','d lr ow','d lro w','d l r ow','d l ro w','dl r ow','dl ro w','dl r o w','dlr o w',]
      'answer': 'dlrow',
    },
    {
      'questionText': 'Repeat the sequence of objects.',
      'answer': 'apple, table, penny'
    },
  ];

  // Getter for the questions in Question type
  List<Question> get questions {
    int ind = 9;
    return _questions.map((q) {
      ++ind;
      print(ind);
      return Question(
        q['questionText'] as String,
        q['answer'] as String,
        QuestionType.text,
        ind
         // If your Question class has an answer field
      );
      
    }).toList();
  }
}
