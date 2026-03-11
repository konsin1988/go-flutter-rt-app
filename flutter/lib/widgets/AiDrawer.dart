import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/features/ai/state/ai_provider.dart';


class AiDrawer extends StatelessWidget {
  const AiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    final aiProvider = context.watch<AiProvider>();
    if (aiProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final conversationList = aiProvider.conversationList;

    return Drawer(
      backgroundColor: RTColorStyle.dark900.value, 
      child: Column(
	children: [
	  Container(
	    height: SH * 0.105,
	    padding: EdgeInsets.only(bottom: SW * 0.03, top: SW * 0.03, left: SW * 0.08),
	    color: RTColorStyle.dark1000.value,
	    alignment: Alignment.bottomLeft,
	    child: Text(
	      "Твои беседы",
	      style: RTFontStyle.appTitle.value,
	    ),
	  ),
	  ListTile(
	    // leading: Icon(Icons.add, color: RTColorStyle.beige900.value),
	    title: Padding(
	      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
	      child: TextButton(
	        onPressed: () {
	          aiProvider.clearCurrentConversation();
	          Navigator.of(context).pop();
	        },
	        style: TextButton.styleFrom(
	          padding: EdgeInsets.zero, 
	          backgroundColor: RTColorStyle.beige400.value,
	          foregroundColor: RTColorStyle.light900.value,
		  animationDuration: const Duration(milliseconds: 200),
		  shadowColor: Colors.black26,
	          shape: RoundedRectangleBorder(
	            borderRadius: BorderRadius.circular(8), 
	          ),
	          elevation: 2, 
	        ),
	        child: Text(
	          "Новая беседа",
	          style: TextStyle(fontSize: SW * 0.04, fontWeight: FontWeight.bold),
	        ),
	      ),
	    ),
	  ),
          Divider(
	    color: RTColorStyle.light600.value,
	    thickness: 2, 
	  ),

	  Expanded(
	    child: Container(
	      color: RTColorStyle.light600.value, 
	      child: ListView.builder(
                itemCount: conversationList.length,
                itemBuilder: (context, index) {
                  final c = conversationList[index];
		  return InkWell(
                    onTap: () async {
                      final aiProvider = context.read<AiProvider>();

                      aiProvider.selectConversation(c.ID);
                      await aiProvider.loadConversation(c.ID);

                      Navigator.of(context).pop();
                    },
    		    child: Container(
    		      padding: EdgeInsets.symmetric(vertical: 4, horizontal: SW * 0.09),
    		      child: Row(
    		        children: [
    		          //CircleAvatar(radius: 20), 
    		          //SizedBox(width: 12),
    		          Expanded(
    		            child: Column(
    		              crossAxisAlignment: CrossAxisAlignment.start,
    		              mainAxisSize: MainAxisSize.min,
    		              children: [
    		                Text(
				  c.Title, 
				  style: TextStyle(
		  		    color: RTColorStyle.dark900.value, 
		  		    fontSize: SW * 0.035,
		  		    fontWeight: FontWeight.w700,
		  		  ),
				),
    		                //Text(conversation.preview, style: subtitleStyle),
    		              ],
    		            ),
    		          ),
			  Padding(
			    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1), 
			    child: Icon(
			      Icons.more_horiz, 
			      size: 20,
		  	      color: RTColorStyle.beige600.value, 
			    ),
			  )
    		        ],
    		      ),
    		    ),
    		  );
                },
              ),
	    ),
          ),
	],
      ),
    );
  }
}
