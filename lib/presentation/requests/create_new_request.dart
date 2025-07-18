// ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';
import 'package:ithelpdesk/domain/entities/user_entity.dart';
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

import '../../core/enum/enum.dart';
import '../../domain/entities/user_credentials_entity.dart';
import '../common_widgets/dropdown_search_widget.dart';

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
  final ValueNotifier<bool?> _onIssueTypeSelect = ValueNotifier(null);
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reqNoController = TextEditingController();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  // final TextEditingController _customerMobileNumberController =
  //     TextEditingController();
  final TextEditingController _tradeLicenseNameController =
      TextEditingController();
  final TextEditingController _tradeLicenseNumberController =
      TextEditingController();
  PriorityType? priority;
  final ValueNotifier<EserviceEntity?> _serviceID = ValueNotifier(null);
  final ValueNotifier<UserEntity?> _raisedBy = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final categories = UserCredentialsEntity.details().isoUser == true
        ? [
            resources.string.supportITRequest,
            resources.string.itISOCRS,
            resources.string.eservices,
            resources.string.application
          ]
        : [
            resources.string.supportITRequest,
            resources.string.eservices,
            resources.string.application
          ];
    final priorities = getPriorityTypes();
    var noOfCategoryRows = 1;
    var noOfCategoryRowItems = categories.length;
    if (categories.length == 4) {
      noOfCategoryRows = isDesktop(context) ? 1 : 2;
      noOfCategoryRowItems = isDesktop(context) ? 4 : 2;
    }
    final multiUploadAttachmentWidget = MultiUploadAttachmentWidget(
      hintText: resources.string.uploadFile,
      fillColor: resources.color.colorWhite,
      borderSide: BorderSide(
          color: context.resources.color.sideBarItemUnselected, width: 1),
      borderRadius: 0,
    );
    _contactNoController.text =
        UserCredentialsEntity.details().contactNumber ?? '';
    return SelectionArea(
      child: Scaffold(
          backgroundColor: resources.color.appScaffoldBg,
          body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => _masterDataBloc),
              BlocProvider(create: (context) => _servicesBloc)
            ],
            child: BlocListener<ServicesBloc, ServicesState>(
              listener: (context, state) {
                if (state is OnLoading) {
                  Dialogs.showInfoLoader(
                      context, resources.string.submittingRequest);
                } else if (state is OnCreateTicketSuccess) {
                  Dialogs.dismiss(context);
                  Dialogs.showInfoDialog(context, PopupType.success,
                          '${resources.string.successfullySubmitted}\n\n Ticket Id: ${state.createTicketResponse}')
                      .then((value) {
                    reloadPage();
                  });
                } else if (state is OnApiError) {
                  Dialogs.dismiss(context);
                  Dialogs.showInfoDialog(
                      context, PopupType.fail, state.message);
                }
              },
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
                              text: '${resources.string.step} 1',
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
                                if (categories.length == 3 && value > 0) {
                                  value = value - 1;
                                }
                                return Column(
                                  children: [
                                    for (int c = 0;
                                        c < noOfCategoryRows;
                                        c++) ...{
                                      Row(
                                        children: [
                                          for (int r = 0;
                                              r < noOfCategoryRowItems;
                                              r++) ...[
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  _ticketCategory.value = r +
                                                      (c *
                                                          noOfCategoryRowItems);
                                                  if (categories.length == 3 &&
                                                      _ticketCategory.value >
                                                          0) {
                                                    _ticketCategory.value =
                                                        _ticketCategory.value +
                                                            1;
                                                  }
                                                },
                                                child: ActionButtonWidget(
                                                  text: categories[r +
                                                      (c *
                                                          noOfCategoryRowItems)],
                                                  decoration: value !=
                                                          r +
                                                              (c *
                                                                  noOfCategoryRowItems)
                                                      ? BackgroundBoxDecoration(
                                                              boxColor: resources
                                                                  .color
                                                                  .colorWhite,
                                                              boarderColor:
                                                                  resources
                                                                      .color
                                                                      .textColorLight,
                                                              boarderWidth:
                                                                  resources
                                                                      .dimen
                                                                      .dp1,
                                                              radious: 0)
                                                          .roundedCornerBox
                                                      : null,
                                                  textColor: value !=
                                                          r +
                                                              (c *
                                                                  noOfCategoryRowItems)
                                                      ? resources
                                                          .color.textColor
                                                      : null,
                                                  textSize:
                                                      resources.dimen.dp12,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: context
                                                          .resources.dimen.dp10,
                                                      vertical: context
                                                          .resources.dimen.dp7),
                                                  radious: 0,
                                                ),
                                              ),
                                            ),
                                            if (r <
                                                noOfCategoryRowItems - 1) ...[
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
                              text: '${resources.string.step} 2',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: FutureBuilder(
                                                future: _masterDataBloc
                                                    .getSubCategories(
                                                        requestParams: {
                                                      'categoryID': value + 1
                                                    }),
                                                builder: (context, snapShot) {
                                                  final items =
                                                      snapShot.data?.items ??
                                                          [];
                                                  if (value + 1 == 2) {
                                                    items.removeWhere((item) =>
                                                        !(UserCredentialsEntity
                                                                        .details()
                                                                    .isoUserCategories ??
                                                                "")
                                                            .contains(
                                                                ((item as SubCategoryEntity)
                                                                            .id ??
                                                                        '')
                                                                    .toString()));
                                                  }
                                                  return DropDownWidget(
                                                    list:
                                                        snapShot.data?.items ??
                                                            [],
                                                    labelText: resources
                                                        .string.subCategory,
                                                    hintText: resources
                                                        .string.subCategory
                                                        .withPrefix(resources
                                                            .string
                                                            .pleaseSelect),
                                                    errorMessage: resources
                                                        .string.subCategory
                                                        .withPrefix(resources
                                                            .string
                                                            .pleaseSelect),
                                                    borderRadius: 0,
                                                    fillColor: resources
                                                        .color.colorWhite,
                                                    callback: (p0) {
                                                      _subCategoryValue.value =
                                                          (p0 as SubCategoryEntity)
                                                              .id;
                                                      _serviceID.value = null;
                                                      _reasonValue.value = null;
                                                      Future.delayed(
                                                          Duration.zero, () {
                                                        _formKey.currentState
                                                            ?.validate();
                                                      });
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
                                              .withPrefix(resources
                                                  .string.pleaseSelect),
                                          errorMessage: resources
                                              .string.priority
                                              .withPrefix(resources
                                                  .string.pleaseSelect),
                                          borderRadius: 0,
                                          fillColor: resources.color.colorWhite,
                                          callback: (value) {
                                            priority = value;
                                            _formKey.currentState?.validate();
                                          },
                                        )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: resources.dimen.dp10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: RightIconTextWidget(
                                            textInputType: TextInputType.number,
                                            labelText: resources
                                                .string.contactNoTelephoneExt,
                                            hintText: resources
                                                .string.contactNoTelephoneExt
                                                .withPrefix(resources
                                                    .string.pleaseEnter),
                                            errorMessage: resources
                                                .string.contactNoTelephoneExt
                                                .withPrefix(resources
                                                    .string.pleaseEnter),
                                            textController:
                                                _contactNoController,
                                            fillColor:
                                                resources.color.colorWhite,
                                            borderSide: BorderSide(
                                                color: context.resources.color
                                                    .sideBarItemUnselected,
                                                width: 1),
                                            borderRadius: 0,
                                            onChanged: (value) {
                                              _formKey.currentState?.validate();
                                            },
                                          ),
                                        ),
                                        if (value == 2) ...[
                                          ValueListenableBuilder(
                                              valueListenable:
                                                  _subCategoryValue,
                                              builder: (context, categoryValue,
                                                  child) {
                                                if (categoryValue != 2) {
                                                  return const SizedBox();
                                                }
                                                return SizedBox(
                                                  width: resources.dimen.dp40,
                                                );
                                              }),
                                          ValueListenableBuilder(
                                              valueListenable:
                                                  _subCategoryValue,
                                              builder: (context, categoryValue,
                                                  child) {
                                                if (categoryValue != 2) {
                                                  return const SizedBox();
                                                }
                                                int departmentID = 1;
                                                if (categoryValue == 1 ||
                                                    categoryValue == 3) {
                                                  departmentID = 5;
                                                } else if (categoryValue == 2) {
                                                  departmentID = 2;
                                                } else if (categoryValue == 4) {
                                                  departmentID = 1;
                                                } else if (categoryValue ==
                                                    25) {
                                                  departmentID = 18;
                                                }
                                                return FutureBuilder(
                                                    future: value == -1
                                                        ? Future.value(
                                                            ListEntity())
                                                        : _masterDataBloc
                                                            .getEmployees(
                                                                requestParams: {
                                                                'departmentID':
                                                                    departmentID,
                                                              }),
                                                    builder:
                                                        (context, snapShot) {
                                                      final items = snapShot
                                                              .data?.items ??
                                                          [];
                                                      items.sort((a, b) => a
                                                          .toString()
                                                          .toLowerCase()
                                                          .compareTo(b
                                                              .toString()
                                                              .toLowerCase()));
                                                      return Expanded(
                                                        child:
                                                            DropdownSearchWidget(
                                                          list: items,
                                                          labelText: resources
                                                              .string.raisedBy,
                                                          hintText: resources
                                                              .string.raisedBy
                                                              .withPrefix(resources
                                                                  .string
                                                                  .pleaseSelect),
                                                          errorMessage: value <
                                                                  3
                                                              ? resources.string
                                                                  .raisedBy
                                                                  .withPrefix(
                                                                      resources
                                                                          .string
                                                                          .pleaseSelect)
                                                              : '',
                                                          fillColor: resources
                                                              .color.colorWhite,
                                                          selectedValue:
                                                              _raisedBy.value,
                                                          callback: (value) {
                                                            _raisedBy.value =
                                                                (value
                                                                    as UserEntity);
                                                            _formKey
                                                                .currentState
                                                                ?.validate();
                                                          },
                                                        ),
                                                      );
                                                    });
                                              }),
                                        ]
                                      ],
                                    ),
                                    SizedBox(
                                      height: resources.dimen.dp10,
                                    ),
                                    if (value == 2) ...[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: DropDownWidget(
                                              list: [
                                                NameIDEntity(1, 'Internal',
                                                    nameAr: 'داخلي'),
                                                NameIDEntity(2, 'External',
                                                    nameAr: 'خارجي')
                                              ],
                                              textController:
                                                  TextEditingController(),
                                              labelText:
                                                  resources.string.issueType,
                                              hintText: resources
                                                  .string.issueType
                                                  .withPrefix(resources
                                                      .string.pleaseEnter),
                                              errorMessage: resources
                                                  .string.issueType
                                                  .withPrefix(resources
                                                      .string.pleaseSelect),
                                              fillColor:
                                                  resources.color.colorWhite,
                                              borderRadius: 0,
                                              callback: (value) {
                                                _onIssueTypeSelect.value =
                                                    (value?.id == 1);
                                                Future.delayed(Duration.zero,
                                                    () {
                                                  _formKey.currentState
                                                      ?.validate();
                                                });
                                              },
                                            ),
                                          ),
                                          ValueListenableBuilder(
                                              valueListenable:
                                                  _onIssueTypeSelect,
                                              builder: (context, value, child) {
                                                return SizedBox(
                                                  width: value ?? true
                                                      ? 0
                                                      : resources.dimen.dp40,
                                                );
                                              }),
                                          ValueListenableBuilder(
                                              valueListenable:
                                                  _onIssueTypeSelect,
                                              builder: (context, value, child) {
                                                return value ?? true
                                                    ? const SizedBox()
                                                    : Expanded(
                                                        child:
                                                            RightIconTextWidget(
                                                          textController:
                                                              _customerEmailController,
                                                          labelText: resources
                                                              .string
                                                              .customerEmail,
                                                          hintText: resources
                                                              .string
                                                              .customerEmail
                                                              .withPrefix(resources
                                                                  .string
                                                                  .pleaseEnter),
                                                          errorMessage: resources
                                                              .string
                                                              .customerEmail
                                                              .withPrefix(resources
                                                                  .string
                                                                  .pleaseEnter),
                                                          fillColor: resources
                                                              .color.colorWhite,
                                                          borderSide: BorderSide(
                                                              color: context
                                                                  .resources
                                                                  .color
                                                                  .sideBarItemUnselected,
                                                              width: 1),
                                                          borderRadius: 0,
                                                          onChanged: (value) {
                                                            _formKey
                                                                .currentState
                                                                ?.validate();
                                                          },
                                                          isValid: (p0) {
                                                            return p0.isEmpty
                                                                ? resources
                                                                    .string
                                                                    .customerEmail
                                                                    .withPrefix(
                                                                        resources
                                                                            .string
                                                                            .pleaseEnter)
                                                                : p0
                                                                        .isValidEmail()
                                                                    ? null
                                                                    : resources
                                                                        .string
                                                                        .customerEmail
                                                                        .withPrefix(resources
                                                                            .string
                                                                            .enterValid);
                                                          },
                                                        ),
                                                      );
                                              }),
                                        ],
                                      ),
                                      SizedBox(
                                        height: resources.dimen.dp10,
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: _subCategoryValue,
                                          builder: (context, value, child) {
                                            return FutureBuilder(
                                                future: value == -1
                                                    ? Future.value(ListEntity())
                                                    : _masterDataBloc
                                                        .getEservices(
                                                            requestParams: {
                                                            'departmentID':
                                                                value
                                                          }),
                                                builder: (context, snapShot) {
                                                  final items =
                                                      snapShot.data?.items ??
                                                          [];
                                                  items.sort((a, b) => a
                                                      .toString()
                                                      .toLowerCase()
                                                      .compareTo(b
                                                          .toString()
                                                          .toLowerCase()));
                                                  return DropdownSearchWidget(
                                                    list: items,
                                                    labelText: resources
                                                        .string.serviceName,
                                                    hintText: resources
                                                        .string.serviceName
                                                        .withPrefix(resources
                                                            .string
                                                            .pleaseSelect),
                                                    errorMessage: value < 3
                                                        ? resources
                                                            .string.serviceName
                                                            .withPrefix(resources
                                                                .string
                                                                .pleaseSelect)
                                                        : '',
                                                    fillColor: resources
                                                        .color.colorWhite,
                                                    selectedValue:
                                                        _serviceID.value,
                                                    callback: (value) {
                                                      _serviceID.value = (value
                                                          as EserviceEntity);
                                                      _formKey.currentState
                                                          ?.validate();
                                                    },
                                                  );
                                                });
                                          }),
                                      ValueListenableBuilder(
                                          valueListenable: _serviceID,
                                          builder: (context, value, child) {
                                            return value?.id == 0
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: resources
                                                            .dimen.dp10),
                                                    child: RightIconTextWidget(
                                                      hintText: resources
                                                          .string.serviceName
                                                          .withPrefix(resources
                                                              .string
                                                              .pleaseEnter),
                                                      errorMessage: resources
                                                          .string.serviceName
                                                          .withPrefix(resources
                                                              .string
                                                              .pleaseEnter),
                                                      textController:
                                                          _serviceNameController,
                                                      fillColor: resources
                                                          .color.colorWhite,
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
                                        textController: _reqNoController,
                                        textInputType: TextInputType.number,
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
                                        isValid: (p0) {
                                          if (value > 2) return null;
                                          return _subCategoryValue.value != 2
                                              ? null
                                              : p0.length < 4
                                                  ? resources.string.requestNo
                                                      .withPrefix(resources
                                                          .string.pleaseEnter)
                                                  : null;
                                        },
                                      ),
                                      SizedBox(
                                        height: resources.dimen.dp10,
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: _subCategoryValue,
                                          builder: (context, value, child) {
                                            return value == 2
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            RightIconTextWidget(
                                                          textController:
                                                              _tradeLicenseNameController,
                                                          labelText: resources
                                                              .string
                                                              .tradeLicenseName,
                                                          hintText: resources
                                                              .string
                                                              .tradeLicenseName
                                                              .withPrefix(resources
                                                                  .string
                                                                  .pleaseEnter),
                                                          errorMessage: resources
                                                              .string
                                                              .tradeLicenseName
                                                              .withPrefix(resources
                                                                  .string
                                                                  .pleaseEnter),
                                                          fillColor: resources
                                                              .color.colorWhite,
                                                          borderSide: BorderSide(
                                                              color: context
                                                                  .resources
                                                                  .color
                                                                  .sideBarItemUnselected,
                                                              width: 1),
                                                          borderRadius: 0,
                                                          onChanged: (value) {
                                                            _formKey
                                                                .currentState
                                                                ?.validate();
                                                          },
                                                          isValid: (p0) {
                                                            return p0.isEmpty
                                                                ? resources
                                                                    .string
                                                                    .tradeLicenseName
                                                                    .withPrefix(
                                                                        resources
                                                                            .string
                                                                            .pleaseEnter)
                                                                : null;
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: resources
                                                            .dimen.dp40,
                                                      ),
                                                      Expanded(
                                                        child:
                                                            RightIconTextWidget(
                                                          textController:
                                                              _tradeLicenseNumberController,
                                                          labelText: resources
                                                              .string
                                                              .tradeLicenseNumber,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          hintText: resources
                                                              .string
                                                              .tradeLicenseNumber
                                                              .withPrefix(resources
                                                                  .string
                                                                  .pleaseEnter),
                                                          errorMessage: resources
                                                              .string
                                                              .tradeLicenseNumber
                                                              .withPrefix(resources
                                                                  .string
                                                                  .pleaseEnter),
                                                          fillColor: resources
                                                              .color.colorWhite,
                                                          borderSide: BorderSide(
                                                              color: context
                                                                  .resources
                                                                  .color
                                                                  .sideBarItemUnselected,
                                                              width: 1),
                                                          borderRadius: 0,
                                                          onChanged: (value) {
                                                            _formKey
                                                                .currentState
                                                                ?.validate();
                                                          },
                                                          isValid: (p0) {
                                                            return p0.isEmpty
                                                                ? resources
                                                                    .string
                                                                    .tradeLicenseNumber
                                                                    .withPrefix(
                                                                        resources
                                                                            .string
                                                                            .pleaseEnter)
                                                                : null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox();
                                          }),
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
                                                  : _masterDataBloc.getReasons(
                                                      requestParams: {
                                                          'categoryID':
                                                              _ticketCategory
                                                                      .value +
                                                                  1,
                                                          'subCategoryID': value
                                                        }),
                                              builder: (context, snapShot) {
                                                return DropdownSearchWidget<
                                                    BaseEntity>(
                                                  list: snapShot.data?.items ??
                                                      [],
                                                  labelText:
                                                      resources.string.reason,
                                                  hintText: resources
                                                      .string.reason
                                                      .withPrefix(resources
                                                          .string.pleaseSelect),
                                                  errorMessage: resources
                                                      .string.reason
                                                      .withPrefix(resources
                                                          .string.pleaseSelect),
                                                  fillColor: resources
                                                      .color.colorWhite,
                                                  selectedValue:
                                                      _reasonValue.value,
                                                  callback: (value) {
                                                    _reasonValue.value =
                                                        value as ReasonsEntity;
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
                                                      top:
                                                          resources.dimen.dp10),
                                                  child: RightIconTextWidget(
                                                    hintText: resources
                                                        .string.reason
                                                        .withPrefix(resources
                                                            .string
                                                            .pleaseEnter),
                                                    errorMessage: resources
                                                        .string.reason
                                                        .withPrefix(resources
                                                            .string
                                                            .pleaseEnter),
                                                    textController:
                                                        _reasonController,
                                                    fillColor: resources
                                                        .color.colorWhite,
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
                                          .withPrefix(
                                              resources.string.pleaseEnter),
                                      errorMessage: resources.string.description
                                          .withPrefix(
                                              resources.string.pleaseEnter),
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
                              text: '${resources.string.step} 3',
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
                            child: multiUploadAttachmentWidget),
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
                                text: resources.string.cancel,
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
                                  ticket.userID =
                                      UserCredentialsEntity.details().id;
                                  ticket.departmentID =
                                      UserCredentialsEntity.details()
                                          .departmentID;
                                  var ticketCategoryValue =
                                      _ticketCategory.value + 1;
                                  ticket.categoryID = ticketCategoryValue;
                                  ticket.subCategoryID =
                                      _subCategoryValue.value;
                                  ticket.subjectID = _reasonValue.value?.id;
                                  ticket.subject = _reasonController.text;
                                  ticket.mobileNumber =
                                      _contactNoController.text;
                                  ticket.description =
                                      _descriptionController.text;
                                  ticket.priority = priority;
                                  ticket.serviceId = _serviceID.value?.id;
                                  ticket.serviceReqNo = _reqNoController.text;
                                  ticket.serviceName =
                                      _serviceNameController.text;
                                  ticket.raisedBy = _raisedBy.value?.id;
                                  ticket.tradeLicenseName =
                                      _tradeLicenseNameController.text;
                                  ticket.tradeLicenseNumber = int.tryParse(
                                      _tradeLicenseNumberController.text);
                                  ticket.email = _customerEmailController.text;
                                  final data = ticket.toCreateJson();
                                  data['files'] = multiUploadAttachmentWidget
                                      .getSelectedFilesData()
                                      .map((file) {
                                    return MultipartFile.fromBytes(
                                        file['fileBytes'],
                                        filename: file['fileName']);
                                  }).toList();
                                  _servicesBloc.createRequest(
                                      requestParams: data);
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
            ),
          )),
    );
  }
}
