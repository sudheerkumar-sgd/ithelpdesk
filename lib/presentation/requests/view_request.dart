// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/string_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/confirm_dialog_widget.dart';
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
  final TextEditingController _rasisedByController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reqNoController = TextEditingController();
  final TextEditingController _servieNameController = TextEditingController();
  final TextEditingController _tradeLicenseNameController =
      TextEditingController();
  final TextEditingController _tradeLicenseNumberController =
      TextEditingController();

  final ValueNotifier<bool> _isExanded = ValueNotifier(false);
  final ValueNotifier<bool> _onDataChanged = ValueNotifier(false);

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

  Widget _getComments(BuildContext context,
      {EdgeInsets? padding, bool? isExpand}) {
    _isExanded.value = isExpand ?? false;
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
                  padding: padding ??
                      EdgeInsets.symmetric(
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
                                context.resources.string.teamComments,
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
                                                      '- ${item.userName ?? ""}',
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
    ticket.status = updateTicket.status;
    if (updateTicket.status == StatusType.acquired) {
      final data = updateTicket.toCreateJson();
      _servicesBloc.updateTicketByStatus(apiUrl: apiUrl, requestParams: data);
    } else {
      Dialogs.showDialogWithClose(
        context,
        TicketActionWidget(
          message: message,
          isCommentRequired: updateTicket.isCommentRequired,
          showIssueType: updateTicket.showIssueType,
        ),
        maxWidth: isDesktop(context) ? 450 : null,
      ).then((dialogResult) {
        if (dialogResult != null) {
          updateTicket.finalComments = dialogResult['comments'];
          updateTicket.issueType = dialogResult['issueType'];
          final data = updateTicket.toCreateJson();
          data['files'] = dialogResult['files'];
          _servicesBloc.updateTicketByStatus(
              apiUrl: apiUrl, requestParams: data);
        }
      });
    }
  }

  _onActionClicked(
    BuildContext context,
    StatusType status,
  ) async {
    {
      final updateTicket = TicketEntity();
      updateTicket.id = ticket.id;
      updateTicket.categoryID = ticket.categoryID;
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
                updateTicket.status = StatusType.returned;
                if ((value?['employeeId'] ?? 0) > 0) {
                  updateTicket.assignedUserID = (value['employeeId'] ?? 0);
                  _updateTicket(context, updateTicket,
                      "${context.resources.string.doYouWantReturnTo} ${(value['employeeName'] ?? '')}?");
                }
              }
            });
          }
        case StatusType.resubmit || StatusType.reopen:
          {
            updateTicket.status = status;
            if (status == StatusType.resubmit) {
              updateTicket.assignedUserID =
                  ticket.previousAssignedID ?? ticket.userID;
            }
            Dialogs.showDialogWithClose(
              context,
              TicketActionWidget(
                message: "${context.resources.string.doYouWantToResubmit}?",
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
        case StatusType.approve || StatusType.forward:
          {
            if (ticket.categoryID == 2 && ticket.subCategoryID == 19) {
              updateTicket.status = StatusType.approve;
              updateTicket.assignedUserID = ticket.userID;
              _updateTicket(context, updateTicket,
                  "${context.resources.string.doYouWantToApprove} ?",
                  apiUrl: updateTicketByStatusApiUrl);
            } else {
              Dialogs.showDialogWithClose(
                      context,
                      TicketTransferWidget(
                        ticketEntity: ticket,
                      ),
                      maxWidth: 450)
                  .then((value) async {
                updateTicket.status = StatusType.open;
                if (value['employee'] > 0) {
                  updateTicket.assignedUserID = value['employee'];
                }
                if (value['forwordCategory'] > 0) {
                  updateTicket.subCategoryID = value['forwordCategory'];
                }
                _updateTicket(context, updateTicket,
                    "${context.resources.string.doYouWantToForword} ?",
                    apiUrl: forwordTicketApiUrl);
              });
            }
          }
        case StatusType.reAssign:
          {
            if (ticket.status == StatusType.acquired) {
              Dialogs.showDialogWithClose(
                  context,
                  showClose: false,
                  ConformDialogWidget(
                      message:
                          "This ticket already acquired by ${ticket.assignedTo}\n Do you want to Reassign?"));
            } else {
              Dialogs.showDialogWithClose(
                      context,
                      TicketTransferWidget(
                        ticketEntity: ticket,
                      ),
                      maxWidth: 450)
                  .then((value) async {
                updateTicket.status = StatusType.open;
                if (value['employee'] > 0) {
                  updateTicket.assignedUserID = value['employee'];
                }
                _updateTicket(context, updateTicket,
                    "${context.resources.string.doYouWantToForword} ?",
                    apiUrl: forwordTicketApiUrl);
              });
            }
          }
        default:
          if (status == StatusType.closed) {
            updateTicket.isChargeable = _isChargeable.value;
          }
          updateTicket.status =
              status == StatusType.resubmit ? StatusType.open : status;
          updateTicket.assignedUserID =
              updateTicket.assignedUserID ?? UserCredentialsEntity.details().id;
          _updateTicket(context, updateTicket,
              '${context.resources.string.doYouWantTo} ${updateTicket.status?.name.toString()}');
      }
    }
  }

  Widget _getDataForm(BuildContext context) {
    final resources = context.resources;
    final priorities = getPriorityTypes();
    _contactNoController.text = ticket.mobileNumber ?? '';
    _rasisedByController.text = ticket.raisedByName ?? '';
    _reasonController.text = ticket.subject ?? '';
    _descriptionController.text = ticket.description ?? '';
    _reqNoController.text = ticket.serviceReqNo ?? '';
    _servieNameController.text = ticket.serviceName ?? '';
    _tradeLicenseNameController.text = ticket.tradeLicenseName ?? '';
    _tradeLicenseNumberController.text = '${ticket.tradeLicenseNumber ?? 0}';
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
                              var selectedValue = (snapShot.data?.items ??
                                      List<SubCategoryEntity>.empty())
                                  .where((subCategory) =>
                                      (subCategory as SubCategoryEntity).id ==
                                      ticket.subCategoryID)
                                  .firstOrNull;
                              if (selectedValue != null) {
                                _subCategoryValue.value ??=
                                    selectedValue as SubCategoryEntity;
                              }
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
                        child: DropDownWidget<PriorityType>(
                      list: priorities,
                      isEnabled: ticket.canEnable(),
                      labelText: resources.string.priority,
                      hintText: resources.string.priority
                          .withPrefix(resources.string.pleaseSelect),
                      errorMessage: resources.string.priority
                          .withPrefix(resources.string.pleaseSelect),
                      borderRadius: 0,
                      fillColor: resources.color.colorWhite,
                      selectedValue: ticket.priority,
                      callback: (value) {
                        //priority = priorities.indexOf(value ?? '');
                      },
                    )),
                  ],
                ),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RightIconTextWidget(
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
                    ),
                    if (ticket.categoryID == 3) ...[
                      SizedBox(
                        width: resources.dimen.dp40,
                      ),
                      Expanded(
                        child: RightIconTextWidget(
                          isEnabled: false,
                          labelText: resources.string.raisedBy,
                          textController: _rasisedByController,
                          fillColor: resources.color.colorWhite,
                          borderSide: BorderSide(
                              color:
                                  context.resources.color.sideBarItemUnselected,
                              width: 1),
                          borderRadius: 0,
                          onChanged: (value) {},
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
                if (ticket.categoryID == 3) ...[
                  FutureBuilder(
                      future: _masterDataBloc.getEservices(requestParams: {
                        'departmentID': ticket.subCategoryID
                      }),
                      builder: (context, snapShot) {
                        var selectedValue = snapShot.data?.items
                            .where((item) =>
                                (item as EserviceEntity).id == ticket.serviceId)
                            .firstOrNull;
                        return DropDownWidget(
                          isEnabled: ticket.canEnable(),
                          list: snapShot.data?.items ?? [],
                          labelText: resources.string.serviceName,
                          selectedValue: selectedValue,
                          hintText: resources.string.serviceName
                              .withPrefix(resources.string.pleaseSelect),
                          errorMessage: resources.string.serviceName
                              .withPrefix(resources.string.pleaseSelect),
                          borderRadius: 0,
                          fillColor: resources.color.colorWhite,
                          callback: (value) {},
                        );
                      }),
                  if (ticket.serviceId == 0) ...[
                    SizedBox(
                      height: resources.dimen.dp10,
                    ),
                    RightIconTextWidget(
                      isEnabled: false,
                      textController: _servieNameController,
                      hintText: resources.string.serviceName
                          .withPrefix(resources.string.pleaseEnter),
                      errorMessage: resources.string.serviceName
                          .withPrefix(resources.string.pleaseEnter),
                      fillColor: resources.color.colorWhite,
                      borderSide: BorderSide(
                          color: context.resources.color.sideBarItemUnselected,
                          width: 1),
                      borderRadius: 0,
                    ),
                  ],
                  SizedBox(
                    height: resources.dimen.dp10,
                  ),
                  RightIconTextWidget(
                    isEnabled: false,
                    textController: _reqNoController,
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
                  if (ticket.subCategoryID == 2) ...[
                    SizedBox(
                      height: resources.dimen.dp10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RightIconTextWidget(
                            isEnabled: false,
                            textController: _tradeLicenseNameController,
                            labelText: resources.string.tradeLicenseName,
                            hintText: resources.string.tradeLicenseName
                                .withPrefix(resources.string.pleaseEnter),
                            errorMessage: resources.string.tradeLicenseName
                                .withPrefix(resources.string.pleaseEnter),
                            fillColor: resources.color.colorWhite,
                            borderSide: BorderSide(
                                color: context
                                    .resources.color.sideBarItemUnselected,
                                width: 1),
                            borderRadius: 0,
                          ),
                        ),
                        SizedBox(
                          width: resources.dimen.dp40,
                        ),
                        Expanded(
                          child: RightIconTextWidget(
                            isEnabled: false,
                            textController: _tradeLicenseNumberController,
                            labelText: resources.string.tradeLicenseNumber,
                            textInputType: TextInputType.number,
                            hintText: resources.string.tradeLicenseNumber
                                .withPrefix(resources.string.pleaseEnter),
                            errorMessage: resources.string.tradeLicenseNumber
                                .withPrefix(resources.string.pleaseEnter),
                            fillColor: resources.color.colorWhite,
                            borderSide: BorderSide(
                                color: context
                                    .resources.color.sideBarItemUnselected,
                                width: 1),
                            borderRadius: 0,
                          ),
                        ),
                      ],
                    )
                  ],
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
              resources.string.attachments,
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
              ticket.status == StatusType.reject)) ...[
            _getComments(context,
                padding: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp15,
                ),
                isExpand: true)
          ],
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
      margin: isSelectedLocalEn
          ? EdgeInsets.only(left: isDesktop(context) ? resources.dimen.dp20 : 0)
          : EdgeInsets.only(
              right: isDesktop(context) ? resources.dimen.dp20 : 0),
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

    return SelectionArea(
      child: Scaffold(
          backgroundColor: resources.color.appScaffoldBg,
          body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => _servicesBloc),
              BlocProvider(create: (context) => _masterDataBloc),
            ],
            child: BlocListener<ServicesBloc, ServicesState>(
              listener: (context, state) {
                if (state is OnLoading) {
                  Dialogs.showInfoLoader(
                      context, resources.string.updatingTicket);
                } else if (state is OnUpdateTicket) {
                  final updatedTicket = state.onUpdateTicketResult.entity;
                  ticket.assignedUserID = updatedTicket?.assignedUserID;
                  ticket.status = updatedTicket?.status;
                  Dialogs.dismiss(context);
                  Dialogs.showInfoDialog(context, PopupType.success,
                          '${resources.string.updatingTicket} UAQGOV-ITHD-${ticket.id}')
                      .then((value) {
                    if (ticket.status != StatusType.acquired) {
                      reloadPage();
                    } else {
                      _onDataChanged.value = !(_onDataChanged.value);
                    }
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text.rich(
                            TextSpan(
                                text: 'UAQGOV-ITHD-${ticket.id}\n',
                                style: context.textFontWeight600
                                    .onFontFamily(fontFamily: fontFamilyEN),
                                children: [
                                  TextSpan(
                                      text:
                                          '${resources.string.createdBy} ${ticket.creator} ${resources.string.on} ${ticket.createdOn}',
                                      style: context.textFontWeight400
                                          .onFontSize(resources.fontSize.dp10)
                                          .onColor(
                                              resources.color.textColorLight)
                                          .onHeight(1)
                                          .onFontFamily(
                                              fontFamily: fontFamilyEN))
                                ]),
                          ),
                        ),
                        Expanded(
                          flex: isDesktop(context) ? 1 : 0,
                          child: Padding(
                            padding: isSelectedLocalEn
                                ? EdgeInsets.only(left: resources.dimen.dp20)
                                : EdgeInsets.only(right: resources.dimen.dp20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${resources.string.status}: ',
                                  style: context.textFontWeight600,
                                ),
                                SizedBox(
                                  width: resources.dimen.dp5,
                                ),
                                Text(
                                  (ticket.status ?? StatusType.open).toString(),
                                  style: context.textFontWeight700.onColor(
                                      (ticket.status ?? StatusType.open)
                                          .getColor()),
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
                                          child: ValueListenableBuilder(
                                              valueListenable: _onDataChanged,
                                              builder: (context, onDataChanged,
                                                  child) {
                                                return FutureBuilder(
                                                    future: _servicesBloc
                                                        .getTicketHistory(
                                                            requestParams: {
                                                          "ticketID": ticket.id
                                                        }),
                                                    builder:
                                                        (context, snapShot) {
                                                      return _getStatusWidget(
                                                          context,
                                                          snapShot.data
                                                                  ?.items ??
                                                              []);
                                                    });
                                              }),
                                        )
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        FutureBuilder(
                                            future: _servicesBloc
                                                .getTicketHistory(
                                                    requestParams: {
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
                    if (ticket.status != StatusType.reject &&
                        ticket.status != StatusType.closed) ...[
                      _getComments(context),
                      SizedBox(
                        height: resources.dimen.dp20,
                      ),
                    ],
                    ValueListenableBuilder(
                        valueListenable: _onDataChanged,
                        builder: (context, onDataChange, child) {
                          final ticketActionButtons =
                              ticket.getActionButtons(context);
                          final actionButtonsLength =
                              isDesktop(context) ? 3 : 1;
                          final actionButtons = isDesktop(context)
                              ? ticketActionButtons.sublist(
                                  0,
                                  min(actionButtonsLength,
                                      ticketActionButtons.length))
                              : ticketActionButtons.sublist(0, 1);
                          var popupActionButtons =
                              List<StatusType>.empty(growable: true);
                          if (actionButtonsLength + 1 ==
                              ticketActionButtons.length) {
                            actionButtons.addAll(ticketActionButtons
                                .sublist(actionButtonsLength));
                          } else if (actionButtonsLength <
                              ticketActionButtons.length) {
                            popupActionButtons = ticketActionButtons
                                .sublist(actionButtonsLength);
                          }
                          return Row(
                            children: [
                              for (int r = 0;
                                  r < actionButtons.length;
                                  r++) ...[
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      _onActionClicked(
                                          context, actionButtons[r]);
                                    },
                                    child: ActionButtonWidget(
                                      text: (actionButtons[r]).toString(),
                                      color: actionButtons[r].getColor(),
                                      radious: 0,
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
                              if (popupActionButtons.isNotEmpty)
                                Expanded(
                                    child: DropdownMenuWidget(
                                  items: popupActionButtons,
                                  titleText: resources.string.otherActions,
                                  onItemSelected: (p0) {
                                    _onActionClicked(context, p0);
                                  },
                                )),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
