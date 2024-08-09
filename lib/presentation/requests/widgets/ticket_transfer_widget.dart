import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';

import '../../../injection_container.dart';

class TicketTransferWidget extends StatelessWidget {
  final TicketEntity ticketEntity;
  TicketTransferWidget({required this.ticketEntity, super.key});
  final ValueNotifier _isForword = ValueNotifier(true);
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
          SizedBox(
            height: resources.dimen.dp10,
          ),
          ValueListenableBuilder(
              valueListenable: _selectedDepartment,
              builder: (context, value, child) {
                return FutureBuilder(
                    future: _masterDataBloc.getEmployees(requestParams: {
                      'departmentID': value == 0 ? 1 : value
                    }),
                    builder: (context, snapShot) {
                      return DropDownWidget(
                        isEnabled: true,
                        list: snapShot.data?.items ?? [],
                        labelText: resources.string.employee,
                        hintText: resources.string.selectEmployeeName,
                        fillColor: resources.color.colorWhite,
                        borderRadius: 0,
                        callback: (value) {
                          _selectedEmployee = value.id;
                        },
                      );
                    });
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
