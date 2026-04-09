// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/ibtaker_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/iso/iso_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/attachment_preview_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/item_service_steps.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class IbtakerDetailsScreen extends StatefulWidget {
  final IbtakerIdeaEntity idea;
  const IbtakerDetailsScreen({required this.idea, super.key});

  static Future<dynamic> start(BuildContext context, IbtakerIdeaEntity idea) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IbtakerDetailsScreen(idea: idea),
      ),
    );
  }

  @override
  State<IbtakerDetailsScreen> createState() => _IbtakerDetailsScreenState();
}

class _IbtakerDetailsScreenState extends State<IbtakerDetailsScreen> {
  final ISOBloc _isoBloc = sl<ISOBloc>();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  bool _updating = false;

  IbtakerIdeaEntity get idea => widget.idea;

  Widget _pair(BuildContext context, String title, String value) {
    final resources = context.resources;
    return Padding(
      padding: EdgeInsets.only(bottom: resources.dimen.dp12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: context.textFontWeight500
                  .onFontSize(resources.fontSize.dp12)
                  .onColor(resources.color.textColorLight),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style:
                  context.textFontWeight600.onFontSize(resources.fontSize.dp12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      BuildContext context, String title, Color color, VoidCallback onTap) {
    final resources = context.resources;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: resources.dimen.dp5),
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: resources.dimen.dp12),
            color: color,
            child: Text(
              title,
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp12)
                  .onColor(Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateStatus(IbtakerStatus status, {int? assignedTo}) async {
    if (_updating) return;
    _updating = true;
    Dialogs.loader(context);
    final remarks = _remarksController.text.trim().isEmpty
        ? '${status.toString()} by ${idea.name ?? 'user'}'
        : _remarksController.text.trim();
    final payload = <String, dynamic>{
      'id': idea.id ?? 0,
      'status': status.value,
      'remarks': remarks,
    };
    if (assignedTo != null && assignedTo > 0) {
      payload['assignedTo'] = assignedTo;
    }
    final response = await _isoBloc.createISORequest(
      apiUrl: updateIbtakerStatusApiUrl,
      requestParams: payload,
    );
    if (mounted) {
      Dialogs.dismiss(context);
      if (response is OnISOApiResponse) {
        await Dialogs.showInfoDialog(
          context,
          PopupType.success,
          isSelectedLocalEn ? 'Status updated successfully' : 'تم تحديث الحالة',
        );
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else if (response is OnISOApiError) {
        await Dialogs.showInfoDialog(
          context,
          PopupType.fail,
          response.message,
        );
      }
    }
    _updating = false;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final updates = idea.actions.isNotEmpty
        ? idea.actions
        : [
            IbtakerActionEntity()
              ..actionType = 1
              ..actionDate = idea.createdOn
              ..remarks = 'Idea submitted'
          ];
    return Scaffold(
      backgroundColor: resources.color.appScaffoldBg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(resources.dimen.dp20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: resources.color.sideBarItemSelected,
                    width: 3,
                  ),
                ),
                color: resources.color.colorWhite,
              ),
              padding: EdgeInsets.all(resources.dimen.dp10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'IBTAKER - ${idea.proposalTitle ?? '-'}\n',
                        style: context.textFontWeight700
                            .onFontSize(resources.fontSize.dp18),
                        children: [
                          TextSpan(
                            text:
                                'Created by ${idea.name ?? '-'} on ${idea.createdOn ?? '-'}',
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp11)
                                .onColor(resources.color.textColorLight),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Status',
                        style: context.textFontWeight500
                            .onFontSize(resources.fontSize.dp12),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BackgroundBoxDecoration(
                                boxColor: idea.status?.color(), radious: 5)
                            .roundedCornerBox,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Text(
                          idea.status?.toString() ?? '',
                          style: context.textFontWeight700
                              .onFontSize(
                                resources.fontSize.dp11,
                              )
                              .onColor(resources.color.colorWhite),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: resources.dimen.dp10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: resources.color.colorWhite,
                    padding: EdgeInsets.all(resources.dimen.dp20),
                    child: Column(
                      children: [
                        _pair(context, 'Name', idea.name ?? ''),
                        _pair(context, 'Employee ID', idea.empID ?? ''),
                        _pair(
                            context, 'Entity', idea.departmentData?.name ?? ''),
                        _pair(context, 'Email ID', idea.username ?? ''),
                        SizedBox(height: resources.dimen.dp10),
                        _pair(context, 'Proposal Title',
                            idea.proposalTitle ?? ''),
                        _pair(
                            context, 'Proposal Type', idea.proposalType ?? ''),
                        _pair(
                            context, 'Current Issue', idea.currentIssue ?? ''),
                        SizedBox(height: resources.dimen.dp10),
                        _pair(context, 'Improvement Proposal',
                            idea.improvementProposal ?? ''),
                        if (idea.ibtakerAttachments.isNotEmpty) ...[
                          SizedBox(height: resources.dimen.dp10),
                          Container(
                            color: resources.color.colorWhite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  resources.string.attachments,
                                  style: context.textFontWeight700
                                      .onFontSize(resources.fontSize.dp13),
                                ),
                                SizedBox(height: resources.dimen.dp10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      idea.ibtakerAttachments.length, (index) {
                                    final filePath = idea
                                            .ibtakerAttachments[index]
                                            .filePath ??
                                        '';
                                    if (filePath.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    return InkWell(
                                      onTap: () {
                                        Dialogs.showDialogWithClose(
                                          context,
                                          maxWidth: 400,
                                          AttachmentPreviewWidget(
                                              baseUrl: getPortalImageBaseUrl,
                                              fileName: filePath),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: resources.dimen.dp8),
                                        child: Row(
                                          children: [
                                            ImageWidget(
                                                    path: DrawableAssets
                                                        .icAttachment,
                                                    backgroundTint: resources
                                                        .color.viewBgColor)
                                                .loadImage,
                                            SizedBox(
                                                width: resources.dimen.dp10),
                                            Expanded(
                                              child: Text(
                                                filePath.split('/').last,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.textFontWeight500
                                                    .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(width: resources.dimen.dp10),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: resources.color.colorWhite,
                    padding: EdgeInsets.all(resources.dimen.dp15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latest Update',
                          style: context.textFontWeight700
                              .onFontSize(resources.fontSize.dp14),
                        ),
                        SizedBox(height: resources.dimen.dp10),
                        for (int i = 0; i < updates.length; i++) ...[
                          ItemServiceSteps(
                            stepText: updates[i].actionByName ?? '',
                            stepColor: (i < updates.length - 1)
                                ? Colors.green
                                : updates[i].action == IbtakerStatus.closed
                                    ? resources.color.colorGreen26B757
                                    : updates[i].action ==
                                            IbtakerStatus.rejected
                                        ? resources.color.rejected
                                        : resources.color.pending,
                            stepSubText:
                                '${updates[i].action?.toString() ?? ''}\n${updates[i].actionDate ?? ''}',
                            isLastStep: i == updates.length - 1,
                          ),
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
            if (idea.status != IbtakerStatus.closed &&
                idea.status != IbtakerStatus.rejected) ...[
              SizedBox(height: resources.dimen.dp10),
              Container(
                color: resources.color.colorWhite,
                padding: EdgeInsets.all(resources.dimen.dp15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments',
                      style: context.textFontWeight700
                          .onFontSize(resources.fontSize.dp13),
                    ),
                    SizedBox(height: resources.dimen.dp10),
                    TextFormField(
                      controller: _remarksController,
                      minLines: 3,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: resources.dimen.dp12),
              Row(
                children: [
                  if (idea.status == IbtakerStatus.approved)
                    _actionButton(
                      context,
                      IbtakerStatus.closed.toString(),
                      IbtakerStatus.closed.color(),
                      () => _updateStatus(IbtakerStatus.closed),
                    ),
                  if (idea.status == IbtakerStatus.submitted)
                    _actionButton(
                      context,
                      IbtakerStatus.approved.toString(),
                      IbtakerStatus.approved.color(),
                      () => _updateStatus(IbtakerStatus.approved),
                    ),
                  if (idea.status != IbtakerStatus.hold)
                    _actionButton(
                      context,
                      IbtakerStatus.hold.toString(),
                      IbtakerStatus.hold.color(),
                      () => _updateStatus(IbtakerStatus.hold),
                    ),
                  _actionButton(
                    context,
                    IbtakerStatus.rejected.toString(),
                    IbtakerStatus.rejected.color(),
                    () => _updateStatus(IbtakerStatus.rejected),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }
}
