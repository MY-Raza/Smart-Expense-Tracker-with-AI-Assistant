import 'package:flutter/material.dart';
import 'package:smart_expense_tracker_with_ai_assistant/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['OPENAI_API_KEY'];
class AIChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ChatMessage> get messages => _messages;

  Future<void> sendMessage() async {
    final userInput = messageController.text.trim();
    if (userInput.isEmpty) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userMessage = ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: userInput,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _saveMessageToFirestore(userMessage);
    messageController.clear();
    _isLoading = true;
    notifyListeners();
    _scrollToBottom();

    final responseText = await _getAIResponse(userInput);

    final aiMessage = ChatMessage(
      id: DateTime.now().toIso8601String(),
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(aiMessage);
    _saveMessageToFirestore(aiMessage);
    _isLoading = false;
    notifyListeners();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }
  Future<String> _getAIResponse(String input) async {
    try {
      final openAI = OpenAI.instance.build(
        token: apiKey ?? '',
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),
        enableLog: true,
      );

      final request = ChatCompleteText(
        messages: [
          {"role": "user", "content": _buildPrompt(input)}
        ],
        maxToken: 200,
        model: GptTurboChatModel(), // use GPT-3.5-Turbo
        // or use: model: Gpt4ChatModel(), // for GPT-4 if your key has access
      );

      final response = await openAI.onChatCompletion(request: request);

      return response?.choices.first.message?.content.trim() ??
          "No response";
    } catch (e) {
      print("AI error: $e");
      return "Oops! Something went wrong. Try again.";
    }
  }
  String _buildPrompt(String userInput) {
    return """
You are a smart personal finance assistant.
You help users manage their money based on expense data like:

- Monthly spending
- Categories (food, bills, travel)
- Budget goals

Here’s the user query:
"$userInput"

Respond with helpful suggestions, insights, or budgeting tips.
Keep it short and friendly.
""";
  }

  Future<void> _saveMessageToFirestore(ChatMessage message) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chatHistory')
        .add({
      'id': message.id,
      'text': message.text,
      'isUser': message.isUser,
      'timestamp': message.timestamp.toIso8601String(),
    });
  }

  Future<void> loadMessagesFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chatHistory')
        .orderBy('timestamp')
        .get();

    _messages.clear();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      _messages.add(
        ChatMessage(
          id: data['id'],
          text: data['text'],
          isUser: data['isUser'],
          timestamp: DateTime.parse(data['timestamp']),
        ),
      );
    }

    notifyListeners();
  }

}
