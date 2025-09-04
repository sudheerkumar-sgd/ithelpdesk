import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/field_entity_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/model/master_data_models.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/form_entities.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';

class IsoSystemCrScreen extends BaseScreenWidget {
  IsoSystemCrScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final Map fieldsData = {};
  final newEmpFormFields = List<FormEntity>.empty(growable: true);
  final migrationFormFields = List<FormEntity>.empty(growable: true);
  final existingFormFields = List<FormEntity>.empty(growable: true);

  List<FormEntity> _getNewEmpFormFields(BuildContext context) {
    final resources = context.resources;
    if (newEmpFormFields.isEmpty) {
      newEmpFormFields.addAll([
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'firstName'
          ..label = 'Employee First Name'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee First Name'
            ..requiredAr = 'Please Enter Employee First Name'
            ..regexEn = 'Please Enter Valid Employee First Name'
            ..regexAr = 'Please Enter Valid Employee First Name')
          ..onDatachnage = (value) {
            fieldsData['firstName'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'lastName'
          ..label = 'Employee Last Name'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Last Name'
            ..requiredAr = 'Please Enter Employee Last Name'
            ..regexEn = 'Please Enter Valid Employee Last Name'
            ..regexAr = 'Please Enter Valid Employee Last Name')
          ..onDatachnage = (value) {
            fieldsData['lastName'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..label = resources.string.fullName
          ..name = 'fullName'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Full Name'
            ..requiredAr = 'Please Enter Employee Full Name'
            ..regexEn = 'Please Enter Valid Employee Full Name'
            ..regexAr = 'Please Enter Valid Employee Full Name')
          ..onDatachnage = (value) {
            fieldsData['fullName'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'designation'
          ..label = resources.string.designation
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter designation'
            ..requiredAr = 'Please Enter designation')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['designation'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'department'
          ..label = resources.string.department
          ..url = departmentsApiUrl
          ..requestModel = ListModel.fromDepartmentsJson
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter department'
            ..requiredAr = 'Please Enter department')
          ..onDatachnage = (value) {
            fieldsData['department'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'reportingManager'
          ..label = 'Reporting Manager'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Reporting Manager'
            ..requiredAr = 'Please Enter Reporting Manager')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['reportingManager'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'employeeID'
          ..label = 'Employee ID'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee ID'
            ..requiredAr = 'Please Enter ID'
            ..regexEn = 'Please Enter Valid ID'
            ..regexAr = 'Please Enter Valid ID')
          ..onDatachnage = (value) {
            fieldsData['employeeID'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'emailID'
          ..label = 'Suggestive Email ID'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = emailRegx)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Email ID'
            ..requiredAr = 'Please Enter Email ID'
            ..regexEn = 'Please Enter Valid Email ID'
            ..regexAr = 'Please Enter Valid Email ID')
          ..onDatachnage = (value) {
            fieldsData['emailID'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..name = 'dateofJoining'
          ..label = 'Date of Joining'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Date of Joining'
            ..requiredAr = 'Please Enter Date of Joining')
          ..onDatachnage = (value) {
            fieldsData['dateofJoining'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'Please Select priority')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['priority'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..name = 'comments'
          ..label = 'Comments'
          ..onDatachnage = (value) {
            fieldsData['comments'] = value;
          },
      ]);
    }
    return newEmpFormFields;
  }

  List<FormEntity> _getMigrationEmpFormFields(BuildContext context) {
    final resources = context.resources;
    if (migrationFormFields.isEmpty) {
      migrationFormFields.addAll([
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'firstName'
          ..label = 'Employee First Name'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee First Name'
            ..requiredAr = 'Please Enter Employee First Name'
            ..regexEn = 'Please Enter Valid Employee First Name'
            ..regexAr = 'Please Enter Valid Employee First Name')
          ..onDatachnage = (value) {
            fieldsData['firstName'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'lastName'
          ..label = 'Employee Last Name'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Last Name'
            ..requiredAr = 'Please Enter Employee Last Name'
            ..regexEn = 'Please Enter Valid Employee Last Name'
            ..regexAr = 'Please Enter Valid Employee Last Name')
          ..onDatachnage = (value) {
            fieldsData['lastName'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..label = resources.string.fullName
          ..name = 'fullName'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Full Name'
            ..requiredAr = 'Please Enter Employee Full Name'
            ..regexEn = 'Please Enter Valid Employee Full Name'
            ..regexAr = 'Please Enter Valid Employee Full Name')
          ..onDatachnage = (value) {
            fieldsData['fullName'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'designation'
          ..label = resources.string.designation
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select designation'
            ..requiredAr = 'Please Select designation')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['designation'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'existingdepartment'
          ..label = 'Existing ${resources.string.department}'
          ..url = departmentsApiUrl
          ..requestModel = ListModel.fromDepartmentsJson
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Existing department'
            ..requiredAr = 'Please Select Existing department')
          ..onDatachnage = (value) {
            fieldsData['existingdepartment'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'newdepartment'
          ..label = 'New ${resources.string.department}'
          ..url = departmentsApiUrl
          ..requestModel = ListModel.fromDepartmentsJson
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Existing department'
            ..requiredAr = 'Please Select Existing department')
          ..onDatachnage = (value) {
            fieldsData['existingdepartment'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'employeeID'
          ..label = 'Employee ID'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee ID'
            ..requiredAr = 'Please Enter ID'
            ..regexEn = 'Please Enter Valid ID'
            ..regexAr = 'Please Enter Valid ID')
          ..onDatachnage = (value) {
            fieldsData['employeeID'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'Please Select priority')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['priority'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..label = 'Comments'
          ..onDatachnage = (value) {
            fieldsData['comments'] = value;
          },
      ]);
    }
    return migrationFormFields;
  }

  List<FormEntity> _getExistingEmpFormFields(BuildContext context) {
    final resources = context.resources;
    if (existingFormFields.isEmpty) {
      existingFormFields.addAll([
        FormEntity()
          ..type = FormFieldType.text
          ..label = resources.string.fullName
          ..name = 'fullName'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Full Name'
            ..requiredAr = 'Please Enter Employee Full Name'
            ..regexEn = 'Please Enter Valid Employee Full Name'
            ..regexAr = 'Please Enter Valid Employee Full Name')
          ..onDatachnage = (value) {
            fieldsData['fullName'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'systemLoginID'
          ..label = 'System Login ID'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter System Login ID'
            ..requiredAr = 'Please Enter System Login ID'
            ..regexEn = 'Please Enter Valid System Login ID'
            ..regexAr = 'Please Enter Valid System Login ID')
          ..onDatachnage = (value) {
            fieldsData['systemLoginID'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'department'
          ..label = resources.string.department
          ..url = departmentsApiUrl
          ..requestModel = ListModel.fromDepartmentsJson
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select department'
            ..requiredAr = 'Please Select department')
          ..onDatachnage = (value) {
            fieldsData['department'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'accessDetails'
          ..label = 'Access Details'
          ..url = departmentsApiUrl
          ..requestModel = ListModel.fromDepartmentsJson
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Access Details'
            ..requiredAr = 'Please Select Access Details')
          ..onDatachnage = (value) {
            fieldsData['accessDetails'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'reasonofAccess'
          ..label = 'Reason of Access'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Reason of Access'
            ..requiredAr = 'Please Enter Reason of Access')
          ..onDatachnage = (value) {
            fieldsData['reasonofAccess'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'Please Select priority')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['priority'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..label = 'Comments'
          ..onDatachnage = (value) {
            fieldsData['comments'] = value;
          },
      ]);
    }
    return existingFormFields;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final ValueNotifier<int> employeeCategory = ValueNotifier(0);
    final categories = [
      'New Employee',
      'Migration Employee',
      'Existing Employee',
    ];
    var noOfCategoryRows = 1;
    var noOfCategoryRowItems = categories.length;
    return Container(
      color: resources.color.appScaffoldBg,
      padding: EdgeInsets.symmetric(
          horizontal: resources.dimen.dp15, vertical: resources.dimen.dp20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                    text: '${resources.string.createNewRequest}\n',
                    style: context.textFontWeight600,
                    children: [
                      TextSpan(
                          text: '${resources.string.createNewRequestDes}\n',
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10)
                              .onColor(resources.color.textColorLight)
                              .onHeight(1))
                    ]),
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Text.rich(
                TextSpan(
                    text: '${resources.string.step} 1',
                    style: context.textFontWeight600,
                    children: [
                      WidgetSpan(
                          child: SizedBox(
                        width: resources.dimen.dp10,
                      )),
                      TextSpan(
                          text: resources.string.step1Des,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10)
                              .onColor(resources.color.textColorLight)
                              .onHeight(1))
                    ]),
              ),
              SizedBox(
                height: resources.dimen.dp10,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: resources.dimen.dp15,
                    horizontal: resources.dimen.dp20),
                color: resources.color.colorWhite,
                child: ValueListenableBuilder(
                    valueListenable: employeeCategory,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          for (int c = 0; c < noOfCategoryRows; c++) ...{
                            Row(
                              children: [
                                for (int r = 0;
                                    r < noOfCategoryRowItems;
                                    r++) ...[
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        employeeCategory.value =
                                            r + (c * noOfCategoryRowItems);
                                      },
                                      child: ActionButtonWidget(
                                        text: categories[
                                            r + (c * noOfCategoryRowItems)],
                                        decoration: value !=
                                                r + (c * noOfCategoryRowItems)
                                            ? BackgroundBoxDecoration(
                                                    boxColor: resources
                                                        .color.colorWhite,
                                                    boarderColor: resources
                                                        .color.textColorLight,
                                                    boarderWidth:
                                                        resources.dimen.dp1,
                                                    radious: 0)
                                                .roundedCornerBox
                                            : null,
                                        textColor: value !=
                                                r + (c * noOfCategoryRowItems)
                                            ? resources.color.textColor
                                            : null,
                                        textSize: resources.dimen.dp12,
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                context.resources.dimen.dp10,
                                            vertical:
                                                context.resources.dimen.dp7),
                                        radious: 0,
                                      ),
                                    ),
                                  ),
                                  if (r < noOfCategoryRowItems - 1) ...[
                                    SizedBox(
                                      width: resources.dimen.dp20,
                                    )
                                  ]
                                ]
                              ],
                            ),
                            if (c < noOfCategoryRows - 1) ...[
                              SizedBox(
                                height: resources.dimen.dp20,
                              )
                            ]
                          },
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Text.rich(
                TextSpan(
                    text: '${resources.string.step} 2',
                    style: context.textFontWeight600,
                    children: [
                      WidgetSpan(
                          child: SizedBox(
                        width: resources.dimen.dp10,
                      )),
                      TextSpan(
                          text: resources.string.step2Des,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10)
                              .onColor(resources.color.textColorLight)
                              .onHeight(1))
                    ]),
              ),
              SizedBox(
                height: resources.dimen.dp10,
              ),
              ValueListenableBuilder(
                  valueListenable: employeeCategory,
                  builder: (context, category, child) {
                    final currentFields = category == 0
                        ? _getNewEmpFormFields(context)
                        : category == 1
                            ? _getMigrationEmpFormFields(context)
                            : _getExistingEmpFormFields(context);
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: resources.dimen.dp15,
                          horizontal: resources.dimen.dp20),
                      color: resources.color.colorWhite,
                      child: Column(
                        children: [
                          for (int row = 0;
                              row < currentFields.length / 2;
                              row++) ...[
                            Row(
                              children: [
                                for (int c = 0; c < 2; c++) ...{
                                  if (c + (row * 2) < currentFields.length) ...{
                                    if (c == 1) ...[
                                      SizedBox(
                                        width: resources.dimen.dp30,
                                      )
                                    ],
                                    Expanded(
                                        child: currentFields[c + (row * 2)]
                                            .getWidget(context)),
                                  }
                                }
                              ],
                            )
                          ]
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Text.rich(
                TextSpan(
                    text: '${resources.string.step} 3',
                    style: context.textFontWeight600,
                    children: [
                      WidgetSpan(
                          child: SizedBox(
                        width: resources.dimen.dp10,
                      )),
                      TextSpan(
                          text: resources.string.step3Des,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10)
                              .onColor(resources.color.textColorLight)
                              .onHeight(1))
                    ]),
              ),
              SizedBox(
                height: resources.dimen.dp10,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: resources.dimen.dp15,
                    horizontal: resources.dimen.dp20),
                color: resources.color.colorWhite,
                child: (FormEntity()
                      ..type = FormFieldType.multifile
                      ..label = resources.string.uploadFile
                      ..onDatachnage = (value) {})
                    .getWidget(context),
              ),
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
                      text: resources.string.cancel,
                      color: resources.color.colorWhite,
                      textColor: resources.color.textColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: context.resources.dimen.dp40,
                          vertical: context.resources.dimen.dp7),
                    ),
                  ),
                  SizedBox(
                    width: resources.dimen.dp20,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {}
                    },
                    child: ActionButtonWidget(
                      text: resources.string.submit,
                      padding: EdgeInsets.symmetric(
                          horizontal: context.resources.dimen.dp40,
                          vertical: context.resources.dimen.dp7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
