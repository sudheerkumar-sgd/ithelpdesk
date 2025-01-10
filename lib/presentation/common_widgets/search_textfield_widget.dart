import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';

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
  final ValueNotifier<List<dynamic>> _searchResults = ValueNotifier([]);
  final ValueNotifier<String> _searchValue = ValueNotifier('');
  final TextEditingController textEditingController = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    textEditingController.addListener(
      () async {
        // printLog('textEditingController.text: ${textEditingController.text}');
        // _searchString.value = textEditingController.text;
        if (textEditingController.text.length > 2) {
          final response = await _servicesBloc.getTticketsBySearch(
              requestParams: {'searchString': textEditingController.text});
          _searchResults.value = response;
          _searchResults.notifyListeners();
        }
      },
    );
    return ValueListenableBuilder(
        valueListenable: _searchValue,
        builder: (context, value, child) {
          //final items = value.map((item) => item as TicketEntity).toList();
          // return DropdownSearchWidget<TicketEntity>(
          //   textController: textEditingController,
          //   list: items,
          //   hintText: resources.string.searchHere,
          //   fillColor: resources.color.appScaffoldBg,
          //   borderSide: BorderSide.none,
          //   prefixIconPath: DrawableAssets.icSearch,
          //   borderRadius: 20,
          //   callback: (value) {
          //     onSearchItemSelected?.call(value);
          //   },
          // );

          return TypeAheadField<TicketEntity>(
            suggestionsCallback: (search) => _servicesBloc
                .getTticketsBySearch(requestParams: {'searchString': value}),
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                onChanged: (value) {
                  if (value.length > 3) {
                    _searchValue.value = value;
                  } else if (value.isEmpty) {
                    _searchValue.value = '';
                  }
                },
                decoration: InputDecoration(
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
                  prefixIcon: Icon(
                    Icons.search,
                    color: resources.color.viewBgColor,
                  ),
                  hintText: resources.string.searchHere,
                  hintStyle: context.textFontWeight500
                      .onFontFamily(fontFamily: fontFamilyEN),
                ),
              );
            },
            itemBuilder: (context, ticket) {
              return ListTile(
                title: Text(
                    '${ticket.id?.toString() ?? ''} - ${ticket.subject ?? ''}'),
              );
            },
            emptyBuilder: (context) => const SizedBox(),
            onSelected: (ticket) {
              onSearchItemSelected?.call(ticket);
            },
          );
        });
  }
}
