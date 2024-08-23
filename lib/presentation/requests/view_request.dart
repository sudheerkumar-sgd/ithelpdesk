// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_menu_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_service_steps.dart';
import 'package:ithelpdesk/presentation/common_widgets/right_icon_text_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/ticket_action_widget.dart';
import 'package:ithelpdesk/presentation/requests/widgets/ticket_transfer_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';
import 'package:page_transition/page_transition.dart';

import '../../domain/entities/user_credentials_entity.dart';
import '../common_widgets/alert_dialog_widget.dart';
import '../common_widgets/attachment_preview_widget.dart';
import 'widgets/ticket_return_widget.dart';

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
  final ValueNotifier<SubCategoryEntity?> _subCategoryValue =
      ValueNotifier(null);
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  final MasterDataBloc _masterDataBloc = sl<MasterDataBloc>();
  final ValueNotifier<ReasonsEntity?> _reasonValue = ValueNotifier(null);
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int priority = -1;
  final ValueNotifier<bool> _isExanded = ValueNotifier(false);

  Widget _getChargeWidget(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isChargeable,
        builder: (context, value, child) {
          return CheckboxListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                '${context.resources.string.chargeable}(50 AED)',
                style: context.textFontWeight400
                    .onColor(context.resources.color.viewBgColor),
              ),
              side: BorderSide(
                color: context.resources.color.viewBgColor,
                width: 1.5,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              controlAffinity: ListTileControlAffinity.leading,
              value: value,
              onChanged: (isChecked) {
                _isChargeable.value = isChecked;
              });
        });
  }

  Widget _getComments(BuildContext context) {
    return FutureBuilder(
        future: _servicesBloc
            .getTicketComments(requestParams: {'ticketID': ticket.id}),
        builder: (context, snapShot) {
          final items = snapShot.data?.items ?? [];
          return items.isEmpty
              ? ticket.isTicketChargeable()
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          vertical: context.resources.dimen.dp15,
                          horizontal: context.resources.dimen.dp20),
                      color: context.resources.color.colorWhite,
                      child: _getChargeWidget(context),
                    )
                  : const SizedBox()
              : Container(
                  padding: EdgeInsets.symmetric(
                      vertical: context.resources.dimen.dp15,
                      horizontal: context.resources.dimen.dp20),
                  color: context.resources.color.colorWhite,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (ticket.isTicketChargeable()) ...[
                          _getChargeWidget(context),
                          SizedBox(
                            height: context.resources.dimen.dp10,
                          )
                        ],
                        InkWell(
                          onTap: () {
                            _isExanded.value = !_isExanded.value;
                          },
                          child: Row(
                            children: [
                              Text(
                                "Team Commnets",
                                style: context.textFontWeight600,
                              ),
                              const Spacer(),
                              ImageWidget(path: DrawableAssets.icChevronDown)
                                  .loadImage,
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable: _isExanded,
                            builder: (context, value, child) {
                              return Visibility(
                                visible: value,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: context.resources.dimen.dp10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        List.generate(items.length, (index) {
                                      final item =
                                          items[index] as TicketHistoryEntity;
                                      return Text.rich(
                                        TextSpan(
                                            text: item.comment ?? "",
                                            style: context.textFontWeight500,
                                            children: [
                                              if (item.attachments
                                                      ?.isNotEmpty ==
                                                  true) ...[
                                                WidgetSpan(
                                                  child: PopupMenuButton(
                                                    child: ImageWidget(
                                                            path: DrawableAssets
                                                                .icAttachment,
                                                            padding: EdgeInsets
                                                                .all(context
                                                                    .resources
                                                                    .dimen
                                                                    .dp5))
                                                        .loadImageWithMoreTapArea,
                                                    onSelected: (value) {
                                                      Dialogs.showDialogWithClose(
                                                          context,
                                                          maxWidth: 400,
                                                          AttachmentPreviewWidget(
                                                            fileName: value,
                                                          ));
                                                    },
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        (item.attachments ?? [])
                                                            .map((item) =>
                                                                PopupMenuItem(
                                                                  value: item,
                                                                  child: Text(
                                                                    item.toString(),
                                                                    style: context
                                                                        .textFontWeight500,
                                                                  ),
                                                                ))
                                                            .toList(),
                                                  ),
                                                )
                                              ],
                                              TextSpan(
                                                  text:
                                                      '- ${items[index].userName ?? ""}',
                                                  style: context
                                                      .textFontWeight400
                                                      .onFontSize(context
                                                          .resources
                                                          .fontSize
                                                          .dp12))
                                            ]),
                                      );
                                    }),
                                  ),
                                ),
                              );
                            }),
                      ]),
                );
        });
  }

  _updateTicket(BuildContext context, TicketEntity updateTicket, String message,
      {String apiUrl = updateTicketByStatusApiUrl}) {
    Dialogs.showDialogWithClose(
      context,
      TicketActionWidget(
          message: message,
          isCommentRequired: (updateTicket.status == StatusType.hold ||
              updateTicket.status == StatusType.reject)),
      maxWidth: isDesktop(context) ? 400 : null,
    ).then((dialogResult) {
      if (dialogResult != null) {
        updateTicket.finalComments = dialogResult['comments'];
        final data = updateTicket.toCreateJson();
        data['files'] = dialogResult['files'];
        _servicesBloc.updateTicketByStatus(apiUrl: apiUrl, requestParams: data);
      }
    });
  }

  _onActionClicked(
    BuildContext context,
    StatusType status,
  ) async {
    {
      final updateTicket = TicketEntity();
      updateTicket.id = ticket.id;
      switch (status) {
        case StatusType.returned:
          {
            Dialogs.showDialogWithClose(
                    context,
                    TicketReturnWidget(
                      ticketEntity: ticket,
                    ),
                    maxWidth: 350)
                .then((value) async {
              if (value != null) {
                printLog(value);
                updateTicket.status = StatusType.returned;
                if ((value?['employeeId'] ?? 0) > 0) {
                  updateTicket.assignedUserID = (value['employeeId'] ?? 0);
                  _updateTicket(context, updateTicket,
                      "Do you want return to ${(value['employeeName'] ?? '')}?");
                }
              }
            });
          }
        case StatusType.resubmit:
          {
            updateTicket.status = StatusType.resubmit;
            updateTicket.assignedUserID =
                ticket.previousAssignedID ?? ticket.userID;
            Dialogs.showDialogWithClose(
              context,
              TicketActionWidget(
                message: "Do you want to Resubmit?",
                isCommentRequired: false,
              ),
              maxWidth: isDesktop(context) ? 400 : null,
            ).then((dialogResult) {
              if (dialogResult != null) {
                updateTicket.finalComments = dialogResult['comments'];
                final data = updateTicket.toCreateJson();
                data['files'] = dialogResult['files'];
                _servicesBloc.updateTicketByStatus(
                    apiUrl: updateTicketByStatusApiUrl, requestParams: data);
              }
            });
          }
        case StatusType.approve || StatusType.forword:
          {
            if (ticket.categoryID == 2 && ticket.subCategoryID == 19) {
              updateTicket.status = StatusType.approve;
              updateTicket.assignedUserID = ticket.userID;
              _updateTicket(context, updateTicket, "Do you want to Approve'?",
                  apiUrl: updateTicketByStatusApiUrl);
            } else {
              Dialogs.showDialogWithClose(
                      context,
                      TicketTransferWidget(
                        ticketEntity: ticket,
                      ),
                      maxWidth: 350)
                  .then((value) async {
                updateTicket.status = StatusType.open;
                if (value['employee'] > 0) {
                  updateTicket.assignedUserID = value['employee'];
                }
                if (value['forwordCategory'] > 0) {
                  updateTicket.subCategoryID = value['forwordCategory'];
                }
                _updateTicket(context, updateTicket, "Do you want to Forword ?",
                    apiUrl: forwordTicketApiUrl);
              });
            }
          }
        case StatusType.reAssign:
          {
            Dialogs.showDialogWithClose(
                    context,
                    TicketTransferWidget(
                      ticketEntity: ticket,
                    ),
                    maxWidth: 350)
                .then((value) async {
              updateTicket.status = StatusType.open;
              if (value['employee'] > 0) {
                updateTicket.assignedUserID = value['employee'];
              }
              _updateTicket(context, updateTicket, "Do you want to Forword ?",
                  apiUrl: forwordTicketApiUrl);
            });
          }
        default:
          if (status == StatusType.closed) {
            updateTicket.isChargeable = _isChargeable.value;
          }
          updateTicket.status =
              status == StatusType.resubmit ? StatusType.open : status;
          _updateTicket(context, updateTicket,
              'Do you want to ${updateTicket.status?.name.toString()}');
      }
    }
  }

  Widget _getDataForm(BuildContext context) {
    final resources = context.resources;
    final priorities = isSelectedLocalEn
        ? [
            'Low',
            'Medium',
            'High',
            'Critical',
          ]
        : ['منخفض', 'متوسط', 'عالي', 'حرج'];
    priority = [
      'Low',
      'Medium',
      'High',
      'Critical',
    ].indexOf(ticket.priority ?? 'Low');
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
          Container(
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
                                      (subCategory as SubCategoryEntity).id ==
                                      ticket.subCategoryID)
                                  .firstOrNull;
                              return DropDownWidget(
                                list: snapShot.data?.items ?? [],
                                labelText: resources.string.subCategory,
                                isEnabled: false,
                                hintText: resources.string.subCategory
                                    .withPrefix(resources.string.pleaseSelect),
                                errorMessage: resources.string.subCategory
                                    .withPrefix(resources.string.pleaseSelect),
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
                      selectedValue: priorities[priority],
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
                      color: context.resources.color.sideBarItemUnselected,
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
                            future: value?.id == null
                                ? Future.value(ListEntity())
                                : _masterDataBloc.getEservices(
                                    requestParams: {'departmentID': value}),
                            builder: (context, snapShot) {
                              return DropDownWidget(
                                list: snapShot.data?.items ?? [],
                                labelText: resources.string.serviceName,
                                hintText: resources.string.serviceName
                                    .withPrefix(resources.string.pleaseSelect),
                                errorMessage: resources.string.serviceName
                                    .withPrefix(resources.string.pleaseSelect),
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
                        color: context.resources.color.sideBarItemUnselected,
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
                              (reason as ReasonsEntity).id == ticket.subjectID)
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
                          color: context.resources.color.sideBarItemUnselected,
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
                      color: context.resources.color.sideBarItemUnselected,
                      width: 1),
                  borderRadius: 0,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          if (ticket.attachments?.isNotEmpty == true) ...[
            Text(
              "Attachments",
              style: context.textFontWeight600,
            ),
            SizedBox(
              height: resources.dimen.dp10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(ticket.attachments?.length ?? 0, (index) {
                return InkWell(
                  onTap: () {
                    Dialogs.showDialogWithClose(
                        context,
                        maxWidth: 400,
                        AttachmentPreviewWidget(
                          fileName: ticket.attachments?[index] ?? "",
                        ));
                  },
                  child: Row(
                    children: [
                      ImageWidget(
                              path: DrawableAssets.icAttachment,
                              backgroundTint: resources.color.viewBgColor)
                          .loadImage,
                      SizedBox(
                        width: resources.dimen.dp10,
                      ),
                      Text(
                        (ticket.attachments?[index] ?? ""),
                        style: context.textFontWeight500
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(
              height: resources.dimen.dp20,
            ),
          ],
          if ((ticket.status == StatusType.closed ||
              ticket.status == StatusType.reject)) ...[_getComments(context)],
        ],
      ),
    );
  }

  Widget _getStatusWidget(BuildContext context, List<dynamic> steps) {
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
              stepColor:
                  (i < steps.length - 1 || (ticket.status == StatusType.closed))
                      ? resources.color.colorGreen26B757
                      : ticket.status == StatusType.reject
                          ? resources.color.rejected
                          : resources.color.pending,
              stepText: steps[i].userName ?? "",
              stepSubText: '${steps[i].subject}\n${steps[i].date}',
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
    final ticketActionButtons = ticket.getActionButtons(context);
    final actionButtonsLength = isDesktop(context) ? 3 : 1;
    final actionButtons = isDesktop(context)
        ? ticketActionButtons.sublist(
            0, min(actionButtonsLength, ticketActionButtons.length))
        : ticketActionButtons.sublist(0, 1);
    var popupActionButtons = List<ActionButtonEntity>.empty(growable: true);
    if (actionButtonsLength < ticketActionButtons.length) {
      popupActionButtons = ticketActionButtons.sublist(actionButtonsLength);
    }

    return Scaffold(
        backgroundColor: resources.color.appScaffoldBg,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => _servicesBloc),
            BlocProvider(create: (context) => _masterDataBloc),
          ],
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnLoading) {
                Dialogs.showInfoLoader(context, 'Updating Ticket');
              } else if (state is OnUpdateTicket) {
                Dialogs.dismiss(context);
                Dialogs.showInfoDialog(context, PopupType.success,
                        'Successfully Updated ${state.onUpdateTicketResult}')
                    .then((value) {
                  Navigator.pop(context);
                });
              } else if (state is OnApiError) {
                Dialogs.dismiss(context);
                Dialogs.showInfoDialog(context, PopupType.fail, state.message)
                    .then((value) {});
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: resources.dimen.dp15,
                  vertical: resources.dimen.dp20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text.rich(
                          TextSpan(
                              text: 'UAQGOV-ITHD- ${ticket.id}\n',
                              style: context.textFontWeight600,
                              children: [
                                TextSpan(
                                    text:
                                        'Created by ${ticket.creator} on ${ticket.createdOn}',
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
                                (ticket.status?.name ?? '').capitalize(),
                                style: context.textFontWeight700.onColor(
                                  (ticket.status == StatusType.closed)
                                      ? resources.color.colorGreen26B757
                                      : ticket.status == StatusType.reject
                                          ? resources.color.rejected
                                          : resources.color.pending,
                                ),
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: isDesktop(context)
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: _getDataForm(context),
                                      ),
                                      SizedBox(
                                        width: 280,
                                        child: FutureBuilder(
                                            future: _servicesBloc
                                                .getTicketHistory(
                                                    requestParams: {
                                                  "ticketID": ticket.id
                                                }),
                                            builder: (context, snapShot) {
                                              return _getStatusWidget(context,
                                                  snapShot.data?.items ?? []);
                                            }),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      FutureBuilder(
                                          future: _servicesBloc
                                              .getTicketHistory(requestParams: {
                                            "ticketID": ticket.id
                                          }),
                                          builder: (context, snapShot) {
                                            return _getStatusWidget(context,
                                                snapShot.data?.items ?? []);
                                          }),
                                      SizedBox(
                                        height: resources.dimen.dp20,
                                      ),
                                      _getDataForm(context),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  if ((ticket.status != StatusType.closed &&
                      ticket.status != StatusType.reject)) ...[
                    _getComments(context),
                    SizedBox(
                      height: resources.dimen.dp20,
                    ),
                  ],
                  Row(
                    children: [
                      for (int r = 0; r < actionButtons.length; r++) ...[
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              _onActionClicked(context,
                                  StatusType.fromId(actionButtons[r].id ?? 1));
                            },
                            child: ActionButtonWidget(
                              text: (actionButtons[r]).toString(),
                              color: actionButtons[r].color,
                              radious: 0,
                              textColor:
                                  r == 0 ? resources.color.textColor : null,
                              textSize: resources.fontSize.dp12,
                              padding: EdgeInsets.symmetric(
                                  vertical: resources.dimen.dp7,
                                  horizontal: resources.dimen.dp10),
                            ),
                          ),
                        ),
                        if (r < actionButtons.length) ...[
                          SizedBox(
                            width: resources.dimen.dp10,
                          ),
                        ]
                      ],
                      if (popupActionButtons.isNotEmpty &&
                          popupActionButtons.length > 1)
                        Expanded(
                            child: DropdownMenuWidget(
                          items: popupActionButtons,
                          titleText: 'Other Actions',
                          onItemSelected: (p0) {
                            _onActionClicked(
                                context, StatusType.fromId(p0.id ?? 1));
                          },
                        )),
                      if (popupActionButtons.isNotEmpty &&
                          popupActionButtons.length == 1)
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              _onActionClicked(
                                  context,
                                  StatusType.fromId(
                                      popupActionButtons[0].id ?? 1));
                            },
                            child: ActionButtonWidget(
                              text: (popupActionButtons[0]).toString(),
                              color: popupActionButtons[0].color,
                              radious: 0,
                              textColor: resources.color.textColor,
                              textSize: resources.fontSize.dp12,
                              padding: EdgeInsets.symmetric(
                                  vertical: resources.dimen.dp7,
                                  horizontal: resources.dimen.dp10),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
