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
	    height: SH * 0.1,
	    padding: EdgeInsets.all(SW * 0.03),
	    color: RTColorStyle.dark1000.value,
	    alignment: Alignment.bottomLeft,
	    child: Text(
	      "Твои вопросы",
	      style: RTFontStyle.appTitle.value,
	    ),
	  ),
	  ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Новый разговор"),
            onTap: () {
              aiProvider.clearCurrentConversation();
              Navigator.of(context).pop();
            },
          ),

          const Divider(),

	  Expanded(
            child: ListView.builder(
              itemCount: conversationList.length,
              itemBuilder: (context, index) {
                final c = conversationList[index];

                return ListTile(
                  title: Text(c.Title),
		  selected: aiProvider.selectedId == c.ID,
                  onTap: () async {
                    final aiProvider = context.read<AiProvider>();

                    aiProvider.selectConversation(c.ID);
                    await aiProvider.loadConversation(c.ID);

                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
	],
      ),
    );
  }
}
