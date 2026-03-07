import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/features/ai/state/ai_provider.dart';

class AssistantPage extends StatefulWidget {
  @override
  _AssistantPageState createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add(_ChatMessage(text: text, isUser: true));

      // Mock AI response
      _messages.add(_ChatMessage(text: "Selected", isUser: false));
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    final aiProvider = context.watch<AiProvider>();
    if (aiProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final currentConversation = aiProvider.currentConversation;
    debugPrint("Current conversation from assistant page: ${currentConversation?.Messages}");

    return Scaffold(
      backgroundColor: RTColorStyle.dark900.value,
      body: Column(
      	children: [
	  Expanded(
      	    child: 
	      currentConversation == null 
	      ? Center(child: Text("Введите Ваш запрос"))
	      : ListView.builder(
      	      padding: EdgeInsets.all(SW * 0.03),
      	      //itemCount: _messages.length,
	      itemCount: currentConversation?.Messages.length,
      	      itemBuilder: (context, index) {
      	        //final message = _messages[index];
		final message = currentConversation?.Messages[index];
      	        return Align(
      	          alignment:
      	              message?.Role == "USER" ? Alignment.centerRight : Alignment.centerLeft,
      	          child: Container(
		    margin: message?.Role == "USER"
			  ? EdgeInsets.only(left: SW * 0.13, right: SW * 0.01, top: SH * 0.005, bottom: SH * 0.005)
			  : EdgeInsets.only(right: SW * 0.13, left: SW * 0.01, top: SH * 0.005, bottom: SH * 0.005),
      	            padding: EdgeInsets.symmetric(vertical: SH * 0.01, horizontal: SW * 0.04),
      	            decoration: BoxDecoration(
      	              color: message?.Role == "USER"
      	                  ? RTColorStyle.beige500.value 
      	                  : RTColorStyle.light800.value,
      	              borderRadius: BorderRadius.circular(12),
      	            ),
      	            child: Text(
      	              message?.Content ?? "",
      	              style: TextStyle(
      	                color: message?.Role == "USER" ? RTColorStyle.light1000.value : RTColorStyle.dark1000.value,
			fontFamily: "MuseoSans",
            		fontSize: 18,
            		//height: 36 / 32,
            		fontWeight: FontWeight.w500,
      	              ),
      	            ),
      	          ),
      	        );
      	      },
      	    ),
      	  ),
      	  Divider(height: 1, color: RTColorStyle.beige600.value, thickness: SH * 0.002),
      	  Container( 
	    color: RTColorStyle.light700.value,
	    child: Padding(
      	      padding: EdgeInsets.symmetric(horizontal: SW * 0.05, vertical: SH * 0.01),
      	      child: Row(
      	        children: [
      	          Expanded(
      	            child: TextField(
      	              controller: _controller,
		      cursorColor: RTColorStyle.dark800.value,
      	              decoration: InputDecoration(
      	                hintText: 'Введите Ваш вопрос...',
      	                border: OutlineInputBorder(
      	                  borderRadius: BorderRadius.circular(8),
    			  borderSide: BorderSide(
    			    color: RTColorStyle.beige300.value,
    			    width: 2,
    			  ),
      	                ),
    			focusedBorder: OutlineInputBorder(
    			  borderRadius: BorderRadius.circular(8),
    			  borderSide: BorderSide(
    			    color: RTColorStyle.dark800.value,
    			    width: 2,
    			  ),
    			),
      	              ),
      	              onSubmitted: (_) => _sendMessage(),
      	            ),
      	          ),
      	          SizedBox(width: 8),
      	          IconButton(
      	            icon: Icon(Icons.send),
      	            onPressed: _sendMessage,
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

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({required this.text, required this.isUser});
}

class EmptyAssistantPage extends StatelessWidget {
  const EmptyAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
