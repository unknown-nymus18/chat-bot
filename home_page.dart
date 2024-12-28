import 'package:chat_bot/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:groq/groq.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<List> chats = ValueNotifier<List>([]);
  TextEditingController textController = TextEditingController();
  ScrollController controller = ScrollController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus && chats.value.isNotEmpty) {
        _scrollToBottom();
      }
    });
    super.initState();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

// 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
  void botResponse(String input) async {
    final groq = Groq(
        apiKey: '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',
        model: 'llama3-8b-8192');
    groq.startChat();
    GroqResponse response = await groq.sendMessage(input);
    setState(() {
      chats.value.add([response.choices.first.message.content, 0]);
    });
    _scrollToBottom();
  }

  void sendPrompt() {
    if (textController.text.isNotEmpty) {
      setState(() {
        chats.value.add([textController.text, 1]);
      });
      botResponse(textController.text);
      textController.clear();
    }
  }

  Widget text() {
    return Expanded(
      child: TextField(
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white),
        controller: textController,
        cursorColor: Colors.white,
        maxLines: null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 17, 17),
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
          "CHATBOT",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: chats,
              builder: (context, items, child) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'START CHAT WITH BOT',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                        chat: items[index][0], alignment: items[index][1]);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 80,
            color: Colors.grey[900],
            child: Row(
              children: [
                text(),
                IconButton(
                  color: Colors.blue,
                  onPressed: sendPrompt,
                  icon: const Icon(
                    Icons.send_rounded,
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
