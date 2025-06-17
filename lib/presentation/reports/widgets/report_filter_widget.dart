import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class ReportFilterWidget extends StatelessWidget {
  ReportFilterWidget({super.key});
  final ValueNotifier<List<String>> filteredDates = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final categories = [
      resources.string.all,
      resources.string.assignedTickets,
      resources.string.myTickets,
      resources.string.employeeTickets,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              '${resources.string.filterByDate}: ',
              style:
                  context.textFontWeight600.onFontSize(resources.fontSize.dp10),
            ),
            SizedBox(
              width: resources.dimen.dp10,
            ),
            ValueListenableBuilder(
                valueListenable: filteredDates,
                builder: (context, value, child) {
                  return Container(
                    decoration: BackgroundBoxDecoration(
                            radious: resources.dimen.dp15,
                            boarderColor: resources.color.sideBarItemUnselected)
                        .roundedCornerBox,
                    padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp5,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: resources.dimen.dp10,
                        ),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now()
                                        .add(const Duration(days: -365)),
                                    lastDate: DateTime.now())
                                .then((dateTime) {
                              if (dateTime != null) {
                                filteredDates
                                    .value = List<String>.empty(growable: true)
                                  ..add(
                                      getDateByformat('yyyy/MM/dd', dateTime));
                              }
                            });
                          },
                          child: Text.rich(
                            TextSpan(
                                text: value.isNotEmpty
                                    ? value[0]
                                    : resources.string.startDate,
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: isSelectedLocalEn
                                          ? const EdgeInsets.only(left: 5.0)
                                          : const EdgeInsets.only(right: 5.0),
                                      child: const Icon(
                                        Icons.calendar_month_sharp,
                                        size: 16,
                                      ),
                                    ),
                                  )
                                ]),
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        SizedBox(
                          width: resources.dimen.dp10,
                        ),
                        InkWell(
                          onTap: () {
                            if (value.isNotEmpty) {
                              showDatePicker(
                                      context: context,
                                      initialDate: getDateTimeByString(
                                          'yyyy/MM/dd', value[0]),
                                      firstDate: getDateTimeByString(
                                          'yyyy/MM/dd', value[0]),
                                      lastDate: DateTime.now())
                                  .then((dateTime) {
                                if (dateTime != null) {
                                  filteredDates.value =
                                      List<String>.empty(growable: true)
                                        ..add(value[0])
                                        ..add(getDateByformat(
                                            'yyyy/MM/dd', dateTime));
                                }
                              });
                            } else {
                              Dialogs.showInfoDialog(
                                  context,
                                  PopupType.fail,
                                  resources.string.pleaseSelect +
                                      resources.string.startDate);
                            }
                          },
                          child: Text.rich(
                            TextSpan(
                                text: value.length > 1
                                    ? value[1]
                                    : resources.string.endDate,
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: isSelectedLocalEn
                                          ? const EdgeInsets.only(left: 5.0)
                                          : const EdgeInsets.only(right: 5.0),
                                      child: const Icon(
                                        Icons.calendar_month_sharp,
                                        size: 16,
                                      ),
                                    ),
                                  )
                                ]),
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp10),
                          ),
                        ),
                        SizedBox(
                          width: resources.dimen.dp5,
                        ),
                        InkWell(
                          onTap: () {
                            if (filteredDates.value.isNotEmpty) {
                              filteredDates.value = List.empty();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.clear,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: resources.dimen.dp5,
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Row(
          children: [
            Expanded(
              child: DropDownWidget<String>(
                height: 32,
                list: categories,
                labelText: "Tickets Type",
                selectedValue: null,
                iconSize: 20,
                fontStyle: context.textFontWeight400
                    .onFontSize(resources.fontSize.dp12),
                callback: (p0) {
                  //_selectedCategory = categories.indexOf(p0 ?? 'All');
                },
              ),
            ),
            SizedBox(
              width: resources.dimen.dp20,
            ),
            Expanded(
                child: DropDownWidget(
              list: StatusType.values,
              labelText: 'Ticket Status',
              hintText: "All",
              callback: (value) {},
            )),
          ],
        ),
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Row(
          children: [
            Expanded(
              child: DropDownWidget<String>(
                height: 32,
                list: categories,
                labelText: resources.string.department,
                selectedValue: null,
                iconSize: 20,
                fontStyle: context.textFontWeight400
                    .onFontSize(resources.fontSize.dp12),
                callback: (p0) {
                  //_selectedCategory = categories.indexOf(p0 ?? 'All');
                },
              ),
            ),
            SizedBox(
              width: resources.dimen.dp20,
            ),
            Expanded(
                child: DropDownWidget(
              list: const ["All", "Charged", "Not Charged"],
              labelText: 'Charges',
              hintText: "All",
              callback: (value) {},
            )),
          ],
        ),
        SizedBox(
          height: resources.dimen.dp30,
        ),
        InkWell(
          onTap: () {
            if (filteredDates.value.length == 2) {
              Navigator.of(context, rootNavigator: true)
                  .pop(filteredDates.value);
            }
          },
          child: ActionButtonWidget(
              text: resources.string.submit,
              radious: resources.dimen.dp15,
              textSize: resources.fontSize.dp10,
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp5,
                  horizontal: resources.dimen.dp15),
              color: resources.color.sideBarItemSelected),
        ),
      ],
    );
  }
}
