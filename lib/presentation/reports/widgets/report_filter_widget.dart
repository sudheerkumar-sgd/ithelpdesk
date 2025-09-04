import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';

class ReportFilterWidget extends StatelessWidget {
  ReportFilterWidget({super.key});
  final ValueNotifier<bool> _onCheckedChange = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final columns = TicketEntity().toExcel().keys.map((e) {
      return <String, dynamic>{'title': e, 'isChecked': false};
    }).toList();
    return Column(
      children: [
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: List.generate(columns.length, (index) {
            return ValueListenableBuilder(
                valueListenable: _onCheckedChange,
                builder: (context, value, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(columns[index]['title'].toString().capitalize()),
                      Checkbox(
                          value: columns[index]['isChecked'] ?? false,
                          onChanged: (checked) {
                            _onCheckedChange.value = !(_onCheckedChange.value);
                            columns[index]['isChecked'] = checked;
                          })
                    ],
                  );
                });
          }),
        ),
        SizedBox(
          height: resources.dimen.dp30,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: ActionButtonWidget(
              text: resources.string.submit,
              radious: resources.dimen.dp15,
              textSize: resources.fontSize.dp14,
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp5,
                  horizontal: resources.dimen.dp15),
              color: resources.color.sideBarItemSelected),
        ),
      ],
    );
  }
}
