import 'package:flutter/material.dart';
import '../../core/extensions/build_context_extension.dart';
import '../../core/extensions/text_style_extension.dart';

enum RadioItemsType {
  horizontal,
  vertical,
  wrap,
}

class RadioItemsWidget extends StatelessWidget {
  final RadioItemsType type;
  final List<dynamic> items;
  final dynamic selectedItem;
  final Function(dynamic) onItemSelected;
  RadioItemsWidget(
      {required this.items,
      required this.onItemSelected,
      this.selectedItem,
      this.type = RadioItemsType.horizontal,
      super.key});
  final ValueNotifier<dynamic> _selectedItem = ValueNotifier<dynamic>(null);
  Widget _getItem(BuildContext context, dynamic item) {
    return InkWell(
      onTap: () async {
        _selectedItem.value = item;
        onItemSelected(item);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.0,
              child: SizedBox(
                width: 10,
                height: 10,
                child: Radio<dynamic>(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: item,
                    groupValue: _selectedItem.value,
                    onChanged: (dynamic value) async {
                      _selectedItem.value = value;
                      onItemSelected(value);
                    }),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp10,
            ),
            Expanded(
              child: Text(
                item.toString(),
                style: context.textFontWeight500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectedItem.value = selectedItem;
    return ValueListenableBuilder(
        valueListenable: _selectedItem,
        builder: (context, value, child) {
          return type == RadioItemsType.vertical
              ? Column(
                  children: List.generate(items.length, (index) {
                  return _getItem(context, items[index]);
                }))
              : type == RadioItemsType.wrap
                  ? Wrap(
                      children: List.generate(items.length, (index) {
                      return _getItem(context, items[index]);
                    }))
                  : Row(
                      children: List.generate(items.length, (index) {
                      return Expanded(child: _getItem(context, items[index]));
                    }));
        });
  }
}
