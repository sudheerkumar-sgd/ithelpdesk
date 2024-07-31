// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_service_steps.dart';
import 'package:ithelpdesk/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:ithelpdesk/presentation/requests/widgets/ticket_transfer_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:page_transition/page_transition.dart';

class ViewRequest extends BaseScreenWidget {
  static start(BuildContext context, TicketEntity ticket) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: ViewRequest(
            ticket: ticket,
          )),
    );
  }

  final TicketEntity ticket;
  ViewRequest({required this.ticket, super.key});
  final ValueNotifier _isChargeable = ValueNotifier(false);
  final ValueNotifier _ticketCategory = ValueNotifier(-1);
  final ValueNotifier<SubCategoryEntity?> _subCategoryValue =
      ValueNotifier(null);
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  final MasterDataBloc _masterDataBloc = sl<MasterDataBloc>();
  final ValueNotifier<ReasonsEntity?> _reasonValue = ValueNotifier(null);
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int priority = -1;

  Widget _getDataForm(BuildContext context, int ticketType) {
    final resources = context.resources;
    final priorities = isSelectedLocalEn
        ? ['Critical', 'High', 'Medium', 'Low']
        : ['حرج', 'عالي', 'متوسط', 'منخفض'];
    _contactNoController.text = ticket.mobileNumber ?? '';
    _reasonController.text = ticket.subject ?? '';
    _descriptionController.text = ticket.description ?? '';
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp15, horizontal: resources.dimen.dp20),
      color: resources.color.colorWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
              valueListenable: _ticketCategory,
              builder: (context, value, child) {
                return Container(
                  color: resources.color.colorWhite,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: FutureBuilder(
                                  future: _masterDataBloc.getSubCategories(
                                      requestParams: {
                                        'categoryID': ticket.categoryID
                                      }),
                                  builder: (context, snapShot) {
                                    _subCategoryValue.value ??= (snapShot
                                                .data?.items ??
                                            List<SubCategoryEntity>.empty())
                                        .where((subCategory) =>
                                            (subCategory as SubCategoryEntity)
                                                .id ==
                                            ticket.subCategoryID)
                                        .firstOrNull;
                                    return DropDownWidget(
                                      list: snapShot.data?.items ?? [],
                                      labelText: resources.string.subCategory,
                                      isEnabled: false,
                                      hintText: resources.string.subCategory
                                          .withPrefix(
                                              resources.string.pleaseSelect),
                                      errorMessage: resources.string.subCategory
                                          .withPrefix(
                                              resources.string.pleaseSelect),
                                      borderRadius: 0,
                                      fillColor: resources.color.colorWhite,
                                      selectedValue: _subCategoryValue.value,
                                      callback: (p0) {
                                        _subCategoryValue.value =
                                            (p0 as SubCategoryEntity);
                                      },
                                    );
                                  })),
                          SizedBox(
                            width: resources.dimen.dp40,
                          ),
                          Expanded(
                              child: DropDownWidget(
                            list: priorities,
                            isEnabled: false,
                            labelText: resources.string.priority,
                            hintText: resources.string.priority
                                .withPrefix(resources.string.pleaseSelect),
                            errorMessage: resources.string.priority
                                .withPrefix(resources.string.pleaseSelect),
                            borderRadius: 0,
                            fillColor: resources.color.colorWhite,
                            selectedValue: priorities[ticket.priority ?? 0],
                            callback: (value) {
                              priority = priorities.indexOf(value ?? '');
                            },
                          )),
                        ],
                      ),
                      SizedBox(
                        height: resources.dimen.dp10,
                      ),
                      RightIconTextWidget(
                        isEnabled: false,
                        labelText: resources.string.contactNoTelephoneExt,
                        hintText: resources.string.contactNoTelephoneExt
                            .withPrefix(resources.string.pleaseEnter),
                        errorMessage: resources.string.contactNoTelephoneExt
                            .withPrefix(resources.string.pleaseEnter),
                        textController: _contactNoController,
                        fillColor: resources.color.colorWhite,
                        borderSide: BorderSide(
                            color:
                                context.resources.color.sideBarItemUnselected,
                            width: 1),
                        borderRadius: 0,
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: resources.dimen.dp10,
                      ),
                      if (ticket.categoryID == 3) ...[
                        ValueListenableBuilder(
                            valueListenable: _subCategoryValue,
                            builder: (context, value, child) {
                              return FutureBuilder(
                                  future: value == -1
                                      ? Future.value(ListEntity())
                                      : _masterDataBloc.getEservices(
                                          requestParams: {
                                              'departmentID': value
                                            }),
                                  builder: (context, snapShot) {
                                    return DropDownWidget(
                                      list: snapShot.data?.items ?? [],
                                      labelText: resources.string.serviceName,
                                      hintText: resources.string.serviceName
                                          .withPrefix(
                                              resources.string.pleaseSelect),
                                      errorMessage: resources.string.serviceName
                                          .withPrefix(
                                              resources.string.pleaseSelect),
                                      borderRadius: 0,
                                      fillColor: resources.color.colorWhite,
                                      callback: (value) {},
                                    );
                                  });
                            }),
                        SizedBox(
                          height: resources.dimen.dp10,
                        ),
                        RightIconTextWidget(
                          isEnabled: false,
                          labelText: resources.string.requestNo,
                          hintText: resources.string.requestNo
                              .withPrefix(resources.string.pleaseEnter),
                          errorMessage: resources.string.requestNo
                              .withPrefix(resources.string.pleaseEnter),
                          fillColor: resources.color.colorWhite,
                          borderSide: BorderSide(
                              color:
                                  context.resources.color.sideBarItemUnselected,
                              width: 1),
                          borderRadius: 0,
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: resources.dimen.dp10,
                        ),
                      ],
                      FutureBuilder(
                          future: _masterDataBloc.getReasons(requestParams: {
                            'categoryID': ticket.categoryID,
                            'subCategoryID': ticket.subCategoryID
                          }),
                          builder: (context, snapShot) {
                            final selectedReason = (snapShot.data?.items ?? [])
                                .where((reason) =>
                                    (reason as ReasonsEntity).id ==
                                    ticket.subjectID)
                                .firstOrNull;
                            return DropDownWidget(
                              isEnabled: false,
                              list: snapShot.data?.items ?? [],
                              labelText: resources.string.reason,
                              hintText: resources.string.reason
                                  .withPrefix(resources.string.pleaseSelect),
                              errorMessage: resources.string.reason
                                  .withPrefix(resources.string.pleaseSelect),
                              borderRadius: 0,
                              selectedValue: selectedReason,
                              fillColor: resources.color.colorWhite,
                              callback: (value) {
                                _reasonValue.value = value;
                              },
                            );
                          }),
                      if (ticket.subjectID == 999) ...[
                        Padding(
                          padding: EdgeInsets.only(top: resources.dimen.dp10),
                          child: RightIconTextWidget(
                            isEnabled: false,
                            hintText: resources.string.reason
                                .withPrefix(resources.string.pleaseEnter),
                            errorMessage: resources.string.reason
                                .withPrefix(resources.string.pleaseEnter),
                            textController: _reasonController,
                            fillColor: resources.color.colorWhite,
                            borderSide: BorderSide(
                                color: context
                                    .resources.color.sideBarItemUnselected,
                                width: 1),
                            borderRadius: 0,
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                      SizedBox(
                        height: resources.dimen.dp10,
                      ),
                      RightIconTextWidget(
                        isEnabled: false,
                        labelText: resources.string.description,
                        hintText: resources.string.description
                            .withPrefix(resources.string.pleaseEnter),
                        errorMessage: resources.string.description
                            .withPrefix(resources.string.pleaseEnter),
                        textController: _descriptionController,
                        fillColor: resources.color.colorWhite,
                        maxLines: 8,
                        borderSide: BorderSide(
                            color:
                                context.resources.color.sideBarItemUnselected,
                            width: 1),
                        borderRadius: 0,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                );
              }),
          SizedBox(
            height: resources.dimen.dp20,
          ),
        ],
      ),
    );
  }

  Widget _getStatusWidget(
      BuildContext context, List<Map<String, String>> steps) {
    final resources = context.resources;
    return Container(
      color: resources.color.colorWhite,
      padding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp15, horizontal: resources.dimen.dp20),
      margin:
          EdgeInsets.only(left: isDesktop(context) ? resources.dimen.dp20 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resources.string.latestUpdate,
            style: context.textFontWeight600,
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          for (int i = 0; i < steps.length; i++) ...[
            ItemServiceSteps(
              stepColor: i < steps.length - 1
                  ? resources.color.colorGreen26B757
                  : resources.color.pending,
              stepText: steps[i]['name'] ?? '',
              stepSubText: '${steps[i]['title']}\n23 March 2024, 11:00 AM',
              isLastStep: i == steps.length - 1,
            )
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    const ticketType = 2;
    final steps = [
      {
        'name': 'Sudheer Kumar Akula',
        'title': 'service created',
        'date': '23 March 2024, 11:00 AM'
      },
      {
        'name': 'Mohammed Kamran',
        'title': 'Assigned manually ',
        'date': '23 March 2024, 11:00 AM'
      },
      {
        'name': 'Noushad',
        'title': 'Forwarded to SGD Eservice',
        'date': '23 March 2024, 11:00 AM'
      },
      {
        'name': 'Mooza Binyeem',
        'title': 'Changed Sub Category to Eservice',
        'date': '23 March 2024, 11:00 AM'
      },
    ];
    final actionButtons = [
      {
        'name': resources.string.returnText,
        'color': resources.color.colorWhite,
      },
      {
        'name': resources.string.transfer,
        'color': resources.color.pending,
      },
      {
        'name': resources.string.close,
        'color': resources.color.colorGreen26B757,
      },
      {
        'name': resources.string.hold,
        'color': resources.color.viewBgColor,
      },
      {
        'name': resources.string.reject,
        'color': resources.color.rejected,
      },
      {
        'name': '',
        'color': resources.color.colorWhite,
      },
    ];
    final actionButtonRows = isDesktop(context) ? 1 : 2;
    final actionButtonColumns = isDesktop(context) ? 5 : 3;

    return Scaffold(
        backgroundColor: resources.color.appScaffoldBg,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => _servicesBloc),
            BlocProvider(create: (context) => _masterDataBloc),
          ],
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: resources.dimen.dp15,
                vertical: resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text.rich(
                          TextSpan(
                              text:
                                  '${ticket.subject} - UAQGOV-ITHD- ${ticket.id}\n',
                              style: context.textFontWeight600,
                              children: [
                                TextSpan(
                                    text:
                                        'Created by Mooza BinYeem on 27-Mar-2024 at 11:13 AM',
                                    style: context.textFontWeight400
                                        .onFontSize(resources.fontSize.dp10)
                                        .onColor(resources.color.textColorLight)
                                        .onHeight(1)
                                        .onFontFamily(fontFamily: fontFamilyEN))
                              ]),
                        ),
                      ),
                      Expanded(
                        flex: isDesktop(context) ? 1 : 0,
                        child: Padding(
                          padding: EdgeInsets.only(left: resources.dimen.dp20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'status:',
                                style: context.textFontWeight600,
                              ),
                              SizedBox(
                                width: resources.dimen.dp5,
                              ),
                              Text(
                                ticket.status ?? '',
                                style: context.textFontWeight700
                                    .onColor(resources.color.pending),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: resources.dimen.dp10,
                  ),
                  IntrinsicHeight(
                    child: isDesktop(context)
                        ? Row(
                            children: [
                              Expanded(
                                child: _getDataForm(context, ticketType),
                              ),
                              SizedBox(
                                width: 280,
                                child: FutureBuilder(
                                    future: _servicesBloc.getTicketHistory(
                                        requestParams: {"ticketID": ticket.id}),
                                    builder: (context, snapShot) {
                                      return _getStatusWidget(context, steps);
                                    }),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              _getStatusWidget(context, steps),
                              SizedBox(
                                height: resources.dimen.dp20,
                              ),
                              _getDataForm(context, ticketType),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: resources.dimen.dp15,
                        horizontal: resources.dimen.dp20),
                    color: resources.color.colorWhite,
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: _isChargeable,
                            builder: (context, value, child) {
                              return CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    '${resources.string.chargeable}(50 AED)',
                                    style: context.textFontWeight400
                                        .onColor(resources.color.viewBgColor),
                                  ),
                                  side: BorderSide(
                                    color: resources.color.viewBgColor,
                                    width: 1.5,
                                  ),
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: value,
                                  onChanged: (isChecked) {
                                    _isChargeable.value = isChecked;
                                  });
                            }),
                        SizedBox(
                          height: resources.dimen.dp10,
                        ),
                        RightIconTextWidget(
                          labelText: resources.string.comments,
                          fillColor: resources.color.colorWhite,
                          maxLines: 4,
                          borderSide: BorderSide(
                              color:
                                  context.resources.color.sideBarItemUnselected,
                              width: 1),
                          borderRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  Column(
                    children: [
                      for (int c = 0; c < actionButtonRows; c++) ...[
                        Row(
                          children: [
                            for (int r = 0; r < actionButtonColumns; r++) ...[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Dialogs.showDialogWithClose(
                                        context, TicketTransferWidget(),
                                        maxWidth: 350);
                                  },
                                  child: ActionButtonWidget(
                                    text: (actionButtons[r +
                                                    (c * actionButtonColumns)]
                                                ['name'] ??
                                            '')
                                        .toString(),
                                    color: actionButtons[
                                            r + (c * actionButtonColumns)]
                                        ['color'] as Color,
                                    radious: 0,
                                    textColor: r == 0
                                        ? resources.color.textColor
                                        : null,
                                    textSize: resources.fontSize.dp12,
                                    padding: EdgeInsets.symmetric(
                                        vertical: resources.dimen.dp7,
                                        horizontal: resources.dimen.dp10),
                                  ),
                                ),
                              ),
                              if (r < actionButtonColumns - 1) ...[
                                SizedBox(
                                  width: resources.dimen.dp10,
                                ),
                              ]
                            ]
                          ],
                        ),
                        if (c < actionButtonRows - 1) ...[
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                        ]
                      ]
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
