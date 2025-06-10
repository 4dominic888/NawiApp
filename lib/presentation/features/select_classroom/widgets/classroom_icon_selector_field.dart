import 'package:flutter/material.dart';

class ClassroomIconSelectorField extends StatefulWidget {
  final int? initialIconCodePoint;
  final ValueChanged<int> onIconSelected;

  const ClassroomIconSelectorField({
    super.key,
    this.initialIconCodePoint,
    required this.onIconSelected,
  });

  @override
  State<ClassroomIconSelectorField> createState() => _ClassroomIconSelectorFieldState();
}

class _ClassroomIconSelectorFieldState extends State<ClassroomIconSelectorField> {
  late int selectedIcon;

  final List<IconData> classroomIcons = [
    Icons.school,
    Icons.class_,
    Icons.meeting_room,
    Icons.chair,
    Icons.laptop_chromebook,
    Icons.tv,
    Icons.desktop_windows,
    Icons.apple,
    Icons.lightbulb,
    Icons.people,
    Icons.favorite,
    Icons.grade
  ];

  @override
  void initState() {
    super.initState();
    selectedIcon = widget.initialIconCodePoint ?? classroomIcons.first.codePoint;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 80).floor().clamp(2, 6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            const Text("Selecciona un ícono para el Aula:"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Icon(
                IconData(selectedIcon, fontFamily: 'MaterialIcons'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: classroomIcons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, index) {
            final iconData = classroomIcons[index];
            final isSelected = selectedIcon == iconData.codePoint;
            return GestureDetector(
              onTap: () {
                setState(() {selectedIcon = iconData.codePoint;});
                widget.onIconSelected(iconData.codePoint);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor.withAlpha((0.2 * 255).toInt()) : null,
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, size: 32),
              ),
            );
          },
        ),
      ],
    );
  }
}