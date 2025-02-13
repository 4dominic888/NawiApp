import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MultiDropDownFormField<T extends Object> extends StatefulWidget {

  final Key formFieldKey;
  final List<DropdownItem<T>>? items;
  final List<T>? selectedItems;
  final String label;
  final String? errorText;
  final void Function()? onChanged;
  final Icon? icon;

  const MultiDropDownFormField({super.key,
    required this.formFieldKey,
    required this.label, this.errorText,
    this.items,
    this.onChanged,
    this.icon, this.selectedItems
  });

  @override
  State<MultiDropDownFormField<T>> createState() => _MultiDropDownFormFieldState<T>();
}

class _MultiDropDownFormFieldState<T extends Object> extends State<MultiDropDownFormField<T>> {

  final _controller = MultiSelectController<T>();

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      key: widget.formFieldKey,
      builder: (formState) {
        return MultiDropdown<T>(
          //* Selected items
          items: widget.items ?? [],
          controller: _controller,
          searchEnabled: true,
          chipDecoration: const ChipDecoration(wrap: true, runSpacing: 2, spacing: 10),
          fieldDecoration: FieldDecoration(
            hintText: widget.label,
            prefixIcon: widget.icon,
            showClearIcon: false,
            border: OutlineInputBorder(),
            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
          validator: (value) {
            if(value == null || value.isEmpty) return widget.errorText ?? "Campo requerido";
            return null;
          },
          onSelectionChange: (selectedItems) {
            formState.didChange(selectedItems);
            widget.onChanged?.call();
          },
        );
      }
    );
  }
}