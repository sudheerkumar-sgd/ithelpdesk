import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';

class TicketTransferWidget extends StatelessWidget {
  final ValueNotifier _isUser = ValueNotifier(false);

  TicketTransferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          resources.string.forwardTo,
          style: context.textFontWeight600,
        ),
        SizedBox(
          height: resources.dimen.dp10,
        ),
        ValueListenableBuilder(
            valueListenable: _isUser,
            builder: (context, value, child) {
              return Row(
                children: [
                  Flexible(
                    child: RadioListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          resources.string.user,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp12),
                        ),
                        groupValue: value,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: true,
                        onChanged: (isChecked) {
                          _isUser.value = isChecked;
                        }),
                  ),
                  Flexible(
                    child: RadioListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          resources.string.department,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp12),
                        ),
                        groupValue: value,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: false,
                        onChanged: (isChecked) {
                          _isUser.value = isChecked;
                        }),
                  ),
                ],
              );
            }),
        SizedBox(
          height: resources.dimen.dp10,
        ),
        DropDownWidget(
            isEnabled: true,
            list: const ["test", "test2", "test3"],
            labelText: resources.string.department,
            hintText: resources.string.selectDepartment,
            fillColor: resources.color.colorWhite,
            borderRadius: 0),
        SizedBox(
          height: resources.dimen.dp10,
        ),
        DropDownWidget(
          isEnabled: true,
          list: const ["test", "test2", "test3"],
          labelText: resources.string.employee,
          hintText: resources.string.selectEmployeeName,
          fillColor: resources.color.colorWhite,
          borderRadius: 0,
        ),
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: ActionButtonWidget(
                text: resources.string.clear,
                color: resources.color.sideBarItemUnselected,
                textColor: resources.color.textColor,
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp20,
                    vertical: context.resources.dimen.dp7),
                textSize: resources.fontSize.dp12,
              ),
            ),
            SizedBox(
              width: resources.dimen.dp20,
            ),
            InkWell(
              onTap: () {},
              child: ActionButtonWidget(
                text: resources.string.submit,
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp20,
                    vertical: context.resources.dimen.dp7),
                textSize: resources.fontSize.dp12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
