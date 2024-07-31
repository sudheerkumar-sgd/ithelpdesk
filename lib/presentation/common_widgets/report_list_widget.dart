import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/requests/view_request.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:ithelpdesk/res/drawables/drawable_assets.dart';

class ReportListWidget extends StatelessWidget {
  final List<String> ticketsHeaderData;
  final List<dynamic> ticketsData;
  final Map<int, FlexColumnWidth>? ticketsTableColunwidths;
  final bool showActionButtons;
  final Function(TicketEntity)? onTicketSelected;
  const ReportListWidget(
      {required this.ticketsHeaderData,
      required this.ticketsData,
      this.ticketsTableColunwidths,
      this.showActionButtons = false,
      this.onTicketSelected,
      super.key});
  List<Widget> _getTicketData(BuildContext context, dynamic ticketEntity) {
    final list = List<Widget>.empty(growable: true);
    (isDesktop(context)
            ? ticketEntity.toJson(showActionButtons: showActionButtons)
            : ticketEntity.toMobileJson(showActionButtons: showActionButtons))
        .forEach((key, value) {
      if (key != 'showActionButtons' || (key == 'showActionButtons' && value)) {
        list.add(InkWell(
          onTap: () {
            onTicketSelected?.call(ticketEntity);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp20,
                horizontal: context.resources.dimen.dp5),
            child: (key == 'showActionButtons' && value)
                ? Row(children: [
                    SizedBox(
                      width: context.resources.dimen.dp5,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          ViewRequest.start(context, ticketEntity);
                        },
                        child:
                            ImageWidget(path: DrawableAssets.icView, width: 24)
                                .loadImage,
                      ),
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child:
                          ImageWidget(path: DrawableAssets.icMessage, width: 24)
                              .loadImage,
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {},
                      child:
                          ImageWidget(path: DrawableAssets.icDelete, width: 24)
                              .loadImage,
                    ))
                  ])
                : Text(
                    '$value',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (key.toString().toLowerCase().contains('date') ||
                            key.toString().toLowerCase().contains('id'))
                        ? context.textFontWeight600
                            .onFontSize(context.resources.fontSize.dp10)
                            .onFontFamily(fontFamily: fontFamilyEN)
                        : context.textFontWeight600
                            .onFontSize(context.resources.fontSize.dp10),
                  ),
          ),
        ));
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return Table(
      columnWidths: ticketsTableColunwidths,
      children: [
        TableRow(
            children: List.generate(
                ticketsHeaderData.length,
                (index) => Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: resources.dimen.dp10),
                      child: Text(
                        ticketsHeaderData[index],
                        textAlign: TextAlign.center,
                        style: context.textFontWeight600
                            .onColor(resources.color.textColorLight)
                            .onFontSize(resources.fontSize.dp10),
                      ),
                    ))),
        for (var i = 0; i < ticketsData.length; i++) ...[
          TableRow(
              decoration: BackgroundBoxDecoration(
                      boxColor: resources.color.colorWhite,
                      boxBorder: Border(
                          top: BorderSide(
                              color: resources.color.appScaffoldBg, width: 5),
                          bottom: BorderSide(
                              color: resources.color.appScaffoldBg, width: 5)))
                  .roundedCornerBox,
              children: _getTicketData(context, ticketsData[i])),
        ]
      ],
    );
  }
}
