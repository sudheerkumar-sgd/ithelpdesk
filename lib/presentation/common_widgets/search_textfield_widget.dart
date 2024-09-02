import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

import '../../domain/entities/api_entity.dart';
import '../../domain/entities/master_data_entities.dart';
import '../../injection_container.dart';
import '../bloc/services/services_bloc.dart';

const double defaultHeight = 20;

// ignore: must_be_immutable
class SearchDropDownWidget extends StatelessWidget {
  final double height;
  final String? hintText;
  final String errorMessage;
  final TextInputType? textInputType;
  final TextEditingController? textController;
  final String? prefixIconPath;
  final bool isEnabled;
  Function(dynamic)? onSearchItemSelected;
  SearchDropDownWidget(
      {this.height = defaultHeight,
      this.hintText,
      this.errorMessage = '',
      this.textController,
      this.prefixIconPath,
      this.textInputType,
      this.isEnabled = true,
      this.onSearchItemSelected,
      super.key});

  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<String> _searchString = ValueNotifier('');
  Future<ApiEntity<ListEntity>> _getSearchTickets() {
    final tickets = ApiEntity<ListEntity>();
    final listEntity = ListEntity();
    tickets.entity = listEntity;
    return Future.value(tickets);
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final TextEditingController textEditingController = TextEditingController();
    textEditingController.addListener(
      () {
        _searchString.value = textEditingController.text;
      },
    );
    final focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) textEditingController.text = '';
    });
    return ValueListenableBuilder(
        valueListenable: _searchString,
        builder: (context, value, child) {
          return FutureBuilder(
              future: value.length < 2
                  ? _getSearchTickets()
                  : _servicesBloc.getTticketsBySearch(
                      requestParams: {'searchString': value}),
              builder: (context, snapShot) {
                final items = (snapShot.data?.entity?.items ?? []);
                return LayoutBuilder(builder: (context, constraints) {
                  return DropdownMenu(
                    width: constraints.maxWidth,
                    controller: textEditingController,
                    hintText: resources.string.searchHere,
                    requestFocusOnTap: true,
                    enableFilter: true,
                    focusNode: focusNode,
                    textStyle: context.textFontWeight500
                        .onFontFamily(fontFamily: fontFamilyEN),
                    inputDecorationTheme: InputDecorationTheme(
                      constraints: const BoxConstraints(maxHeight: 32),
                      isDense: true,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: context.resources.dimen.dp7,
                          horizontal: context.resources.dimen.dp10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(context.resources.dimen.dp20),
                        ),
                      ),
                    ),
                    leadingIcon: Icon(
                      Icons.search,
                      color: resources.color.viewBgColor,
                    ),
                    trailingIcon: const SizedBox(),
                    onSelected: (dynamic item) {
                      onSearchItemSelected?.call(item);
                    },
                    dropdownMenuEntries:
                        items.map<DropdownMenuEntry<dynamic>>((dynamic item) {
                      return DropdownMenuEntry<dynamic>(
                          value: item,
                          label: '${item.id} - ${item.subject}',
                          style: ButtonStyle(
                              textStyle: WidgetStateProperty.all(context
                                  .textFontWeight500
                                  .onFontFamily(fontFamily: fontFamilyEN))));
                    }).toList(),
                  );
                });
              });
        });
  }
}
