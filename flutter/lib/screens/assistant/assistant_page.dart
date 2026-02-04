import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:flutter/material.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';

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
      _messages.add(_ChatMessage(text: "HHello Hell Hello Hell Hello Hell Hello Hell Hello Hello oodfgdfgd dfgdfg dfgdfgdfgdfg dfgdf fdgddfhth ffgd fdgdffdg gfd dgdfsdds fddffgdfgddfgd fgdfd ooello Hello", isUser: false));
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: RTColorStyle.dark900.value,
      body: Column(
      	children: [
      	  Expanded(
      	    child: ListView.builder(
      	      padding: EdgeInsets.all(SW * 0.03),
      	      itemCount: _messages.length,
      	      itemBuilder: (context, index) {
      	        final message = _messages[index];
      	        return Align(
      	          alignment:
      	              message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      	          child: Container(
		    margin: message.isUser
			  ? EdgeInsets.only(left: SW * 0.13, right: SW * 0.01, top: SH * 0.005, bottom: SH * 0.005)
			  : EdgeInsets.only(right: SW * 0.13, left: SW * 0.01, top: SH * 0.005, bottom: SH * 0.005),
      	            padding: EdgeInsets.symmetric(vertical: SH * 0.01, horizontal: SW * 0.04),
      	            decoration: BoxDecoration(
      	              color: message.isUser
      	                  ? RTColorStyle.beige500.value 
      	                  : RTColorStyle.light800.value,
      	              borderRadius: BorderRadius.circular(12),
      	            ),
      	            child: Text(
      	              message.text,
      	              style: TextStyle(
      	                color: message.isUser ? RTColorStyle.light1000.value : RTColorStyle.dark1000.value,
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

