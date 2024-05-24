// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';

class MultiSelectDialogWidget<T> extends StatelessWidget {
  final List<T> list;
  final List<T> selectedItems;
  MultiSelectDialogWidget(
      {required this.list, this.selectedItems = const [], super.key});
  final ValueNotifier<List<T>> _selectedItems = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    _selectedItems.value.addAll(selectedItems);
    return Dialog(
      backgroundColor: context.resources.color.appScaffoldBg,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment:
                  isSelectedLocalEn ? Alignment.topRight : Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Dialogs.dismiss(context, value: _selectedItems.value);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    resources.string.done,
                    style: context.textFontWeight400
                        .onFontSize(context.resources.fontSize.dp14),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.resources.dimen.dp5,
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                      valueListenable: _selectedItems,
                      builder: (context, selectedItems, child) {
                        return InkWell(
                          onTap: () {
                            selectedItems.contains(list[index])
                                ? _selectedItems.value.remove(list[index])
                                : _selectedItems.value.add(list[index]);
                            _selectedItems.value =
                                List.from(_selectedItems.value);
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  value: selectedItems.contains(list[index]),
                                  onChanged: (isChecked) {
                                    isChecked == true
                                        ? _selectedItems.value.add(list[index])
                                        : _selectedItems.value
                                            .remove(list[index]);
                                    _selectedItems.value =
                                        List.from(_selectedItems.value);
                                  }),
                              SizedBox(
                                width: resources.dimen.dp10,
                              ),
                              Expanded(
                                child: Text(
                                  overflow: TextOverflow.clip,
                                  list[index].toString(),
                                  style: context.textFontWeight400,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: resources.dimen.dp10,
                  );
                },
                itemCount: list.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
