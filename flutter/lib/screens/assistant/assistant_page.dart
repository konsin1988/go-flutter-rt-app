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

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final aiProvider = context.read<AiProvider>();
    _controller.clear();

    await aiProvider.sendMessage(text);
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

    return Scaffold(
      backgroundColor: RTColorStyle.dark900.value,
      body: Column(
      	children: [
	  Expanded(
      	    child: 
	      currentConversation == null 
	      ? Center(child: Text(
		"Введите Ваш запрос",
		style: TextStyle(
		  fontSize: SW * 0.055,
            	  fontWeight: FontWeight.w700,
		  fontFamily: "MuseoSans",
    		  color: RTColorStyle.light600.value,
		  ),
		),
	      )
	      : ListView.builder(
      	      padding: EdgeInsets.all(SW * 0.03),
	      reverse: true,
	      controller: ScrollController(),
	      itemCount: currentConversation?.Messages.length,
      	      itemBuilder: (context, index) {
		final reversedIndex = currentConversation!.Messages.length - 1 - index;
		final message = currentConversation!.Messages[reversedIndex];
      	        
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
            		fontSize: SW * 0.04,
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
		      maxLines: null,
		      minLines: 1,
		      keyboardType: TextInputType.multiline,
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


class EmptyAssistantPage extends StatelessWidget {
  const EmptyAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
