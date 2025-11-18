import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ChatMessage {
  final String id;
  String content;
  final bool isUser;
  bool isPartial;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    this.isPartial = false,
  });
}

class ChatService {
  final String? apiKey;
  ChatService([this.apiKey]);

  Future<String> sendMessage(String message) async {
    if (apiKey == null || apiKey!.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      return "🤖 (Dummy reply) You said: $message";
    }

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final resp = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body:
      '{"model":"gpt-4o-mini","messages":[{"role":"user","content":"$message"}],"temperature":0.2,"max_tokens":800}',
    );

    if (resp.statusCode >= 400) {
      throw Exception("API error ${resp.statusCode}: ${resp.body}");
    }

    final jsonData = jsonDecode(resp.body);
    return jsonData["choices"][0]["message"]["content"];
  }
}

/// Modern floating bubble with gradient
class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Container(
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
              colors: [Color(0xFF2F66F5), Color(0xFF5B8DFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
              : LinearGradient(
              colors: [Colors.grey.shade200, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: MarkdownBody(
          data: text,
          styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
                height: 1.3,
              )),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _uuid = const Uuid();
  late ChatService _service;
  bool _isSending = false;

  final String apiKey = "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"; // ← PUT YOUR KEY HERE

  final List<Map<String, String>> faqList = [
    {
      "question": "how do i send a message",
      "answer": "Type your message in the text field and press the send button."
    },
    {
      "question": "can i clear the chat",
      "answer": "Currently, you can restart the app to clear the chat."
    },
    {
      "question": "what is this app",
      "answer": "This is a Flutter AI chat app where you can ask anything and get AI responses."
    },
    {
      "question": "what features are inside",
      "answer": "Features include sending messages, typing animation, auto-scroll, and AI responses."
    },
    {
      "question": "who make this app",
      "answer": "hashem and yaman"
    },
  ];

  @override
  void initState() {
    super.initState();
    _service = ChatService(apiKey.isEmpty ? null : apiKey);

    _messages.add(ChatMessage(
      id: _uuid.v4(),
      content: "👋 Hello! Ask me anything.",
      isUser: false,
    ));
  }

  Future<String> handleUserQuery(String message) async {
    final lower = message.toLowerCase();
    for (var qa in faqList) {
      if (lower.contains(qa["question"]!)) {
        return qa["answer"]!;
      }
    }
    return await _service.sendMessage(message);
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      content: text,
      isUser: true,
    );

    setState(() {
      _messages.add(userMsg);
      _controller.clear();
      _isSending = true;
    });

    _scrollToBottom();

    final botMsg = ChatMessage(
      id: _uuid.v4(),
      content: "",
      isUser: false,
      isPartial: true,
    );

    setState(() => _messages.add(botMsg));
    _scrollToBottom();

    try {
      final reply = await handleUserQuery(text);
      await _typeWriter(botMsg, reply);
    } catch (e) {
      botMsg.content = "❌ Error: $e";
    }

    setState(() {
      botMsg.isPartial = false;
      _isSending = false;
    });

    _scrollToBottom();
  }

  Future<void> _typeWriter(ChatMessage msg, String fullText) async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 12));
      setState(() {
        msg.content = fullText.substring(0, i + 1);
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f7ff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "AI Chat Bot",
          style: TextStyle(
            color: Color(0xFF2F66F5),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 20, bottom: 80),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) {
                    final msg = _messages[i];
                    return MessageBubble(text: msg.content, isUser: msg.isUser);
                  },
                ),
              ),
            ],
          ),
          // Glassmorphic input bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _isSending ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2F66F5), Color(0xFF5B8DFB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: _isSending
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(Icons.send, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
