import 'package:flutter/material.dart';
import 'base_page_widget.dart';

class PageWidgetProvider extends BasePageWidget {
  final Widget pageWidget;
  const PageWidgetProvider(this.pageWidget, {super.key});

  @override
  Widget getContentWidget() {
    return pageWidget;
  }
}
