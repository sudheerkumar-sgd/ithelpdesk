import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/domain/entities/dashboard_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/entities/user_credentials_entity.dart';
import 'package:ithelpdesk/domain/entities/user_entity.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/dropdown_widget.dart';

import '../../../injection_container.dart';

class TicketTransferWidget extends StatefulWidget {
  final TicketEntity ticketEntity;
  const TicketTransferWidget({required this.ticketEntity, super.key});

  @override
  State<TicketTransferWidget> createState() => _TicketTransferWidgetState();
}

class _TicketTransferWidgetState extends State<TicketTransferWidget> {
  final ValueNotifier<bool> _isNextLevelSelected = ValueNotifier(false);
  final ValueNotifier<bool> _isForwordToEmployee = ValueNotifier(false);
  final ValueNotifier<bool> _isForwordToCategory = ValueNotifier(false);
  final ValueNotifier<int> _forwordTocategory = ValueNotifier(-1);
  int _selectedEmployee = 0;
  CategoryEnum? _selectedCategory;
  SubCategoryEntity? _selectedSubCategory;
  UserEntity? _selectedCategoryEmployee;
  bool _showCategoryValidation = false;
  final _masterDataBloc = sl<MasterDataBloc>();

  Widget _radioOption(
    BuildContext context, {
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final resources = context.resources;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected
                  ? resources.color.sideBarItemSelected
                  : resources.color.sideBarItemUnselected,
            ),
            SizedBox(width: resources.dimen.dp8),
            Expanded(
              child: Text(
                title,
                style: context.textFontWeight400
                    .onFontSize(resources.fontSize.dp12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isNextLevelSelected.dispose();
    _isForwordToEmployee.dispose();
    _isForwordToCategory.dispose();
    _forwordTocategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final isSgdIT = UserCredentialsEntity.details().userType == UserType.sgdIT;
    return BlocProvider(
      create: (context) => _masterDataBloc,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resources.string.forwardTo,
            style: context.textFontWeight600,
          ),
          SizedBox(
            height: resources.dimen.dp10,
          ),
          if (isSgdIT)
            ValueListenableBuilder(
                valueListenable: _forwordTocategory,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      Flexible(
                        child: _radioOption(
                          context,
                          title: resources.string.system,
                          selected: value == 16,
                          onTap: () {
                            _forwordTocategory.value = 16;
                            _isNextLevelSelected.value = false;
                            _isForwordToEmployee.value = false;
                            _isForwordToCategory.value = false;
                            _showCategoryValidation = false;
                          },
                        ),
                      ),
                      Flexible(
                        child: _radioOption(
                          context,
                          title: 'Network',
                          selected: value == 14,
                          onTap: () {
                            _forwordTocategory.value = 14;
                            _isNextLevelSelected.value = false;
                            _isForwordToEmployee.value = false;
                            _isForwordToCategory.value = false;
                            _showCategoryValidation = false;
                          },
                        ),
                      ),
                      Flexible(
                        child: _radioOption(
                          context,
                          title: 'Category',
                          selected: value == 0,
                          onTap: () {
                            _forwordTocategory.value = 0;
                            _isNextLevelSelected.value = false;
                            _isForwordToCategory.value = true;
                            _isForwordToEmployee.value = false;
                            _selectedCategory = null;
                            _selectedSubCategory = null;
                            _selectedCategoryEmployee = null;
                            _showCategoryValidation = false;
                            if (mounted) setState(() {});
                          },
                        ),
                      ),
                    ],
                  );
                }),
          ValueListenableBuilder(
              valueListenable: _isForwordToCategory,
              builder: (context, isCategorySelected, _) {
                return ValueListenableBuilder(
                    valueListenable: _isForwordToEmployee,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          if (!(isSgdIT && isCategorySelected))
                            Row(
                              children: [
                                if (widget.ticketEntity.isMaxLevel == false)
                                  Flexible(
                                    child: ValueListenableBuilder(
                                        valueListenable: _isNextLevelSelected,
                                        builder: (context, isNextLevel, child) {
                                          return _radioOption(
                                            context,
                                            title: 'Next Level',
                                            selected: isNextLevel,
                                            onTap: () {
                                              _isNextLevelSelected.value = true;
                                              _isForwordToEmployee.value =
                                                  false;
                                              _isForwordToCategory.value =
                                                  false;
                                              _forwordTocategory.value = -1;
                                            },
                                          );
                                        }),
                                  ),
                                Flexible(
                                  child: _radioOption(
                                    context,
                                    title: 'Employee',
                                    selected: _isForwordToEmployee.value,
                                    onTap: () {
                                      _isNextLevelSelected.value = false;
                                      _isForwordToEmployee.value = true;
                                      _isForwordToCategory.value = false;
                                      _forwordTocategory.value = -1;
                                    },
                                  ),
                                ),
                                if (!isSgdIT)
                                  Flexible(
                                    child: ValueListenableBuilder(
                                        valueListenable: _isForwordToCategory,
                                        builder: (context, onCategory, child) {
                                          return _radioOption(
                                            context,
                                            title: 'Category',
                                            selected: onCategory,
                                            onTap: () {
                                              _isNextLevelSelected.value =
                                                  false;
                                              _forwordTocategory.value = -1;
                                              _isForwordToCategory.value = true;
                                              _isForwordToEmployee.value =
                                                  false;
                                              _selectedCategory = null;
                                              _selectedSubCategory = null;
                                              _selectedCategoryEmployee = null;
                                              if (mounted) setState(() {});
                                            },
                                          );
                                        }),
                                  ),
                              ],
                            ),
                          if (isCategorySelected)
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: resources.dimen.dp10),
                                  child: DropDownWidget<CategoryEnum>(
                                    isEnabled: true,
                                    list: CategoryEnum.values,
                                    selectedValue: _selectedCategory,
                                    labelText: resources.string.category,
                                    hintText:
                                        '${resources.string.pleaseSelect} ${resources.string.category}',
                                    fillColor: resources.color.colorWhite,
                                    borderRadius: 0,
                                    callback: (value) {
                                      _selectedCategory = value as CategoryEnum;
                                      _selectedSubCategory = null;
                                      _selectedCategoryEmployee = null;
                                      if (mounted) setState(() {});
                                    },
                                  ),
                                ),
                                if (_showCategoryValidation &&
                                    _selectedCategory == null)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: resources.dimen.dp5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${resources.string.pleaseSelect} ${resources.string.category}',
                                        style: context.textFontWeight400
                                            .onFontSize(resources.fontSize.dp10)
                                            .onColor(resources.color.rejected),
                                      ),
                                    ),
                                  ),
                                if (_selectedCategory != null)
                                  FutureBuilder(
                                      future: _masterDataBloc
                                          .getSubCategories(requestParams: {
                                        'categoryID': _selectedCategory?.value,
                                      }),
                                      builder: (context, snapShot) {
                                        final subCategories =
                                            (snapShot.data?.items ?? [])
                                                .whereType<SubCategoryEntity>()
                                                .toList();
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: resources.dimen.dp10),
                                          child:
                                              DropDownWidget<SubCategoryEntity>(
                                            isEnabled: true,
                                            list: subCategories,
                                            selectedValue: _selectedSubCategory,
                                            labelText:
                                                resources.string.subCategory,
                                            hintText:
                                                '${resources.string.pleaseSelect} ${resources.string.subCategory}',
                                            fillColor:
                                                resources.color.colorWhite,
                                            borderRadius: 0,
                                            callback: (value) {
                                              _selectedSubCategory =
                                                  value as SubCategoryEntity;
                                              _selectedCategoryEmployee = null;
                                              if (mounted) setState(() {});
                                            },
                                          ),
                                        );
                                      }),
                                if (_showCategoryValidation &&
                                    _selectedCategory != null &&
                                    _selectedSubCategory == null)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: resources.dimen.dp5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${resources.string.pleaseSelect} ${resources.string.subCategory}',
                                        style: context.textFontWeight400
                                            .onFontSize(resources.fontSize.dp10)
                                            .onColor(resources.color.rejected),
                                      ),
                                    ),
                                  ),
                                if (_selectedCategory != null &&
                                    _selectedSubCategory != null)
                                  FutureBuilder(
                                      future: _masterDataBloc
                                          .getAssignedEmployees(requestParams: {
                                        'categoryID': _selectedCategory?.value,
                                        'subcategoryID':
                                            _selectedSubCategory?.id,
                                      }),
                                      builder: (context, snapShot) {
                                        final employees =
                                            (snapShot.data?.items ?? [])
                                                .whereType<UserEntity>()
                                                .toList();
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: resources.dimen.dp10),
                                          child: DropDownWidget<UserEntity>(
                                            isEnabled: true,
                                            list: employees,
                                            selectedValue:
                                                _selectedCategoryEmployee,
                                            labelText:
                                                resources.string.employee,
                                            hintText: resources
                                                .string.selectEmployeeName,
                                            fillColor:
                                                resources.color.colorWhite,
                                            borderRadius: 0,
                                            callback: (value) {
                                              _selectedCategoryEmployee =
                                                  value as UserEntity;
                                            },
                                          ),
                                        );
                                      }),
                              ],
                            ),
                          if (value && !(isSgdIT && isCategorySelected))
                            FutureBuilder(
                                future: _masterDataBloc
                                    .getAssignedEmployees(requestParams: {
                                  'departmentID':
                                      widget.ticketEntity.categoryID == 3
                                          ? UserCredentialsEntity.details()
                                              .departmentID
                                          : null,
                                  'subcategoryID':
                                      (widget.ticketEntity.categoryID == 3 ||
                                              widget.ticketEntity.assigneType ==
                                                  AssigneType.implementer)
                                          ? widget.ticketEntity.subCategoryID
                                          : null,
                                  'categoryID': widget.ticketEntity.categoryID,
                                }),
                                builder: (context, snapShot) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: resources.dimen.dp10),
                                    child: DropDownWidget(
                                      isEnabled: true,
                                      list: snapShot.data?.items ?? [],
                                      labelText: resources.string.employee,
                                      hintText:
                                          resources.string.selectEmployeeName,
                                      fillColor: resources.color.colorWhite,
                                      borderRadius: 0,
                                      callback: (value) {
                                        _selectedEmployee =
                                            (value as UserEntity).id ?? 0;
                                      },
                                    ),
                                  );
                                }),
                        ],
                      );
                    });
              }),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: ActionButtonWidget(
                  text: resources.string.clear,
                  color: resources.color.sideBarItemUnselected,
                  textStyle: context.textFontWeight400,
                  textColor: resources.color.textColor,
                  radious: resources.dimen.dp15,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp20,
                      vertical: context.resources.dimen.dp7),
                  textSize: resources.fontSize.dp12,
                ),
              ),
              SizedBox(
                width: resources.dimen.dp20,
              ),
              InkWell(
                onTap: () {
                  if (_isForwordToCategory.value &&
                      (_selectedCategory == null ||
                          _selectedSubCategory == null)) {
                    setState(() {
                      _showCategoryValidation = true;
                    });
                    return;
                  }
                  Navigator.pop(context, {
                    'isForwordToEmployee': _isForwordToEmployee.value,
                    'isForwordToCategory': _isForwordToCategory.value,
                    'employee': _selectedEmployee,
                    'forwordCategory': _forwordTocategory.value,
                    'categoryID': _selectedCategory?.value ?? 0,
                    'subCategoryID': _selectedSubCategory?.id ?? 0,
                    'assignedTo': _selectedCategoryEmployee?.id,
                  });
                },
                child: ActionButtonWidget(
                  text: resources.string.submit,
                  radious: resources.dimen.dp15,
                  textStyle: context.textFontWeight400,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp20,
                      vertical: context.resources.dimen.dp7),
                  textSize: resources.fontSize.dp12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
