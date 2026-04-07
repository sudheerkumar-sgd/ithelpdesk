// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/ibtaker_entity.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';

class IbtakerDetailsScreen extends BaseScreenWidget {
  final IbtakerIdeaEntity idea;
  IbtakerDetailsScreen({required this.idea, super.key});

  static Future<dynamic> start(BuildContext context, IbtakerIdeaEntity idea) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IbtakerDetailsScreen(idea: idea),
      ),
    );
  }

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
                        color: const Color(0xffFBE4B2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Text(
                          (idea.status == 3)
                              ? 'Approved'
                              : (idea.status == 5)
                                  ? 'Rejected'
                                  : 'Open',
                          style: context.textFontWeight700.onFontSize(
                            resources.fontSize.dp11,
                          ),
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
                        for (final action in updates.take(5)) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(top: 5),
                                decoration: const BoxDecoration(
                                  color: Color(0xff41C76A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${action.actionName}\n${action.actionDate ?? ''}',
                                  style: context.textFontWeight500
                                      .onFontSize(resources.fontSize.dp11),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: resources.dimen.dp10),
                        ]
                      ],
                    ),
                  ),
                )
              ],
            ),
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
                    minLines: 3,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: resources.dimen.dp12),
            Row(
              children: [
                _actionButton(
                  context,
                  'Close',
                  resources.color.colorGray9E9E9E,
                  () => Navigator.pop(context),
                ),
                _actionButton(
                  context,
                  'Transfer',
                  const Color(0xffF6A63A),
                  () {},
                ),
                _actionButton(
                  context,
                  'Approve',
                  const Color(0xff4CAF50),
                  () {},
                ),
                _actionButton(
                  context,
                  'Hold',
                  const Color(0xff3B77F5),
                  () {},
                ),
                _actionButton(
                  context,
                  'Reject',
                  const Color(0xffF26C6C),
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void doDispose() {}
}
