import 'package:ollama/ollama.dart';

final ollama = Ollama();
// Or with a custom base URL:
// final ollama = Ollama(baseUrl: Uri.parse('http://your-ollama-server:11434'));




final stream = ollama.generate(
  'Tell me a joke about programming',
  model: 'llama3',
);

await for (final chunk in stream) {
  print(chunk.response);
}












final messages = [
  ChatMessage(role: 'user', content: 'Hello, how are you?'),
];

final stream = ollama.chat(
  messages,
  model: 'llama3',
);

await for (final chunk in stream) {
  print(chunk.message?.content);
}




final embeddings = await ollama.embeddings(
  'Here is an article about llamas...',
  model: 'llama3',
);

print(embeddings);