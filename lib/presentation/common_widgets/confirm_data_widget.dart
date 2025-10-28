import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';

class ConfirmDataWidget extends StatelessWidget {
  final Map data;
  final String? title;
  final String? cancelbtn;
  final String? confirmbtn;

  const ConfirmDataWidget(this.data,
      {this.title, this.cancelbtn, this.confirmbtn, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Container(
      color: resources.color.colorWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title ?? '',
            style:
                context.textFontWeight600.onColor(resources.color.viewBgColor),
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Table(
            children: [
              for (var item in data.entries) ...[
                TableRow(children: [
                  Text(item.key, style: context.textFontWeight400),
                  Text(': ${item.value ?? ''}',
                      style: context.textFontWeight600),
                ])
              ]
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: ActionButtonWidget(
                  text: cancelbtn ?? resources.string.cancel,
                  color: resources.color.colorGray9E9E9E,
                  textStyle: context.textFontWeight500
                      .onFontSize(resources.fontSize.dp10),
                  padding: EdgeInsets.symmetric(
                      vertical: resources.dimen.dp5,
                      horizontal: resources.dimen.dp20),
                ),
              ),
              SizedBox(
                width: resources.dimen.dp10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, "confirm");
                },
                child: ActionButtonWidget(
                    text: confirmbtn ?? resources.string.approve,
                    color: resources.color.colorGreen26B757,
                    textStyle: context.textFontWeight500
                        .onFontSize(resources.fontSize.dp10),
                    padding: EdgeInsets.symmetric(
                        vertical: resources.dimen.dp5,
                        horizontal: resources.dimen.dp20)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
