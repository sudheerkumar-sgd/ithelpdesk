import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class DateRangeFilterWidget extends StatelessWidget {
  final ValueNotifier<List<String>> filteredDates;
  final VoidCallback? onChanged;
  final bool showLabel;
  final String dateFormat;
  final Duration endDateOffset;

  const DateRangeFilterWidget({
    required this.filteredDates,
    this.onChanged,
    this.showLabel = true,
    this.dateFormat = 'yyyy/MM/dd',
    this.endDateOffset = const Duration(hours: 24),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    final dateFilter = ValueListenableBuilder<List<String>>(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: resources.dimen.dp10,
              ),
              InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now().add(const Duration(days: -365)),
                    lastDate: DateTime.now(),
                  ).then((dateTime) {
                    if (dateTime != null) {
                      filteredDates.value = List<String>.empty(growable: true)
                        ..add(getDateByformat(dateFormat, dateTime));
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
                    ],
                  ),
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
                      initialDate:
                          getDateTimeByString(dateFormat, value[0]),
                      firstDate: getDateTimeByString(dateFormat, value[0]),
                      lastDate: DateTime.now(),
                    ).then((dateTime) {
                      if (dateTime != null) {
                        filteredDates.value =
                            List<String>.empty(growable: true)
                              ..add(value[0])
                              ..add(getDateByformat(
                                  dateFormat, dateTime.add(endDateOffset)));
                        onChanged?.call();
                      }
                    });
                  } else {
                    Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      resources.string.pleaseSelect +
                          resources.string.startDate,
                    );
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
                    ],
                  ),
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
                    onChanged?.call();
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
      },
    );

    if (!showLabel) {
      return dateFilter;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${resources.string.filterByDate}: ',
          style:
              context.textFontWeight600.onFontSize(resources.fontSize.dp10),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        dateFilter,
      ],
    );
  }
}
