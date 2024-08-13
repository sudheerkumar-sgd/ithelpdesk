// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';

import '../../../injection_container.dart';

class TicketTransferWidget extends StatelessWidget {
  final TicketEntity ticketEntity;
  TicketTransferWidget({required this.ticketEntity, super.key});
  final ValueNotifier _isForword = ValueNotifier(true);
  final ValueNotifier _isForwordToEmployee = ValueNotifier(false);
  final ValueNotifier _selectedDepartment = ValueNotifier(0);
  var _selectedEmployee = 0;
  final _masterDataBloc = sl<MasterDataBloc>();

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return BlocProvider(
      create: (context) => _masterDataBloc,
      child: Column(
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
              valueListenable: _isForword,
              builder: (context, value, child) {
                return Row(
                  children: [
                    Flexible(
                      child: RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            resources.string.forwardTo,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp12),
                          ),
                          groupValue: true,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: value,
                          onChanged: (isChecked) {
                            _isForword.value = true;
                            _selectedDepartment.value = 0;
                          }),
                    ),
                    Flexible(
                      child: RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            resources.string.transfer,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp12),
                          ),
                          groupValue: true,
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: !value,
                          onChanged: (isChecked) {
                            _isForword.value = false;
                            _selectedDepartment.value = -1;
                          }),
                    ),
                  ],
                );
              }),
          ValueListenableBuilder(
              valueListenable: _isForword,
              builder: (context, value, child) {
                return value
                    ? const SizedBox()
                    : FutureBuilder(
                        future:
                            _masterDataBloc.getDepartments(requestParams: {}),
                        builder: (context, snapShot) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: DropDownWidget(
                              isEnabled: true,
                              list: snapShot.data?.items ?? [],
                              labelText: resources.string.department,
                              hintText: resources.string.selectDepartment,
                              fillColor: resources.color.colorWhite,
                              borderRadius: 0,
                              callback: (value) {
                                _selectedDepartment.value = value.id;
                              },
                            ),
                          );
                        });
              }),
          ValueListenableBuilder(
              valueListenable: _isForword,
              builder: (context, value, child) {
                return value
                    ? ValueListenableBuilder(
                        valueListenable: _isForwordToEmployee,
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: RadioListTile(
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Text(
                                          'Next Level',
                                          style: context.textFontWeight400
                                              .onFontSize(
                                                  resources.fontSize.dp12),
                                        ),
                                        groupValue: true,
                                        visualDensity: const VisualDensity(
                                            horizontal: -4, vertical: -4),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: !_isForwordToEmployee.value,
                                        onChanged: (isChecked) {
                                          _isForwordToEmployee.value = false;
                                        }),
                                  ),
                                  Flexible(
                                    child: RadioListTile(
                                        contentPadding: const EdgeInsets.all(0),
                                        title: Text(
                                          'Employee',
                                          style: context.textFontWeight400
                                              .onFontSize(
                                                  resources.fontSize.dp12),
                                        ),
                                        groupValue: true,
                                        visualDensity: const VisualDensity(
                                            horizontal: -4, vertical: -4),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: _isForwordToEmployee.value,
                                        onChanged: (isChecked) {
                                          _isForwordToEmployee.value = true;
                                        }),
                                  ),
                                ],
                              ),
                              if (value)
                                FutureBuilder(
                                    future: _masterDataBloc
                                        .getAssignedEmployees(requestParams: {
                                      'departmentID':
                                          UserCredentialsEntity.details()
                                              .departmentID,
                                      'subcategoryID':
                                          ticketEntity.subCategoryID,
                                      'categoryID': ticketEntity.categoryID,
                                    }),
                                    builder: (context, snapShot) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: resources.dimen.dp10),
                                        child: DropDownWidget(
                                          isEnabled: true,
                                          list: snapShot.data?.items ?? [],
                                          labelText: resources.string.employee,
                                          hintText: resources
                                              .string.selectEmployeeName,
                                          fillColor: resources.color.colorWhite,
                                          borderRadius: 0,
                                          callback: (value) {
                                            _selectedEmployee = value.id;
                                          },
                                        ),
                                      );
                                    }),
                            ],
                          );
                        })
                    : const SizedBox();
              }),
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
                onTap: () {
                  Navigator.pop(context, {
                    'isForword': _isForword.value,
                    'isForwordToEmployee': _isForwordToEmployee.value,
                    'employee': _selectedEmployee,
                    'department': _selectedDepartment.value
                  });
                },
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
      ),
    );
  }
}
