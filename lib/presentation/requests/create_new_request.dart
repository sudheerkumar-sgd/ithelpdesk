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
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/multi_upload_attachment_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:page_transition/page_transition.dart';

class CreateNewRequest extends BaseScreenWidget {
  static start(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft, child: CreateNewRequest()),
    );
  }

  CreateNewRequest({super.key});
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  final MasterDataBloc _masterDataBloc = sl<MasterDataBloc>();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier _ticketCategory = ValueNotifier(-1);
  final ValueNotifier _subCategoryValue = ValueNotifier(-1);
  final ValueNotifier<ReasonsEntity?> _reasonValue = ValueNotifier(null);
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int priority = -1;

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final categories = [
      resources.string.supportITRequest,
      resources.string.itISOCRS,
      resources.string.eservices,
      resources.string.application
    ];
    final priorities = ['Low', 'Medium', 'High'];
    final noOfCategoryRows = isDesktop(context) ? 1 : 2;
    final noOfCategoryRowItems = isDesktop(context) ? 4 : 2;
    return Scaffold(
        backgroundColor: resources.color.appScaffoldBg,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => _masterDataBloc),
            BlocProvider(create: (context) => _servicesBloc)
          ],
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: resources.dimen.dp15,
                vertical: resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: '${resources.string.createNewRequest}\n',
                          style: context.textFontWeight600,
                          children: [
                            TextSpan(
                                text:
                                    '${resources.string.createNewRequestDes}\n',
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp10)
                                    .onColor(resources.color.textColorLight)
                                    .onHeight(1))
                          ]),
                    ),
                    SizedBox(
                      height: resources.dimen.dp20,
                    ),
                    Text.rich(
                      TextSpan(
                          text: '${resources.string.step}1',
                          style: context.textFontWeight600,
                          children: [
                            WidgetSpan(
                                child: SizedBox(
                              width: resources.dimen.dp10,
                            )),
                            TextSpan(
                                text: resources.string.step1Des,
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp10)
                                    .onColor(resources.color.textColorLight)
                                    .onHeight(1))
                          ]),
                    ),
                    SizedBox(
                      height: resources.dimen.dp10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: resources.dimen.dp15,
                          horizontal: resources.dimen.dp20),
                      color: resources.color.colorWhite,
                      child: ValueListenableBuilder(
                          valueListenable: _ticketCategory,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                for (int c = 0; c < noOfCategoryRows; c++) ...{
                                  Row(
                                    children: [
                                      for (int r = 0;
                                          r < noOfCategoryRowItems;
                                          r++) ...[
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _ticketCategory.value = r +
                                                  (c * noOfCategoryRowItems);
                                            },
                                            child: ActionButtonWidget(
                                              text: categories[r +
                                                  (c * noOfCategoryRowItems)],
                                              decoration: value !=
                                                      r +
                                                          (c *
                                                              noOfCategoryRowItems)
                                                  ? BackgroundBoxDecoration(
                                                          boxColor: resources
                                                              .color.colorWhite,
                                                          boarderColor: resources
                                                              .color
                                                              .textColorLight,
                                                          boarderWidth:
                                                              resources
                                                                  .dimen.dp1,
                                                          radious: 0)
                                                      .roundedCornerBox
                                                  : null,
                                              textColor: value !=
                                                      r +
                                                          (c *
                                                              noOfCategoryRowItems)
                                                  ? resources.color.textColor
                                                  : null,
                                              textSize: resources.dimen.dp12,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: context
                                                      .resources.dimen.dp10,
                                                  vertical: context
                                                      .resources.dimen.dp7),
                                              radious: 0,
                                            ),
                                          ),
                                        ),
                                        if (r < noOfCategoryRowItems - 1) ...[
                                          SizedBox(
                                            width: resources.dimen.dp20,
                                          )
                                        ]
                                      ]
                                    ],
                                  ),
                                  if (c < noOfCategoryRows - 1) ...[
                                    SizedBox(
                                      height: resources.dimen.dp20,
                                    )
                                  ]
                                },
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                      height: resources.dimen.dp20,
                    ),
                    Text.rich(
                      TextSpan(
                          text: '${resources.string.step}2',
                          style: context.textFontWeight600,
                          children: [
                            WidgetSpan(
                                child: SizedBox(
                              width: resources.dimen.dp10,
                            )),
                            TextSpan(
                                text: resources.string.step2Des,
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp10)
                                    .onColor(resources.color.textColorLight)
                                    .onHeight(1))
                          ]),
                    ),
                    SizedBox(
                      height: resources.dimen.dp10,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _ticketCategory,
                        builder: (context, value, child) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: resources.dimen.dp15,
                                horizontal: resources.dimen.dp20),
                            color: resources.color.colorWhite,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: FutureBuilder(
                                            future: _masterDataBloc
                                                .getSubCategories(
                                                    requestParams: {
                                                  'categoryID': value + 1
                                                }),
                                            builder: (context, snapShot) {
                                              return DropDownWidget(
                                                list:
                                                    snapShot.data?.items ?? [],
                                                labelText: resources
                                                    .string.subCategory,
                                                hintText: resources
                                                    .string.subCategory
                                                    .withPrefix(resources
                                                        .string.pleaseSelect),
                                                errorMessage: resources
                                                    .string.subCategory
                                                    .withPrefix(resources
                                                        .string.pleaseSelect),
                                                borderRadius: 0,
                                                fillColor:
                                                    resources.color.colorWhite,
                                                callback: (p0) {
                                                  _subCategoryValue.value =
                                                      (p0 as SubCategoryEntity)
                                                          .id;
                                                  _formKey.currentState
                                                      ?.validate();
                                                },
                                              );
                                            })),
                                    SizedBox(
                                      width: resources.dimen.dp40,
                                    ),
                                    // if (value == 2) ...[
                                    //   Expanded(
                                    //       child: FutureBuilder(
                                    //           future: _masterDataBloc
                                    //               .getEservices(requestParams: {
                                    //             'departmentID': 1
                                    //           }),
                                    //           builder: (context, snapShot) {
                                    //             return DropDownWidget(
                                    //               list:
                                    //                   snapShot.data?.items ?? [],
                                    //               labelText:
                                    //                   resources.string.issueType,
                                    //               borderRadius: 0,
                                    //               fillColor:
                                    //                   resources.color.colorWhite,
                                    //             );
                                    //           })),
                                    //   SizedBox(width: resources.dimen.dp20),
                                    // ],
                                    Expanded(
                                        child: DropDownWidget(
                                      list: priorities,
                                      labelText: resources.string.priority,
                                      hintText: resources.string.priority
                                          .withPrefix(
                                              resources.string.pleaseSelect),
                                      errorMessage: resources.string.priority
                                          .withPrefix(
                                              resources.string.pleaseSelect),
                                      borderRadius: 0,
                                      fillColor: resources.color.colorWhite,
                                      callback: (value) {
                                        priority =
                                            priorities.indexOf(value ?? '');
                                        _formKey.currentState?.validate();
                                      },
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: resources.dimen.dp10,
                                ),
                                RightIconTextWidget(
                                  labelText:
                                      resources.string.contactNoTelephoneExt,
                                  hintText: resources
                                      .string.contactNoTelephoneExt
                                      .withPrefix(resources.string.pleaseEnter),
                                  errorMessage: resources
                                      .string.contactNoTelephoneExt
                                      .withPrefix(resources.string.pleaseEnter),
                                  textController: _contactNoController,
                                  fillColor: resources.color.colorWhite,
                                  borderSide: BorderSide(
                                      color: context.resources.color
                                          .sideBarItemUnselected,
                                      width: 1),
                                  borderRadius: 0,
                                  onChanged: (value) {
                                    _formKey.currentState?.validate();
                                  },
                                ),
                                SizedBox(
                                  height: resources.dimen.dp10,
                                ),
                                if (value == 2) ...[
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
                                                list:
                                                    snapShot.data?.items ?? [],
                                                labelText: resources
                                                    .string.serviceName,
                                                hintText: resources
                                                    .string.serviceName
                                                    .withPrefix(resources
                                                        .string.pleaseSelect),
                                                errorMessage: resources
                                                    .string.serviceName
                                                    .withPrefix(resources
                                                        .string.pleaseSelect),
                                                borderRadius: 0,
                                                fillColor:
                                                    resources.color.colorWhite,
                                                callback: (value) {
                                                  _formKey.currentState
                                                      ?.validate();
                                                },
                                              );
                                            });
                                      }),
                                  SizedBox(
                                    height: resources.dimen.dp10,
                                  ),
                                  RightIconTextWidget(
                                    labelText: resources.string.requestNo,
                                    hintText: resources.string.requestNo
                                        .withPrefix(
                                            resources.string.pleaseEnter),
                                    errorMessage: resources.string.requestNo
                                        .withPrefix(
                                            resources.string.pleaseEnter),
                                    fillColor: resources.color.colorWhite,
                                    borderSide: BorderSide(
                                        color: context.resources.color
                                            .sideBarItemUnselected,
                                        width: 1),
                                    borderRadius: 0,
                                    onChanged: (value) {
                                      _formKey.currentState?.validate();
                                    },
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp10,
                                  ),
                                ],
                                ValueListenableBuilder(
                                    valueListenable: _subCategoryValue,
                                    builder: (context, value, child) {
                                      return FutureBuilder(
                                          future: value == -1
                                              ? Future.value(ListEntity())
                                              : _masterDataBloc
                                                  .getReasons(requestParams: {
                                                  'categoryID':
                                                      _ticketCategory.value + 1,
                                                  'subCategoryID': value
                                                }),
                                          builder: (context, snapShot) {
                                            return DropDownWidget(
                                              list: snapShot.data?.items ?? [],
                                              labelText:
                                                  resources.string.reason,
                                              hintText: resources.string.reason
                                                  .withPrefix(resources
                                                      .string.pleaseSelect),
                                              errorMessage: resources
                                                  .string.reason
                                                  .withPrefix(resources
                                                      .string.pleaseSelect),
                                              borderRadius: 0,
                                              fillColor:
                                                  resources.color.colorWhite,
                                              callback: (value) {
                                                _reasonValue.value = value;
                                                _formKey.currentState
                                                    ?.validate();
                                              },
                                            );
                                          });
                                    }),
                                ValueListenableBuilder(
                                    valueListenable: _reasonValue,
                                    builder: (context, value, child) {
                                      return value?.id == 999
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  top: resources.dimen.dp10),
                                              child: RightIconTextWidget(
                                                hintText: resources
                                                    .string.reason
                                                    .withPrefix(resources
                                                        .string.pleaseEnter),
                                                errorMessage: resources
                                                    .string.reason
                                                    .withPrefix(resources
                                                        .string.pleaseEnter),
                                                textController:
                                                    _reasonController,
                                                fillColor:
                                                    resources.color.colorWhite,
                                                borderSide: BorderSide(
                                                    color: context
                                                        .resources
                                                        .color
                                                        .sideBarItemUnselected,
                                                    width: 1),
                                                borderRadius: 0,
                                                onChanged: (value) {
                                                  _formKey.currentState
                                                      ?.validate();
                                                },
                                              ),
                                            )
                                          : const SizedBox();
                                    }),
                                SizedBox(
                                  height: resources.dimen.dp10,
                                ),
                                RightIconTextWidget(
                                  labelText: resources.string.description,
                                  hintText: resources.string.description
                                      .withPrefix(resources.string.pleaseEnter),
                                  errorMessage: resources.string.description
                                      .withPrefix(resources.string.pleaseEnter),
                                  textController: _descriptionController,
                                  fillColor: resources.color.colorWhite,
                                  maxLines: 8,
                                  borderSide: BorderSide(
                                      color: context.resources.color
                                          .sideBarItemUnselected,
                                      width: 1),
                                  borderRadius: 0,
                                  onChanged: (value) {
                                    _formKey.currentState?.validate();
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                    SizedBox(
                      height: resources.dimen.dp20,
                    ),
                    Text.rich(
                      TextSpan(
                          text: '${resources.string.step}3',
                          style: context.textFontWeight600,
                          children: [
                            WidgetSpan(
                                child: SizedBox(
                              width: resources.dimen.dp10,
                            )),
                            TextSpan(
                                text: resources.string.step3Des,
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp10)
                                    .onColor(resources.color.textColorLight)
                                    .onHeight(1))
                          ]),
                    ),
                    SizedBox(
                      height: resources.dimen.dp10,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: resources.dimen.dp15,
                            horizontal: resources.dimen.dp20),
                        color: resources.color.colorWhite,
                        child: MultiUploadAttachmentWidget(
                          hintText: resources.string.uploadFile,
                          fillColor: resources.color.colorWhite,
                          borderSide: BorderSide(
                              color:
                                  context.resources.color.sideBarItemUnselected,
                              width: 1),
                          borderRadius: 0,
                        )),
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
                            color: resources.color.colorWhite,
                            textColor: resources.color.textColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp40,
                                vertical: context.resources.dimen.dp7),
                          ),
                        ),
                        SizedBox(
                          width: resources.dimen.dp20,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState?.validate() == true) {
                              final ticket = TicketEntity();
                              ticket.userID = 317;
                              ticket.departmentID = 1;
                              ticket.categoryID = _ticketCategory.value + 1;
                              ticket.subCategoryID = _subCategoryValue.value;
                              ticket.subjectID = _reasonValue.value?.id;
                              ticket.subject = _reasonController.text;
                              ticket.mobileNumber = _contactNoController.text;
                              ticket.description = _descriptionController.text;
                              ticket.priority = priority + 1;
                              Dialogs.showInfoLoader(
                                  context, 'Submitting Request');
                              await _servicesBloc.createRequest(
                                  requestParams: ticket.toCreateJson());
                              Dialogs.dismiss(context);
                              Dialogs.showInfoDialog(context, PopupType.success,
                                      'Successfully Submitted')
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: ActionButtonWidget(
                            text: resources.string.submit,
                            padding: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp40,
                                vertical: context.resources.dimen.dp7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
