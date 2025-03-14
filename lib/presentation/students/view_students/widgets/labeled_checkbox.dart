import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key, 
    this.title, this.contentPadding,
    required this.value, required this.onChanged,
    this.onTap, this.activeColor, this.fontSize,
    this.gap = 4.0
  });

  final Widget? title;
  final EdgeInsets? contentPadding;
  final bool value;
  final void Function()? onTap;
  final void Function(bool? value) onChanged;
  final Color? activeColor;
  final double? fontSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: contentPadding ?? const EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
              value: value,
              activeColor: activeColor,
              visualDensity: VisualDensity.compact,
              onChanged: onChanged,
            ),
            SizedBox(width: gap),
            if(title != null) Flexible(child: title!)
          ],
        ),
      ),
    );
  }
}