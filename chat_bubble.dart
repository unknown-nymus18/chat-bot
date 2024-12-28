// import 'dart:async';

import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String chat;
  final int alignment;
  const ChatBubble({super.key, required this.chat, required this.alignment});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.alignment == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: widget.alignment == 0
            ? const EdgeInsets.only(right: 50, top: 10, left: 7, bottom: 7)
            : const EdgeInsets.only(left: 50, top: 10, right: 7, bottom: 7),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.chat,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
