// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/field_entity_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/form_entities.dart';
import 'package:ithelpdesk/domain/entities/iso_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/domain/entities/user_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/iso/iso_bloc.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_menu_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_service_steps.dart';
import 'package:ithelpdesk/presentation/common_widgets/ticket_action_widget.dart';
import 'package:ithelpdesk/presentation/iso/widgets/select_employee_widget.dart';
import 'package:ithelpdesk/presentation/profile/profile_screen_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';
import 'package:page_transition/page_transition.dart';

import '../common_widgets/alert_dialog_widget.dart';

class ISOViewRequestScreen extends BaseScreenWidget {
  static Future<dynamic> start(BuildContext context, int requestId,
      {bool? isFromRoute}) {
    return Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: ISOViewRequestScreen(
            requestId: requestId,
            isFromRoute: false,
          )),
    );
  }

  final int requestId;
  final bool? isFromRoute;
  ISOViewRequestScreen({required this.requestId, this.isFromRoute, super.key});
  late CRRequestEntity requestEntity;
  Size screenDimentions = screenSize;
  String apiResponseMessage = '';
  final ISOBloc _isoBloc = sl<ISOBloc>();
  final MasterDataBloc _masterDataBloc = sl<MasterDataBloc>();
  final Map<String, dynamic> fieldsData = {};

  final ValueNotifier<bool> _isExanded = ValueNotifier(true);
  final ValueNotifier<bool> _onDataChanged = ValueNotifier(false);

  Widget _getComments(BuildContext context,
      {EdgeInsets? padding, bool? isExpand}) {
    _isExanded.value = isExpand ?? true;
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            vertical: context.resources.dimen.dp10,
          ),
      // color: context.resources.color.viewBgColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          onTap: () {
            _isExanded.value = !_isExanded.value;
          },
          child: Container(
            padding: padding ??
                EdgeInsets.symmetric(
                    vertical: context.resources.dimen.dp10,
                    horizontal: context.resources.dimen.dp10),
            color: context.resources.color.viewBgColor,
            child: Row(
              children: [
                Text(
                  isSelectedLocalEn ? 'Request History' : 'تاریخچه درخواست ',
                  style: context.textFontWeight600
                      .onColor(context.resources.color.colorWhite),
                ),
                const Spacer(),
                ImageWidget(
                        path: DrawableAssets.icChevronDown,
                        backgroundTint: context.resources.color.colorWhite)
                    .loadImage,
              ],
            ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(requestEntity.requestHistory.length,
                        (index) {
                      final item = requestEntity.requestHistory[index];
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: context.resources.dimen.dp5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}.',
                              style: context.textFontWeight600,
                            ),
                            SizedBox(
                              width: context.resources.dimen.dp5,
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                    text: item.name ?? "",
                                    style: context.textFontWeight600,
                                    children: [
                                      if (item.comments.firstOrNull != null)
                                        TextSpan(
                                          text:
                                              '\n${isSelectedLocalEn ? 'Details' : ''}: ${item.comments.firstOrNull?.comment ?? ""}',
                                          style: context.textFontWeight500,
                                        ),
                                      if (item.attachments.isNotEmpty ==
                                          true) ...[
                                        TextSpan(
                                          text:
                                              '\n${isSelectedLocalEn ? 'Attachements' : ''}: ',
                                          style: context.textFontWeight500,
                                        ),
                                        for (var i = 0;
                                            i < item.attachments.length;
                                            i++) ...[
                                          if (i != 0) ...[
                                            TextSpan(
                                                text: ', ',
                                                style:
                                                    context.textFontWeight500)
                                          ],
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                openNewTab(
                                                  '${requestEntity.attachmentUrlPrefix}${item.attachments[i].name ?? ""}',
                                                );
                                              },
                                            text: '${item.attachments[i].name}',
                                            style: context.textFontWeight500
                                                .onColor(context.resources.color
                                                    .viewBgColor)
                                                .copyWith(
                                                    decoration: TextDecoration
                                                        .underline),
                                          ),
                                        ],
                                        // WidgetSpan(
                                        //   child: PopupMenuButton(
                                        //     child: ImageWidget(
                                        //             path: DrawableAssets
                                        //                 .icAttachment,
                                        //             padding: EdgeInsets.all(
                                        //                 context
                                        //                     .resources.dimen.dp5))
                                        //         .loadImageWithMoreTapArea,
                                        //     onSelected: (value) {
                                        //       openNewTab(
                                        //         '${requestEntity.attachmentUrlPrefix}${item.attachments[index].name ?? ""}',
                                        //       );
                                        //     },
                                        //     itemBuilder: (BuildContext context) =>
                                        //         (item.attachments)
                                        //             .map((item) => PopupMenuItem(
                                        //                   value: item,
                                        //                   child: Text(
                                        //                     item.toString(),
                                        //                     style: context
                                        //                         .textFontWeight500,
                                        //                   ),
                                        //                 ))
                                        //             .toList(),
                                        //   ),
                                        // )
                                      ],
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              );
            }),
      ]),
    );
  }

  _updateTicket(
    BuildContext context,
    RequestStepStatus status,
  ) async {
    //requestEntity.status = updateTicket.status;
    String message = '';
    bool isCommentRequired = true;
    switch (status) {
      case RequestStepStatus.returned:
        {
          message = 'Do you want to return?';
          _showSelectEmployeeDialog(
              context, status, message, isCommentRequired);
          return;
        }
      case RequestStepStatus.approved:
        {
          message = 'Approve';
        }
      case RequestStepStatus.close:
        {
          message = 'Do you want to close?';
        }
      case RequestStepStatus.aquire:
        {
          final requestParams = {
            'requestID': requestEntity.requestId,
            'requestStepStatus': status.value,
          };
          _isoBloc.createISORequest(
              requestParams: requestParams,
              apiUrl: updateCRRequestApiUrl,
              emitResponse: true);
        }
      case RequestStepStatus.transfer:
        {
          message = 'Do you want to transfer?';
          _showSelectEmployeeDialog(
              context, status, message, isCommentRequired);
          return;
        }
      case RequestStepStatus.reject:
        {
          message = 'Do you want to transfer?';
        }
      case RequestStepStatus.hold:
        {
          message = 'Do you want to hold?';
        }
      case RequestStepStatus.reSubmit:
        {
          message = 'Do you want to submit?';
        }
      default:
        {
          return;
        }
    }
    if (status == RequestStepStatus.aquire) {
    } else {
      _updateDialog(context, status, message, isCommentRequired);
    }
  }

  _showSelectEmployeeDialog(
    BuildContext context,
    RequestStepStatus status,
    String message,
    bool isCommentRequired,
  ) async {
    Dialogs.loader(context);
    final employees = await _isoBloc.getCRTransferEmployees(requestParams: {
      'requestId': requestEntity.requestId,
      'action': status.value
    });
    if (!context.mounted) {
      return;
    }
    Dialogs.dismiss(context);
    if (employees is OnISOApiResponse) {
      final items = cast<ListEntity?>(employees.response.entity)?.items ?? [];
      Dialogs.showDialogWithClose(
        context,
        SelectEmployeeWidget(
            title: '${status.toString()} To:',
            employees: items.cast<UserEntity>()),
        maxWidth: isDesktop(context, size: screenDimentions) ? 450 : null,
      ).then((value) {
        if (value != null) {
          if (context.mounted) {
            _updateDialog(context, status, message, isCommentRequired,
                transferedTo: value['employeeId']);
          }
        }
      });
    } else if (employees is OnISOApiError) {}
  }

  _updateDialog(BuildContext context, RequestStepStatus status, String message,
      bool isCommentRequired,
      {int? transferedTo}) {
    Dialogs.showDialogWithClose(
      context,
      TicketActionWidget(
        message: message,
        isCommentRequired: isCommentRequired,
        showIssueType: false,
      ),
      maxWidth: isDesktop(context, size: screenDimentions) ? 450 : null,
    ).then((dialogResult) {
      if (dialogResult != null) {
        final requestParams = {
          'requestID': requestEntity.requestId,
          'requestStepStatus': status.value,
          'comments': dialogResult['comments'],
          'files': dialogResult['files']
        };
        requestParams['transferedTo'] = transferedTo;
        _isoBloc.createISORequest(
            requestParams: requestParams,
            apiUrl: updateCRRequestApiUrl,
            emitResponse: true);
      }
    });
  }

  // _onActionClicked(
  //   BuildContext context,
  //   StatusType status,
  // ) async {
  //   {
  //     final updateTicket = TicketEntity();
  //     updateTicket.id = requestEntity.requestId;
  //     updateTicket.categoryID = requestEntity.requestId;
  //     switch (status) {
  //       case StatusType.returned:
  //         {
  //           Dialogs.showDialogWithClose(
  //                   context,
  //                   TicketReturnWidget(
  //                     ticketEntity: requestEntity,
  //                   ),
  //                   maxWidth: 350)
  //               .then((value) async {
  //             if (value != null) {
  //               if (!context.mounted) {
  //                 return;
  //               }
  //               updateTicket.status = StatusType.returned;
  //               if ((value?['employeeId'] ?? 0) > 0) {
  //                 updateTicket.assignedUserID = (value['employeeId'] ?? 0);
  //                 _updateTicket(context, updateTicket,
  //                     "${context.resources.string.doYouWantReturnTo} ${(value['employeeName'] ?? '')}?");
  //               }
  //             }
  //           });
  //         }
  //       case StatusType.resubmit || StatusType.reopen:
  //         {
  //           updateTicket.status = status;
  //           if (status == StatusType.resubmit) {
  //             updateTicket.assignedUserID =
  //                 requestEntity.previousAssignedID ?? requestEntity.userID;
  //           }
  //           Dialogs.showDialogWithClose(
  //             context,
  //             TicketActionWidget(
  //               message: "${context.resources.string.doYouWantToResubmit}?",
  //               isCommentRequired: false,
  //             ),
  //             maxWidth: isDesktop(context, size: screenDimentions) ? 400 : null,
  //           ).then((dialogResult) {
  //             if (dialogResult != null) {
  //               updateTicket.finalComments = dialogResult['comments'];
  //               final data = updateTicket.toCreateJson();
  //               data['files'] = dialogResult['files'];
  //               // _servicesBloc.updateTicketByStatus(
  //               //     apiUrl: updateTicketByStatusApiUrl, requestParams: data);
  //             }
  //           });
  //         }
  //       case StatusType.approve || StatusType.forward:
  //         {
  //           if (requestEntity.categoryID == 2 && requestEntity.subCategoryID == 19) {
  //             updateTicket.status = StatusType.approve;
  //             updateTicket.assignedUserID = requestEntity.userID;
  //             _updateTicket(context, updateTicket,
  //                 "${context.resources.string.doYouWantToApprove} ?",
  //                 apiUrl: updateTicketByStatusApiUrl);
  //           } else {
  //             Dialogs.showDialogWithClose(
  //                     context,
  //                     TicketTransferWidget(
  //                       ticketEntity: requestEntity,
  //                     ),
  //                     maxWidth: 450)
  //                 .then((value) async {
  //               updateTicket.status = StatusType.open;
  //               if (value['employee'] > 0) {
  //                 updateTicket.assignedUserID = value['employee'];
  //               }
  //               if (value['forwordCategory'] > 0) {
  //                 updateTicket.subCategoryID = value['forwordCategory'];
  //               }
  //               _updateTicket(context, updateTicket,
  //                   "${context.resources.string.doYouWantToForword} ?",
  //                   apiUrl: forwordTicketApiUrl);
  //             });
  //           }
  //         }
  //       case StatusType.reAssign:
  //         {
  //           if (requestEntity.status == StatusType.acquired) {
  //             Dialogs.showDialogWithClose(
  //                 context,
  //                 showClose: false,
  //                 ConformDialogWidget(
  //                     message:
  //                         "This ticket already acquired by ${requestEntity.assignedTo}\n Do you want to Reassign?"));
  //           } else {
  //             Dialogs.showDialogWithClose(
  //                     context,
  //                     TicketTransferWidget(
  //                       ticketEntity: requestEntity,
  //                     ),
  //                     maxWidth: 450)
  //                 .then((value) async {
  //               updateTicket.status = StatusType.open;
  //               if (value['employee'] > 0) {
  //                 updateTicket.assignedUserID = value['employee'];
  //               }
  //               _updateTicket(context, updateTicket,
  //                   "${context.resources.string.doYouWantToForword} ?",
  //                   apiUrl: forwordTicketApiUrl);
  //             });
  //           }
  //         }
  //       default:
  //         if (status == StatusType.closed) {
  //           updateTicket.isChargeable = _isChargeable.value;
  //         }
  //         updateTicket.status =
  //             status == StatusType.resubmit ? StatusType.open : status;
  //         updateTicket.assignedUserID =
  //             updateTicket.assignedUserID ?? UserCredentialsEntity.details().id;
  //         _updateTicket(context, updateTicket,
  //             '${context.resources.string.doYouWantTo} ${updateTicket.status?.name.toString()}');
  //     }
  //   }
  // }

  Widget _getDataForm(BuildContext context) {
    final resources = context.resources;
    final currentStep = requestEntity.steps
        .where((e) => e.requestStepId == requestEntity.currentStep)
        .firstOrNull;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp15, horizontal: resources.dimen.dp20),
      color: resources.color.colorWhite,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: resources.color.colorWhite,
              child: Table(
                children: [
                  for (var item in requestEntity.toDetailsJson().entries) ...[
                    TableRow(children: [
                      Text(item.key, style: context.textFontWeight400),
                      Text(': ${item.value ?? ''}',
                          style: context.textFontWeight600),
                    ])
                  ]
                ],
              ),
            ),
            SizedBox(
              height: resources.dimen.dp20,
            ),
            if (requestEntity.attachments?.isNotEmpty == true) ...[
              Text(
                resources.string.attachments,
                style: context.textFontWeight600,
              ),
              SizedBox(
                height: resources.dimen.dp10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(requestEntity.attachments?.length ?? 0,
                    (index) {
                  return InkWell(
                    onTap: () {
                      openNewTab(
                        '${requestEntity.attachmentUrlPrefix}${requestEntity.attachments?[index].name ?? ""}',
                      );
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
                          (requestEntity.attachments?[index].name ?? ""),
                          style: context.textFontWeight500
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
            for (FormEntity field in currentStep?.inputFields ?? []) ...{
              field.getWidget(context)
            },
            // if (requestEntity
            //         .steps[(requestEntity.currentStep ?? 1) - 1].status !=
            //     RequestStepStatus.close) ...[
            //   SizedBox(
            //     height: resources.dimen.dp20,
            //   ),
            //   SizedBox(
            //     height: resources.dimen.dp20,
            //   ),
            //   (FormEntity()
            //         ..type = FormFieldType.textarea
            //         ..label = 'Comments'
            //         ..onDatachnage = (value) {
            //           _commentsController.text = value;
            //         })
            //       .getWidget(context),
            //   SizedBox(
            //     height: resources.dimen.dp10,
            //   ),
            //   (FormEntity()
            //         ..type = FormFieldType.multifile
            //         ..label = resources.string.uploadFile
            //         ..onDatachnage = (value) {
            //           fieldsData['files'] = value;
            //         })
            //       .getWidget(context),
            // ],
            SizedBox(
              height: resources.dimen.dp20,
            ),
            _getComments(context)
          ],
        ),
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
          ? EdgeInsets.only(
              left: isDesktop(context, size: screenDimentions)
                  ? resources.dimen.dp20
                  : 0)
          : EdgeInsets.only(
              right: isDesktop(context, size: screenDimentions)
                  ? resources.dimen.dp20
                  : 0),
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
                  (requestEntity.steps[i].status == RequestStepStatus.close ||
                          requestEntity.requestStaus == RequestStatus.completed)
                      ? resources.color.colorGreen26B757
                      : requestEntity.requestStaus == RequestStatus.rejected
                          ? resources.color.rejected
                          : resources.color.pending,
              stepText: steps[i].assigneDisplayName ?? "",
              stepSubText:
                  '${steps[i].status.toString()}\n${steps[i].updatedAt}',
              isLastStep: i == steps.length - 1,
              userProfileCallback: () {
                if (steps[i].assignedTo != null) {
                  Dialogs.showDialogWithClose(
                    context,
                    ProfileScreenWidget(
                      userName: '${steps[i].assignedTo ?? ""}',
                    ),
                    maxWidth:
                        isDesktop(context, size: screenDimentions) ? 400 : null,
                  );
                }
              },
            )
          ]
        ],
      ),
    );
  }

  Future<ISOApiState> _getRequestDetails() async {
    final response = await _isoBloc
        .getRequestsDetails(requestParams: {'requestID': requestId});
    return Future.value(response);
  }

  Widget _getScrollwidget(
      BuildContext context, CRRequestEntity requestDetails) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: isDesktop(context, size: screenDimentions)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _getDataForm(context),
                      ),
                      SizedBox(
                        width: 280,
                        child: _getStatusWidget(context, requestDetails.steps),
                      )
                    ],
                  )
                : Column(
                    children: [
                      _getStatusWidget(context, requestDetails.steps),
                      SizedBox(
                        height: context.resources.dimen.dp20,
                      ),
                      _getDataForm(context),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    screenDimentions = getScrrenSize(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _isoBloc),
        BlocProvider(create: (context) => _masterDataBloc),
      ],
      child: BlocListener<ISOBloc, ISOApiState>(
        listener: (context, state) {
          if (state is OnISOApiLoading) {
            Dialogs.showInfoLoader(context, resources.string.updatingTicket);
          } else if (state is OnISOApiResponse) {
            Dialogs.dismiss(context);
            Dialogs.showInfoDialog(context, PopupType.success,
                    '${resources.string.updatingTicket} UAQGOV-CR-${requestEntity.requestId}')
                .then((value) {
              reloadPage();
            });
          } else if (state is OnISOApiError) {
            Dialogs.dismiss(context);
            Dialogs.showInfoDialog(context, PopupType.fail, state.message);
          }
        },
        child: SelectionArea(
          child: Container(
            color: resources.color.appScaffoldBg,
            padding: EdgeInsets.symmetric(
                horizontal: resources.dimen.dp15,
                vertical: resources.dimen.dp20),
            child: FutureBuilder(
                future: _getRequestDetails(),
                builder: (context, snapShot) {
                  if (snapShot.data == null) {
                    return const SizedBox();
                  }
                  final response = snapShot.data;
                  if (response is OnISOApiError) {
                    return Center(
                      child: Text(
                        response.message,
                        style: context.textFontWeight600
                            .onColor(resources.color.rejected),
                      ),
                    );
                  }
                  requestEntity = (response as OnISOApiResponse).response.entity
                      as CRRequestEntity;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text.rich(
                              TextSpan(
                                  text:
                                      'UAQGOV-CR-${requestEntity.requestId}\n',
                                  style: context.textFontWeight600
                                      .onFontFamily(fontFamily: fontFamilyEN),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${resources.string.createdBy} ${requestEntity.steps[0].assigneDisplayName} ${resources.string.on} ${requestEntity.createdAt}',
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
                            flex: isDesktop(context, size: screenDimentions)
                                ? 1
                                : 0,
                            child: Padding(
                              padding: isSelectedLocalEn
                                  ? EdgeInsets.only(left: resources.dimen.dp20)
                                  : EdgeInsets.only(
                                      right: resources.dimen.dp20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                        text: '${resources.string.status}: ',
                                        style: context.textFontWeight600,
                                        children: [
                                          TextSpan(
                                            text: (requestEntity.requestStaus
                                                    .toString())
                                                .toString(),
                                            style: context.textFontWeight700
                                                .onColor((requestEntity
                                                            .requestStaus ??
                                                        RequestStatus
                                                            .inprogress)
                                                    .getColor()),
                                          ),
                                        ]),
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
                      (isFromRoute ?? true)
                          ? _getScrollwidget(context, requestEntity)
                          : Expanded(
                              child: _getScrollwidget(context, requestEntity)),
                      SizedBox(
                        height: resources.dimen.dp20,
                      ),
                      // if (requestEntity.status != RequestStatus.rejected &&
                      //     requestEntity.status != RequestStatus.completed) ...[
                      // _getComments(context),
                      // SizedBox(
                      //   height: resources.dimen.dp20,
                      // ),
                      // ],
                      ValueListenableBuilder(
                          valueListenable: _onDataChanged,
                          builder: (context, onDataChange, child) {
                            final currentStepDetails = requestEntity.steps
                                .where((element) =>
                                    element.requestStepId ==
                                    requestEntity.currentStep)
                                .firstOrNull;
                            if (currentStepDetails == null) {
                              return const SizedBox();
                            }
                            if (currentStepDetails.status ==
                                RequestStepStatus.close) {
                              return const SizedBox();
                            }
                            final ticketActionButtons = currentStepDetails
                                    .assignees
                                    .where((element) =>
                                        element.employeeId ==
                                        UserCredentialsEntity.details().id)
                                    .firstOrNull
                                    ?.actions
                                    .map((e) =>
                                        e.actionId ??
                                        RequestStepStatus.inProgress)
                                    .toList() ??
                                [];
                            final actionButtonsLength =
                                isDesktop(context, size: screenDimentions)
                                    ? 3
                                    : 1;
                            final actionButtons = ticketActionButtons.sublist(
                                0,
                                min(actionButtonsLength,
                                    ticketActionButtons.length));
                            var popupActionButtons =
                                List<RequestStepStatus>.empty(growable: true);
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
                                // for (int i = 0;
                                //     i <
                                //         (actionButtonsLength + 1) -
                                //             ticketActionButtons.length;
                                //     i++) ...[const Expanded(child: SizedBox())],
                                for (int r = 0;
                                    r < actionButtons.length;
                                    r++) ...[
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        _updateTicket(
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
                                      _updateTicket(context, p0);
                                    },
                                  )),
                              ],
                            );
                          }),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
