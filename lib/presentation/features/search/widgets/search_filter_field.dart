import 'package:flutter/material.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';

class SearchFilterField extends StatelessWidget implements PreferredSizeWidget {

  const SearchFilterField({
    super.key, this.hintTextField, this.extraWidget = const [],
    required this.filterAction,
    required this.textOnChanged
  });

  final String? hintTextField;
  final VoidCallback filterAction;
  final List<Widget> extraWidget;
  final void Function(String text) textOnChanged;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: hintTextField,
                  border: InputBorder.none,
                  filled: true,
                  fillColor: NawiColorUtils.secondaryColor.withAlpha(110),                
                ),
                onChanged: textOnChanged,
                onTapOutside: (_) => FocusScope.of(context).unfocus()
              ),
            ),
        
            IconButton(
              style: ElevatedButton.styleFrom(backgroundColor: NawiColorUtils.secondaryColor),
              icon: const Icon(Icons.more_horiz_outlined),
              onPressed: filterAction
            ),

            Row(children: extraWidget)
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
