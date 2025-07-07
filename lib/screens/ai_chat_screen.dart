import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/ai_chat_provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<AIChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: chatProvider.scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final msg = chatProvider.messages[index];
                return ChatBubble(
                  text: msg.text,
                  isUser: msg.isUser,
                );
              },
            ),
          ),
          if (chatProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          const Divider(height: 1),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final chatProvider = Provider.of<AIChatProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: chatProvider.messageController,
                decoration: const InputDecoration(
                  hintText: 'Ask something...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) {
                  if (!chatProvider.isLoading) {
                    chatProvider.sendMessage();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: chatProvider.isLoading
                  ? null
                  : () => chatProvider.sendMessage(),
            ),
          ],
        ),
      ),
    );
  }
}
