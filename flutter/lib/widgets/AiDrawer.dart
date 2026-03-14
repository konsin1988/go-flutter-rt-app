import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/features/ai/state/ai_provider.dart';


class AiDrawer extends StatelessWidget {
  const AiDrawer({super.key});

  Future<void> _deleteConversation(int id) async {
    
  }

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;
    final menuItems = [
      {'value': 'pin', 'label': 'Закрепить', 'color': RTColorStyle.light900.value},
      {'value': 'rename', 'label': 'Переименовать', 'color': RTColorStyle.light900.value},
      {'value': 'delete', 'label': 'Удалить', 'color': Colors.red},
    ];

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
	    //leading: Icon(Icons.add, color: RTColorStyle.beige900.value),
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
    		      padding: EdgeInsets.symmetric(vertical: SH * 0.001, horizontal: SW * 0.09),
    		      child: Row(
    		        children: [
    		          //CircleAvatar(radius: 5), 
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
		      	    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: SH * 0.0001), 
		      	    child: PopupMenuButton<String>(
			      color: RTColorStyle.beige400.value, 
  			      shape: RoundedRectangleBorder(
  			        borderRadius: BorderRadius.circular(12), 
  			        side: BorderSide(color: RTColorStyle.beige300.value, width: 1),
  			      ),
		      	      offset: Offset(SW * 0.3, -(SW * 0.23)),
  		      	      icon: Icon(
  		      	        Icons.more_horiz,
  		      	        size: 20,
  		      	        color: RTColorStyle.beige600.value,
  		      	      ),
  		      	      onSelected: (String value) {
  		      	        if (value == 'delete') {
				  aiProvider.deleteConversation(c.ID); 
  		      	        }
  		      	      },
			      itemBuilder: (BuildContext context) => [
			        for (var item in menuItems)
			          PopupMenuItem(
			            value: item['value'] as String,
				    height: SH * 0.026,
			            child: Text(
			              item['label'] as String,
			              style: TextStyle(
			                color: item['color'] as Color,
			                fontWeight: FontWeight.w700,
			                fontSize: SH * 0.015,
			              ),
			            ),
			          ),
			      ],
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
