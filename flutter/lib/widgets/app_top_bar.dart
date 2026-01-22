import 'packages: flutter/material.dart'

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ImageProvider? leadingImage;

  const AppTopBar({
    super.key,
    required this.title,
    this.leadingImage,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      leading: leadingImage != null
	? Padding(
	    padding: const EdgeInsets.only(left: 12),
	    child: CircleAvatar(
	      backgroundImage: leadingImage,
	      radius: 18,
	    ),
	)
	: null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
