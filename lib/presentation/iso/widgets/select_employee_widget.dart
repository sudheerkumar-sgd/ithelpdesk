// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/user_entity.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';

class SelectEmployeeWidget extends StatelessWidget {
  String? title;
  List<UserEntity> employees;
  SelectEmployeeWidget({this.title, required this.employees, super.key});
  UserEntity? _selectedEmployee;

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? resources.string.returnText,
          style: context.textFontWeight600,
        ),
        SizedBox(
          height: resources.dimen.dp10,
        ),
        Padding(
          padding: EdgeInsets.only(top: resources.dimen.dp10),
          child: DropDownWidget(
            isEnabled: true,
            list: employees,
            labelText: resources.string.employee,
            hintText: resources.string.selectEmployeeName,
            fillColor: resources.color.colorWhite,
            selectedValue: _selectedEmployee,
            borderRadius: 0,
            callback: (value) {
              _selectedEmployee = value as UserEntity;
            },
          ),
        ),
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ActionButtonWidget(
                text: resources.string.clear,
                color: resources.color.sideBarItemUnselected,
                textStyle: context.textFontWeight400,
                textColor: resources.color.textColor,
                radious: resources.dimen.dp15,
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
              onTap: () {
                Navigator.pop(context, {
                  'employeeId': _selectedEmployee?.id,
                  'employeeName': _selectedEmployee?.name,
                  'transferStepId': _selectedEmployee?.transferStepId
                });
              },
              child: ActionButtonWidget(
                text: resources.string.submit,
                radious: resources.dimen.dp15,
                textStyle: context.textFontWeight400,
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
