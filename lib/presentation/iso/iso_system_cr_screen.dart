import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/common/common_utils.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/constants/data_constants.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/field_entity_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/data/model/master_data_models.dart';
import 'package:ithelpdesk/data/remote/api_urls.dart';
import 'package:ithelpdesk/domain/entities/form_entities.dart';
import 'package:ithelpdesk/domain/entities/single_data_entity.dart';
import 'package:ithelpdesk/injection_container.dart';
import 'package:ithelpdesk/presentation/bloc/iso/iso_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/action_button_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/base_screen_widget.dart';
import 'package:ithelpdesk/presentation/utils/dialogs.dart';
import 'package:ithelpdesk/res/drawables/background_box_decoration.dart';
import 'package:page_transition/page_transition.dart';

class IsoSystemCrScreen extends BaseScreenWidget {
  static Future<dynamic> start(BuildContext context) {
    return Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft, child: IsoSystemCrScreen()),
    );
  }

  IsoSystemCrScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final Map fieldsData = {};
  final newEmpFormFields = List<FormEntity>.empty(growable: true);
  final migrationFormFields = List<FormEntity>.empty(growable: true);
  final existingFormFields = List<FormEntity>.empty(growable: true);
  final systemCRFormFields = List<FormEntity>.empty(growable: true);
  final networkCRFormFields = List<FormEntity>.empty(growable: true);
  final dabaseFormFields = List<FormEntity>.empty(growable: true);
  final ValueNotifier<bool> doScreenRefresh = ValueNotifier(false);

  List<FormEntity> _getNewEmpFormFields(BuildContext context) {
    final resources = context.resources;
    if (newEmpFormFields.isEmpty) {
      newEmpFormFields.addAll([
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'الرجاء تحديد الأولوية')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['priority'] = value.name;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'firstname'
          ..labelEn = 'Employee First Name'
          ..labelAr = 'الاسم الأول للموظف'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee First Name'
            ..requiredAr = 'الرجاء إدخال الاسم الأول للموظف'
            ..regexEn = 'Please Enter Valid Employee First Name'
            ..regexAr = 'الرجاء إدخال الاسم الأول الصحيح للموظف')
          ..onDatachnage = (value) {
            fieldsData['firstname'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'lastname'
          ..labelEn = 'Employee Last Name'
          ..labelAr = 'الاسم الأخير للموظف'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Last Name'
            ..requiredAr = 'الرجاء إدخال اسم العائلة للموظف'
            ..regexEn = 'Please Enter Valid Employee Last Name'
            ..regexAr = 'الرجاء إدخال اسم العائلة الصحيح للموظف')
          ..onDatachnage = (value) {
            fieldsData['lastname'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..label = resources.string.fullName
          ..name = 'fullname'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameRegExp)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Full Name'
            ..requiredAr = 'الرجاء إدخال الاسم الكامل للموظف'
            ..regexEn = 'Please Enter Valid Employee Full Name'
            ..regexAr = 'الرجاء إدخال الاسم الكامل الصحيح للموظف')
          ..onDatachnage = (value) {
            fieldsData['fullname'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'designation'
          ..label = resources.string.designation
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter designation'
            ..requiredAr = 'الرجاء إدخال التعيين')
          ..inputFieldData = {'items': designations}
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
            ..requiredAr = 'من فضلك ادخل القسم')
          ..onDatachnage = (value) {
            fieldsData['department'] = value;

            final field = newEmpFormFields
                .where((e) => e.name == 'reportingmanager')
                .first;
            field.fieldValue = null;
            field.inputFieldData = null;
            field.url =
                '$getManagersByDptApiUrl?departmentName=${value.shortName}';
            doScreenRefresh.value = !doScreenRefresh.value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'reportingmanager'
          ..labelEn = 'Reporting Manager'
          ..labelAr = 'مدير التقارير'
          ..requestModel = ListModel.fromEmployeesJson
          ..validation = (FormValidationEntity()..required = false)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Reporting Manager'
            ..requiredAr = 'الرجاء إدخال مدير التقارير')
          ..onDatachnage = (value) {
            fieldsData['reportingmanager'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'employeeid'
          ..labelEn = 'Employee ID'
          ..labelAr = 'معرف الموظف'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee ID'
            ..requiredAr = 'الرجاء إدخال معرف الموظف'
            ..regexEn = 'Please Enter Valid Employee ID'
            ..regexAr = 'الرجاء إدخال معرف الموظف الصحيح')
          ..onDatachnage = (value) {
            fieldsData['employeeid'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'emailID'
          ..labelEn = 'Suggestive Email ID'
          ..labelAr = 'معرف البريد الإلكتروني المقترح'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = emailRegx)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Email ID'
            ..requiredAr = 'الرجاء إدخال معرف البريد الإلكتروني'
            ..regexEn = 'Please Enter Valid Email ID'
            ..regexAr = 'Please Enter Valid Email ID')
          ..onDatachnage = (value) {
            fieldsData['emailid'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..name = 'dateofjoining'
          ..labelEn = 'Date of Joining'
          ..labelAr = 'تاريخ الإنضمام'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Date of Joining'
            ..requiredAr = 'الرجاء إدخال تاريخ الانضمام')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['dateofjoining'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..name = 'comments'
          ..label = resources.string.comments
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
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'الرجاء تحديد الأولوية')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['priority'] = value.name;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'firstname'
          ..labelEn = 'Employee First Name'
          ..labelAr = 'الاسم الأول للموظف'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee First Name'
            ..requiredAr = 'الرجاء إدخال الاسم الأول للموظف'
            ..regexEn = 'Please Enter Valid Employee First Name'
            ..regexAr = 'الرجاء إدخال الاسم الأول الصحيح للموظف')
          ..onDatachnage = (value) {
            fieldsData['firstname'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'lastname'
          ..labelEn = 'Employee Last Name'
          ..labelAr = 'الاسم الأخير للموظف'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Last Name'
            ..requiredAr = 'الرجاء إدخال اسم العائلة للموظف'
            ..regexEn = 'Please Enter Valid Employee Last Name'
            ..regexAr = 'الرجاء إدخال اسم العائلة الصحيح للموظف')
          ..onDatachnage = (value) {
            fieldsData['lastname'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..label = resources.string.fullName
          ..name = 'fullname'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameRegExp)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Full Name'
            ..requiredAr = 'الرجاء إدخال الاسم الكامل للموظف'
            ..regexEn = 'Please Enter Valid Employee Full Name'
            ..regexAr = 'الرجاء إدخال الاسم الكامل الصحيح للموظف')
          ..onDatachnage = (value) {
            fieldsData['fullname'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'designation'
          ..label = resources.string.designation
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter designation'
            ..requiredAr = 'الرجاء إدخال التعيين')
          ..inputFieldData = {'items': designations}
          ..onDatachnage = (value) {
            fieldsData['designation'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'existingdepartment'
          ..labelEn = 'Existing Department'
          ..labelAr = 'القسم الحالي'
          ..url = departmentsApiUrl
          ..requestModel = ListModel.fromDepartmentsJson
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Existing department'
            ..requiredAr = 'الرجاء تحديد القسم الحالي')
          ..onDatachnage = (value) {
            fieldsData['existingdepartment'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'newdepartment'
          ..labelEn = 'New Department'
          ..labelAr = 'قسم جديد'
          ..url = departmentsApiUrl
          ..requestModel = ListModel.fromDepartmentsJson
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select New department'
            ..requiredAr = 'الرجاء اختيار قسم جديد')
          ..onDatachnage = (value) {
            fieldsData['newdepartment'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'employeeid'
          ..labelEn = 'Employee ID'
          ..labelAr = 'معرف الموظف'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee ID'
            ..requiredAr = 'الرجاء إدخال معرف الموظف'
            ..regexEn = 'Please Enter Valid Employee ID'
            ..regexAr = 'الرجاء إدخال معرف الموظف الصحيح')
          ..onDatachnage = (value) {
            fieldsData['employeeid'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..label = resources.string.comments
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
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'الرجاء تحديد الأولوية')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['priority'] = value.name;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..label = resources.string.fullName
          ..name = 'fullname'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameRegExp)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Employee Full Name'
            ..requiredAr = 'الرجاء إدخال الاسم الكامل للموظف'
            ..regexEn = 'Please Enter Valid Employee Full Name'
            ..regexAr = 'الرجاء إدخال الاسم الكامل الصحيح للموظف')
          ..onDatachnage = (value) {
            fieldsData['fullname'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'systemloginid'
          ..labelEn = 'System Login ID'
          ..labelAr = 'معرف تسجيل الدخول للنظام'
          ..validation = (FormValidationEntity()
            ..required = true
            ..regex = nameNumberRegex)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter System Login ID'
            ..requiredAr = 'الرجاء إدخال معرف تسجيل الدخول للنظام'
            ..regexEn = 'Please Enter Valid System Login ID'
            ..regexAr = 'الرجاء إدخال معرف تسجيل الدخول للنظام صالحًا')
          ..onDatachnage = (value) {
            fieldsData['systemloginid'] = value;
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
            ..requiredAr = 'الرجاء اختيار القسم')
          ..onDatachnage = (value) {
            fieldsData['department'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'accessdetails'
          ..labelEn = 'Access Details'
          ..labelAr = 'تفاصيل الوصول'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Access Details'
            ..requiredAr = 'الرجاء تحديد تفاصيل الوصول')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Email Access'),
              NameIDEntity(2, 'Internet Access'),
              NameIDEntity(3, 'Software Access'),
              NameIDEntity(4, 'Database Access'),
              NameIDEntity(5, 'Shared Folder Access'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['accessdetails'] = value.name;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'reasonofaccess'
          ..labelEn = 'Reason of Access'
          ..labelAr = 'سبب الوصول'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Reason of Access'
            ..requiredAr = 'الرجاء إدخال سبب الوصول')
          ..onDatachnage = (value) {
            fieldsData['reasonofaccess'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..label = resources.string.comments
          ..onDatachnage = (value) {
            fieldsData['comments'] = value;
          },
      ]);
    }
    return existingFormFields;
  }

  List<FormEntity> _getSystemCRFormFields(BuildContext context) {
    final resources = context.resources;
    if (systemCRFormFields.isEmpty) {
      systemCRFormFields.addAll([
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'الرجاء تحديد الأولوية')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, resources.string.low),
              NameIDEntity(2, resources.string.medium),
              NameIDEntity(3, resources.string.high),
              NameIDEntity(4, resources.string.critical)
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['priority'] = value.name;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..labelEn = 'Change Description'
          ..labelAr = 'تغيير الوصف'
          ..name = 'changeDescription'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Change Description'
            ..requiredAr = 'الرجاء إدخال وصف التغيير')
          ..onDatachnage = (value) {
            fieldsData['changedescription'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'operatingSystem'
          ..labelEn = 'Operating System'
          ..labelAr = 'نظام التشغيل'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Operating System'
            ..requiredAr = 'الرجاء تحديد نظام التشغيل')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Windows'),
              NameIDEntity(2, 'Linx'),
              NameIDEntity(3, 'Mac'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['operatingSystem'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'applicationVersion'
          ..labelEn = 'Application Version'
          ..labelAr = 'نسخة التطبيق'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Application Version'
            ..requiredAr = 'الرجاء إدخال إصدار التطبيق')
          ..onDatachnage = (value) {
            fieldsData['applicationversion'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'changetested'
          ..labelEn = 'Change Tested'
          ..labelAr = 'تم اختبار التغيير'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Change Tested'
            ..requiredAr = 'الرجاء تحديد التغيير الذي تم اختباره')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Yes'),
              NameIDEntity(2, 'No'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['changetested'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'rolebackoption'
          ..labelEn = 'Role-back option'
          ..labelAr = 'خيار إرجاع الدور'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Role-back option'
            ..requiredAr = 'الرجاء تحديد خيار العودة للدور')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Yes'),
              NameIDEntity(2, 'No'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['rolebackoption'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'impact'
          ..labelEn = 'Impact'
          ..labelAr = 'تأثير'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Impact'
            ..requiredAr = 'الرجاء تحديد التأثير')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'High'),
              NameIDEntity(2, 'Medium'),
              NameIDEntity(3, 'Low'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['impact'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'downtimerequirement'
          ..labelEn = 'Down time Requirement'
          ..labelAr = 'متطلبات وقت التوقف'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Down time Requirement'
            ..requiredAr = 'الرجاء إدخال متطلبات وقت التوقف')
          ..onDatachnage = (value) {
            fieldsData['downtimerequirement'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..name = 'businessimpactanalysis'
          ..labelEn = 'Business Impact Analysis'
          ..labelAr = 'تحليل تأثير الأعمال'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Business Impact Analysis'
            ..requiredAr = 'الرجاء إدخال تحليل تأثير الأعمال')
          ..onDatachnage = (value) {
            fieldsData['businessimpactanalysis'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'systeminvolved'
          ..labelEn = 'System Involved'
          ..labelAr = 'النظام متورط'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter System Involved'
            ..requiredAr = 'الرجاء إدخال النظام المعني')
          ..onDatachnage = (value) {
            fieldsData['systeminvolved'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..hasTime = true
          ..name = 'startDateAndTime'
          ..labelEn = 'Requester Target Start Date and Time'
          ..labelAr = 'تاريخ ووقت البدء المستهدف للمتقدم بالطلب'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Requester Target Start Date and Time'
            ..requiredAr = 'الرجاء إدخال تاريخ ووقت البدء المستهدف للمتقدم')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['startdateandtime'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'downtimewindow'
          ..labelEn = 'Down Time Window'
          ..labelAr = 'نافذة وقت التوقف'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Down Time Window'
            ..requiredAr = 'الرجاء إدخال نافذة وقت التوقف')
          ..onDatachnage = (value) {
            fieldsData['downtimewindow'] = value;
          },
      ]);
    }
    return systemCRFormFields;
  }

  List<FormEntity> _getNetworkCRFormFields(BuildContext context) {
    final resources = context.resources;
    if (networkCRFormFields.isEmpty) {
      networkCRFormFields.addAll([
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'الرجاء تحديد الأولوية')
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
          ..type = FormFieldType.text
          ..labelEn = 'Change Description'
          ..labelAr = 'تغيير الوصف'
          ..name = 'changeDescription'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Change Description'
            ..requiredAr = 'الرجاء إدخال وصف التغيير')
          ..onDatachnage = (value) {
            fieldsData['changedescription'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..labelEn = 'Network Devices'
          ..labelAr = 'أجهزة الشبكة'
          ..name = 'networkdevices'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Network Devices'
            ..requiredAr = 'الرجاء إدخال أجهزة الشبكة')
          ..onDatachnage = (value) {
            fieldsData['networkdevices'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'changetested'
          ..labelEn = 'Change Tested'
          ..labelAr = 'تم اختبار التغيير'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Change Tested'
            ..requiredAr = 'الرجاء تحديد التغيير الذي تم اختباره')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Yes'),
              NameIDEntity(2, 'No'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['changetested'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'rolebackoption'
          ..labelEn = 'Role-back option'
          ..labelAr = 'خيار إرجاع الدور'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Role-back option'
            ..requiredAr = 'الرجاء تحديد خيار العودة للدور')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Yes'),
              NameIDEntity(2, 'No'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['rolebackoption'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'impact'
          ..labelEn = 'Impact'
          ..labelAr = 'تأثير'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Impact'
            ..requiredAr = 'الرجاء تحديد التأثير')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'High'),
              NameIDEntity(2, 'Medium'),
              NameIDEntity(3, 'Low'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['impact'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..name = 'businessimpactanalysis'
          ..labelEn = 'Business Impact Analysis'
          ..labelAr = 'تحليل تأثير الأعمال'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Business Impact Analysis'
            ..requiredAr = 'الرجاء إدخال تحليل تأثير الأعمال')
          ..onDatachnage = (value) {
            fieldsData['businessimpactanalysis'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'downtimerequirement'
          ..labelEn = 'Down time Requirement'
          ..labelAr = 'متطلبات وقت التوقف'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Down time Requirement'
            ..requiredAr = 'الرجاء إدخال متطلبات وقت التوقف')
          ..onDatachnage = (value) {
            fieldsData['downtimerequirement'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..name = 'requestertargetinstalldate'
          ..labelEn = 'Requester Target Install Date'
          ..labelAr = 'تاريخ ووقت البدء المستهدف للمتقدم بالطلب'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Requester Target Install Date'
            ..requiredAr = 'الرجاء إدخال تاريخ التثبيت المستهدف للمتقدم')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['requestertargetinstalldate'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'systeminvolved'
          ..labelEn = 'System Involved'
          ..labelAr = 'النظام متورط'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter System Involved'
            ..requiredAr = 'الرجاء إدخال النظام المعني')
          ..onDatachnage = (value) {
            fieldsData['systeminvolved'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..hasTime = true
          ..name = 'startDateAndTime'
          ..labelEn = 'Requester Start Date'
          ..labelAr = 'تاريخ بدء مقدم الطلب'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Requester Start Date'
            ..requiredAr = 'الرجاء إدخال تاريخ بدء مقدم الطلب')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['startdateandtime'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..hasTime = true
          ..name = 'endDateAndTime'
          ..labelEn = 'Requester End Date'
          ..labelAr = 'تاريخ انتهاء الطالب'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Requester End Date'
            ..requiredAr = 'الرجاء إدخال تاريخ انتهاء الطلب')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['enddateandtime'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..label = 'Comments'
          ..onDatachnage = (value) {
            fieldsData['comments'] = value;
          },
      ]);
    }
    return networkCRFormFields;
  }

  List<FormEntity> _getDatabaseFormFields(BuildContext context) {
    final resources = context.resources;
    if (dabaseFormFields.isEmpty) {
      dabaseFormFields.addAll([
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'priority'
          ..label = resources.string.priority
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select priority'
            ..requiredAr = 'الرجاء تحديد الأولوية')
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
          ..type = FormFieldType.text
          ..labelEn = 'Change Description'
          ..labelAr = 'تغيير الوصف'
          ..name = 'changeDescription'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Change Description'
            ..requiredAr = 'الرجاء إدخال وصف التغيير')
          ..onDatachnage = (value) {
            fieldsData['changedescription'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'environment'
          ..labelEn = 'Environment'
          ..labelAr = 'بيئة'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Environment'
            ..requiredAr = 'الرجاء تحديد البيئة')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Windows'),
              NameIDEntity(2, 'Linx'),
              NameIDEntity(3, 'Mac'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['environment'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'operatingSystem'
          ..labelEn = 'Operating System'
          ..labelAr = 'نظام التشغيل'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Operating System'
            ..requiredAr = 'الرجاء تحديد نظام التشغيل')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Windows'),
              NameIDEntity(2, 'Linx'),
              NameIDEntity(3, 'Mac'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['operatingsystem'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..labelEn = 'Database Server'
          ..labelAr = 'خادم قاعدة البيانات'
          ..name = 'databaseserver'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Database Server'
            ..requiredAr = 'الرجاء إدخال خادم قاعدة البيانات')
          ..onDatachnage = (value) {
            fieldsData['databaseserver'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'databaseversion'
          ..labelEn = 'Database Version'
          ..labelAr = 'نسخة قاعدة البيانات'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Database Version'
            ..requiredAr = 'الرجاء إدخال إصدار قاعدة البيانات')
          ..onDatachnage = (value) {
            fieldsData['databaseversion'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..labelEn = 'Application Server'
          ..labelAr = 'خادم التطبيقات'
          ..name = 'applicationserver'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Application Server'
            ..requiredAr = 'الرجاء إدخال خادم التطبيق')
          ..onDatachnage = (value) {
            fieldsData['applicationserver'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'applicationversion'
          ..labelEn = 'Application Version'
          ..labelAr = 'نسخة التطبيق'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Application Version'
            ..requiredAr = 'الرجاء إدخال إصدار التطبيق')
          ..onDatachnage = (value) {
            fieldsData['applicationversion'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'changetype'
          ..labelEn = 'Change Type'
          ..labelAr = 'تغيير النوع'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Change Type'
            ..requiredAr = 'الرجاء تحديد نوع التغيير')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Yes'),
              NameIDEntity(2, 'No'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['changetype'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..labelEn = 'Duration'
          ..labelAr = 'مدة'
          ..name = 'duration'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Duration'
            ..requiredAr = 'الرجاء إدخال المدة')
          ..onDatachnage = (value) {
            fieldsData['duration'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..name = 'startdate'
          ..labelEn = 'Start Date'
          ..labelAr = 'تاريخ البدء'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Start Date'
            ..requiredAr = 'الرجاء إدخال تاريخ البدء')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['startdate'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..name = 'enddate'
          ..labelEn = 'End Date'
          ..labelAr = 'تاريخ الانتهاء'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter End Date'
            ..requiredAr = 'الرجاء إدخال تاريخ الانتهاء')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['enddate'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'changetested'
          ..labelEn = 'Change Tested'
          ..labelAr = 'تم اختبار التغيير'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Change Tested'
            ..requiredAr = 'الرجاء تحديد التغيير الذي تم اختباره')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Yes'),
              NameIDEntity(2, 'No'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['changetested'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'rolebackoption'
          ..labelEn = 'Role-back option'
          ..labelAr = 'خيار إرجاع الدور'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Role-back option'
            ..requiredAr = 'الرجاء تحديد خيار العودة للدور')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'Yes'),
              NameIDEntity(2, 'No'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['rolebackoption'] = value;
          },
        FormEntity()
          ..type = FormFieldType.collection
          ..name = 'impact'
          ..labelEn = 'Impact'
          ..labelAr = 'تأثير'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Select Impact'
            ..requiredAr = 'الرجاء تحديد التأثير')
          ..inputFieldData = {
            'items': [
              NameIDEntity(1, 'High'),
              NameIDEntity(2, 'Medium'),
              NameIDEntity(3, 'Low'),
            ]
          }
          ..onDatachnage = (value) {
            fieldsData['impact'] = value;
          },
        FormEntity()
          ..type = FormFieldType.text
          ..name = 'downtimerequirement'
          ..labelEn = 'Down time Requirement'
          ..labelAr = 'متطلبات وقت التوقف'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Down time Requirement'
            ..requiredAr = 'الرجاء إدخال متطلبات وقت التوقف')
          ..onDatachnage = (value) {
            fieldsData['downtimerequirement'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..name = 'businessimpactanalysis'
          ..labelEn = 'Business Impact Analysis'
          ..labelAr = 'تحليل تأثير الأعمال'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Business Impact Analysis'
            ..requiredAr = 'الرجاء إدخال تحليل تأثير الأعمال')
          ..onDatachnage = (value) {
            fieldsData['businessimpactanalysis'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..name = 'requestertargetinstalldate'
          ..labelEn = 'Requester Target Install Date'
          ..labelAr = 'تاريخ ووقت البدء المستهدف للمتقدم بالطلب'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Requester Target Install Date'
            ..requiredAr = 'الرجاء إدخال تاريخ التثبيت المستهدف للمتقدم')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['requestertargetinstalldate'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..timeOnly = true
          ..name = 'starttime'
          ..labelEn = 'Requester Start Time'
          ..labelAr = 'وقت بدء الطالب'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Requester Start time'
            ..requiredAr = 'الرجاء إدخال وقت بدء مقدم الطلب')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['starttime'] = value;
          },
        FormEntity()
          ..type = FormFieldType.date
          ..timeOnly = true
          ..name = 'endtime'
          ..labelEn = 'Requester End Time'
          ..labelAr = 'وقت انتهاء الطالب'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Requester End time'
            ..requiredAr = 'الرجاء إدخال وقت انتهاء الطلب')
          ..inputFieldData = {
            'format': 'yyyy-MM-dd',
            'lastDate': DateTime.now().add(const Duration(days: 365))
          }
          ..onDatachnage = (value) {
            fieldsData['endtime'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..name = 'actionplan'
          ..labelEn = 'Action Plan'
          ..labelAr = 'خطة العمل'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Action Plan'
            ..requiredAr = 'الرجاء إدخال خطة العمل')
          ..onDatachnage = (value) {
            fieldsData['actionplan'] = value;
          },
        FormEntity()
          ..type = FormFieldType.textarea
          ..name = 'rollbackplan'
          ..labelEn = 'Rollback Plan'
          ..labelAr = 'خطة التراجع'
          ..validation = (FormValidationEntity()..required = true)
          ..messages = (FormMessageEntity()
            ..requiredEn = 'Please Enter Rollback Plan'
            ..requiredAr = 'الرجاء إدخال خطة التراجع')
          ..onDatachnage = (value) {
            fieldsData['rollbackplan'] = value;
          },
      ]);
    }
    return dabaseFormFields;
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    int employeeCategory = 0;
    final categories = [
      NameIDEntity(1, 'New Employee', nameAr: 'موظف جديد'),
      NameIDEntity(2, 'Migration Employee', nameAr: 'موظف الهجرة'),
      NameIDEntity(3, 'Existing Employee', nameAr: 'الموظف الحالي'),
      NameIDEntity(4, 'System CR', nameAr: 'نظام CR'),
      NameIDEntity(5, 'Network CR', nameAr: 'شبكة CR'),
      NameIDEntity(6, 'Database and Applications',
          nameAr: 'قاعدة البيانات والتطبيقات'),
    ];
    var noOfCategoryRows = 2;
    var noOfCategoryRowItems = 4; //categories.length;
    final currrentFieds = [
      _getNewEmpFormFields(context),
      _getMigrationEmpFormFields(context),
      _getExistingEmpFormFields(context),
      _getSystemCRFormFields(context),
      _getNetworkCRFormFields(context),
      _getDatabaseFormFields(context),
    ];
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
                    valueListenable: doScreenRefresh,
                    builder: (context, doRefresh, child) {
                      return Column(
                        children: [
                          for (int c = 0; c < noOfCategoryRows; c++) ...{
                            Row(
                              children: [
                                for (int r = 0;
                                    r < noOfCategoryRowItems;
                                    r++) ...[
                                  if (r + (c * noOfCategoryRowItems) <
                                      categories.length)
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          employeeCategory =
                                              r + (c * noOfCategoryRowItems);
                                          doScreenRefresh.value =
                                              !doScreenRefresh.value;
                                        },
                                        child: ActionButtonWidget(
                                          text: categories[r +
                                                  (c * noOfCategoryRowItems)]
                                              .toString(),
                                          decoration: employeeCategory !=
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
                                          textColor: employeeCategory !=
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
                  valueListenable: doScreenRefresh,
                  builder: (context, redresh, child) {
                    final currentFields = currrentFieds[employeeCategory];
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                      ..onDatachnage = (value) {
                        fieldsData['files'] = value;
                      })
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
                      if (_formKey.currentState?.validate() == true) {
                        // final request = RequestDetail();
                        // request.workflowId = categories[employeeCategory].id;
                        // request.firstName = fieldsData['firstname'] ?? '';
                        // request.lastName = fieldsData['lastname'] ?? '';
                        // request.fullName = fieldsData['fullname'] ?? '';
                        // request.designation = fieldsData['designation'];
                        // request.departmentID =
                        //     (fieldsData['department'] as DepartmentEntity?)?.id;
                        // request.reportingManagerID =
                        //     (fieldsData['reportingmanager'] as UserEntity?)?.id;
                        // request.employeeID = fieldsData['employeeid'] ?? '';
                        // request.emailID = fieldsData['emailid'] ?? '';
                        // request.dateOfJoining = DateTime.tryParse(
                        //     fieldsData['dateofjoining'] ?? '');
                        // request.requestPriority =
                        //     (fieldsData['priority'] as NameIDEntity?)?.id ?? 1;
                        // request.comments = fieldsData['comments'] ?? '';

                        // request.loginID = fieldsData['systemloginid'] ?? '';
                        // request.reasonOfAccess =
                        //     fieldsData['reasonofaccess'] ?? '';
                        // request.existingDepartmentID =
                        //     (fieldsData['existingdepartment']
                        //             as DepartmentEntity?)
                        //         ?.id;
                        // request.accessTypeID =
                        //     (fieldsData['accessdetails'] as NameIDEntity?)
                        //         ?.name;
                        final data = <String, dynamic>{};
                        data['workflowId'] = categories[employeeCategory].id;
                        //data['requestDetails'] = jsonEncode(data);
                        final details = <String, dynamic>{};
                        for (var field in fieldsData.entries) {
                          if (!field.key.contains('files')) {
                            details[field.key] = field.value;
                          }
                        }
                        details['createdon'] =
                            getDateByformat('dd/MM/yyyy', DateTime.now());
                        data['requestDetails'] = jsonEncode(details);
                        if (fieldsData['files'] is List) {
                          data['files'] =
                              (fieldsData['files'] as List).map((file) {
                            return MultipartFile.fromBytes(file['fileBytes'],
                                filename: file['fileName']);
                          }).toList();
                        }
                        Dialogs.loader(context);
                        final response = await sl<ISOBloc>().createISORequest(
                            apiUrl: isoSubmitApiUrl, requestParams: data);
                        if (!context.mounted) {
                          return;
                        }

                        Dialogs.dismiss(context);
                        if (response is OnISOApiResponse) {
                          Dialogs.showInfoDialog(context, PopupType.success,
                                  resources.string.successfullySubmitted)
                              .then((value) {
                            if (context.mounted) {
                              Navigator.pop(context, true);
                            }
                          });
                        } else if (response is OnISOApiError) {
                          Dialogs.showInfoDialog(
                              context, PopupType.fail, response.message);
                        }
                      }
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
