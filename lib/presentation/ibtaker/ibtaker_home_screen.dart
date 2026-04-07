// ignore_for_file: must_be_immutable
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/ibtaker_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/iso/iso_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dynamic_report_list_widget.dart';
import 'package:ithelpdesk/presentation/ibtaker/ibtaker_details_screen.dart';

class IbtakerHomeScreen extends BaseScreenWidget {
  IbtakerHomeScreen({super.key});

  final ISOBloc _isoBloc = sl<ISOBloc>();
  final ValueNotifier<bool> _onDataChange = ValueNotifier(false);
  final TextEditingController _searchController = TextEditingController();
  int _pageNumber = 1;
  final int _pageSize = 20;
  String _search = '';

  Future<ApiEntity<IbtakerListDataEntity>> _loadIdeas() async {
    final requestParams = <String, dynamic>{
      'pageNumber': _pageNumber,
      'pageSize': _pageSize,
      'search': _search,
    };
    final response =
        await _isoBloc.getMyAndTeamIbtakerIdeas(requestParams: requestParams);
    final data = ApiEntity<IbtakerListDataEntity>();
    if (response is OnISOApiResponse) {
      data.entity = cast<IbtakerListDataEntity>(response.response.entity);
    }
    return Future.value(data);
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return SelectionArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.resources.color.appScaffoldBg,
      body: BlocProvider(
        create: (context) => _isoBloc,
        child: BlocListener<ISOBloc, ISOApiState>(
          listener: (context, state) {},
          child: Padding(
            padding: EdgeInsets.all(resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                        text: 'Ibtaker\n',
                        style: context.textFontWeight600,
                        children: [
                          TextSpan(
                              text: isSelectedLocalEn
                                  ? 'My and team improvement ideas'
                                  : 'أفكار التحسين لي وللفريق',
                              style: context.textFontWeight400
                                  .onFontSize(resources.fontSize.dp12)
                                  .onColor(resources.color.textColorLight)
                                  .onHeight(1))
                        ]),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  TextFormField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      _search = value.trim();
                      _pageNumber = 1;
                      _onDataChange.value = !_onDataChange.value;
                    },
                    decoration: InputDecoration(
                      hintText: isSelectedLocalEn
                          ? 'Search ideas'
                          : 'ابحث في الأفكار',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: InkWell(
                        onTap: () {
                          _searchController.clear();
                          _search = '';
                          _pageNumber = 1;
                          _onDataChange.value = !_onDataChange.value;
                        },
                        child: const Icon(Icons.clear),
                      ),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: resources.dimen.dp20),
                  ValueListenableBuilder(
                      valueListenable: _onDataChange,
                      builder: (context, _, __) {
                        return FutureBuilder(
                            future: _loadIdeas(),
                            builder: (context, snapShot) {
                              final ideas = snapShot.data?.entity?.ideas ?? [];
                              if (ideas.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    isSelectedLocalEn
                                        ? 'No ideas found'
                                        : 'لا توجد أفكار',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp16),
                                  ),
                                );
                              }
                              final reportHeaderData =
                                  ideas.first.toJson().keys.toList();
                              final reportTableColunwidths =
                                  <int, FlexColumnWidth>{};
                              reportHeaderData.asMap().forEach((index, value) {
                                reportTableColunwidths[index] =
                                    const FlexColumnWidth(4);
                              });
                              return DynamicReportListWidget(
                                reportData: ideas,
                                ticketsTableColunwidths: reportTableColunwidths,
                                page: snapShot.data?.entity?.pageNumber ?? 1,
                                totalPagecount:
                                    snapShot.data?.entity?.totalPages ?? 1,
                                ticketsHeaderData: reportHeaderData,
                                onRowSelected: (item) {
                                  if (item is IbtakerIdeaEntity) {
                                    IbtakerDetailsScreen.start(context, item);
                                  }
                                },
                                onColumnClick: (key, item) {},
                                onPageChange: (page) {
                                  _pageNumber = page;
                                  _onDataChange.value = !_onDataChange.value;
                                },
                              );
                            });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  void doDispose() {}
}
