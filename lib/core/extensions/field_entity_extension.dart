import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/enum/enum.dart';
import 'package:ithelpdesk/data/model/master_data_models.dart';
import 'package:ithelpdesk/domain/entities/base_entity.dart';
import 'package:ithelpdesk/domain/entities/form_entities.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:ithelpdesk/presentation/common_widgets/multi_upload_attachment_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/radio_items_widget.dart';
import '../../core/common/common_utils.dart';
import '../../core/constants/constants.dart';
import '../../core/extensions/build_context_extension.dart';
import '../../core/extensions/text_style_extension.dart';
import '../../domain/entities/single_data_entity.dart';
import '../../injection_container.dart';
import '../../presentation/common_widgets/action_button_widget.dart';
import '../../presentation/common_widgets/dropdown_widget.dart';
import '../../presentation/common_widgets/multi_select_dropdown_widget.dart';
import '../../presentation/common_widgets/right_icon_text_widget.dart';
import '../../presentation/common_widgets/upload_attachment_widget.dart';
import '../../presentation/utils/date_time_util.dart';
import '../../presentation/utils/dialogs.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

extension FieldEntityExtension on FormEntity {
  Future<List<BaseEntity>?> _getAccountTypes() async {
    if (url == null && inputFieldData?['items'] == null) {
      return null;
    }
    if (inputFieldData?['items'] == null) {
      final response = await sl<MasterDataBloc>().getFieldInputData(
        apiUrl: url ?? '',
        requestParams: urlInputData ?? {},
        requestModel: requestModel ?? ListModel.fromDepartmentsJson,
      );
      if (response is OnMasterDataSuccess) {
        return Future<List<BaseEntity>>.value(
          ((response).responseEntity.entity as ListEntity)
              .items
              .map((item) => item)
              .toList(),
        );
      } else {
        return Future<List<NameIDEntity>>.value([]);
      }
    }
    return Future.value((inputFieldData?['items'] ?? []) as List<BaseEntity>);
  }

  Widget getWidget(BuildContext context) {
    final resources = context.resources;
    bool isVisible = !(isHidden ?? false);
    bool isMandetory = (isVisible && (validation?.isrequired ?? false));
    switch (type) {
      case FormFieldType.collection:
        return FutureBuilder<List<BaseEntity>?>(
          future: _getAccountTypes(),
          builder: (context, snapshot) {
            if (inputFieldData?['doSort'] ?? false) {
              (snapshot.data ?? []).sort(
                (a, b) => (a.toString()).compareTo(b.toString()),
              );
            }
            if (snapshot.data != null) {
              if (inputFieldData == null) {
                inputFieldData = {'items': snapshot.data};
              } else {
                inputFieldData['items'] ??= snapshot.data;
              }
            }
            return Visibility(
              visible: isVisible,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalSpace ?? 10.0,
                  horizontal: horizontalSpace ?? 0.0,
                ),
                child: multi == true
                    ? MultiSelectDropDownWidget<BaseEntity>(
                        list: snapshot.data ?? [],
                        labelText: getLabel,
                        errorMessage: isMandetory ? getLabel : '',
                        isMandetory: isMandetory,
                        hintText: getPlaceholder,
                        selectedItems: fieldValue ??
                            List<BaseEntity>.empty(growable: true),
                        callback: (value) async {
                          fieldValue = value;
                          onDatachnage?.call(value);
                        },
                      )
                    : DropDownWidget<BaseEntity>(
                        list: snapshot.data ?? [],
                        labelText: getLabel,
                        errorMessage: isMandetory ? getLabel : '',
                        isMandetory: isMandetory,
                        hintText: getPlaceholder,
                        selectedValue: fieldValue,
                        borderRadius: 0,
                        fillColor: resources.color.colorWhite,
                        callback: (value) async {
                          fieldValue = value;
                          onDatachnage?.call(value);
                        },
                      ),
              ),
            );
          },
        );
      case FormFieldType.text ||
            FormFieldType.number ||
            FormFieldType.phone ||
            FormFieldType.textarea ||
            FormFieldType.email:
        final textEditingController = TextEditingController();
        textEditingController.text = fieldValue ?? '';
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpace ?? 10.0,
              horizontal: horizontalSpace ?? 0.0,
            ),
            child: RightIconTextWidget(
              isEnabled: isEnabled ?? true,
              height: resources.dimen.dp27,
              textInputType:
                  (type == FormFieldType.number || type == FormFieldType.phone)
                      ? TextInputType.number
                      : null,
              textInputAction: TextInputAction.next,
              labelText: getLabel,
              hintText: getPlaceholder,
              maxLines: type == FormFieldType.textarea ? 4 : 1,
              errorMessage: isMandetory ? getLabel : '',
              isMandetory: isMandetory,
              regex: validation?.regex,
              maxLength: validation?.maxLength,
              textController: textEditingController,
              borderRadius: 0,
              borderSide: BorderSide(
                  color: context.resources.color.sideBarItemUnselected,
                  width: 1),
              fillColor: resources.color.colorWhite,
              isValid: (value) {
                if (value.isEmpty) {
                  return messages?.requiredMessage;
                } else if (!RegExp(validation?.regex ?? '').hasMatch(value)) {
                  return messages?.regexMessage;
                } else if (value.length > (validation?.maxLength ?? 2000)) {
                  return messages?.maxLengthMessage;
                } else if ((validation?.max is int) &&
                    (int.tryParse(value) ?? 0) > (validation?.max ?? 2000)) {
                  return messages?.maxMessage;
                } else if ((validation?.min is int) &&
                    (int.tryParse(value) ?? 0) < (validation?.min ?? 0)) {
                  return messages?.minMessage;
                }
                return null;
              },
              onChanged: (value) {
                fieldValue = value;
                onDatachnage?.call(value);
              },
            ),
          ),
        );
      case FormFieldType.checkbox:
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpace ?? 10.0,
              horizontal: horizontalSpace ?? 0.0,
            ),
            child: CheckboxListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(getLabel, style: context.textFontWeight400),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              controlAffinity: ListTileControlAffinity.leading,
              value: fieldValue ?? false,
              onChanged: (isChecked) {
                fieldValue = isChecked;
                onDatachnage?.call(isChecked);
              },
            ),
          ),
        );
      case FormFieldType.radio:
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpace ?? 10.0,
              horizontal: horizontalSpace ?? 0.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (getLabel.isNotEmpty) ...[
                  Text(
                    getLabel,
                    style: context.textFontWeight400.onFontSize(
                      context.resources.fontSize.dp14,
                    ),
                  ),
                  SizedBox(width: resources.dimen.dp20),
                ],
                RadioItemsWidget(
                  items: inputFieldData,
                  onItemSelected: (value) async {
                    onDatachnage?.call(value);
                  },
                  selectedItem: fieldValue,
                ),
              ],
            ),
          ),
        );
      case FormFieldType.radiovertical:
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpace ?? 10.0,
              horizontal: horizontalSpace ?? 0.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getLabel,
                  style: context.textFontWeight400.onFontSize(
                    context.resources.fontSize.dp14,
                  ),
                ),
                SizedBox(width: resources.dimen.dp20),
                RadioItemsWidget(
                  type: RadioItemsType.vertical,
                  items: inputFieldData,
                  onItemSelected: (value) async {
                    onDatachnage?.call(value);
                  },
                  selectedItem: fieldValue,
                ),
              ],
            ),
          ),
        );
      case FormFieldType.date || FormFieldType.dateFrom || FormFieldType.dateTo:
        final textEditingController = TextEditingController();
        textEditingController.text = fieldValue ?? '';
        final dateFormat = inputFieldData?['format'] ?? 'yyyy-MM-dd';
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpace ?? 10.0,
              horizontal: horizontalSpace ?? 0.0,
            ),
            child: InkWell(
              onTap: () {
                if (timeOnly == true) {
                  selectTime(
                    context,
                    callBack: (dateTime) {
                      textEditingController.text = getDateByformat(
                        "hh:mm a",
                        dateTime,
                      );
                      fieldValue = textEditingController.text;
                    },
                  );
                } else {
                  DateTime? firstDate;
                  selectDate(
                    context,
                    firstDate: firstDate,
                    initialDate: fieldValue != null
                        ? getDateTimeByString(
                            dateFormat,
                            fieldValue ?? '',
                          )
                        : firstDate,
                    lastDate: inputFieldData?['lastDate'],
                    callBack: (dateTime) {
                      if (hasTime == true) {
                        selectTime(context, callBack: (time) {
                          final combined = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              time.hour,
                              time.minute,
                              time.second);
                          textEditingController.text = getDateByformat(
                            hasTime == true
                                ? "$dateFormat HH:mm:ss"
                                : dateFormat,
                            combined,
                          );
                          fieldValue = textEditingController.text;
                          onDatachnage?.call(textEditingController.text);
                        });
                      } else {
                        textEditingController.text = getDateByformat(
                          dateFormat,
                          dateTime,
                        );
                        fieldValue = textEditingController.text;
                        onDatachnage?.call(textEditingController.text);
                      }
                    },
                  );
                }
              },
              child: RightIconTextWidget(
                isEnabled: false,
                isReadOnly: false,
                height: resources.dimen.dp27,
                textInputAction: TextInputAction.next,
                labelText: getLabel,
                hintText: getPlaceholder,
                maxLines: 1,
                errorMessage: (isMandetory) ? getLabel : '',
                isMandetory: isMandetory,
                regex: validation?.regex,
                textController: textEditingController,
                suffixIconPath: suffixIcon,
                disableColor: resources.color.colorWhite,
                borderRadius: 0,
                borderSide: BorderSide(
                    color: context.resources.color.sideBarItemUnselected,
                    width: 1),
                fillColor: resources.color.colorWhite,
                isValid: (value) {
                  if (value.isEmpty) {
                    return messages?.requiredMessage;
                  } else if (!RegExp(validation?.regex ?? '').hasMatch(value)) {
                    return messages?.regexMessage;
                  } else if (value.length > (validation?.maxLength ?? 200)) {
                    return messages?.maxLengthMessage;
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
            ),
          ),
        );
      case FormFieldType.file || FormFieldType.image:
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpace ?? 10.0,
              horizontal: horizontalSpace ?? 0.0,
            ),
            child: UploadAttachmentWidget(
              labelText: getLabel,
              hintText: getPlaceholder,
              errorMessage: isMandetory ? getLabel : '',
              isMandetory: isMandetory,
              allowedExtensions:
                  validation?.extensions?.replaceAll('.', '').split(', ') ?? [],
              maxSize: validation?.maxSize ?? 1,
              selectedFileData: inputFieldData,
              borderSide: BorderSide(
                  color: context.resources.color.sideBarItemUnselected,
                  width: 1),
              borderRadius: 0,
              onSelected: (uploadResponseEntity) async {
                if (uploadResponseEntity?.documentData != null) {
                  uploadResponseEntity?.documentData = uploadResponseEntity
                      .documentData
                      ?.replaceAll('data:image/png;base64,', '');
                  onDatachnage?.call(uploadResponseEntity);
                } else {
                  onDatachnage?.call(null);
                }
              },
            ),
          ),
        );
      case FormFieldType.multifile:
        return Visibility(
          visible: isVisible,
          child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalSpace ?? 10.0,
                horizontal: horizontalSpace ?? 0.0,
              ),
              child: MultiUploadAttachmentWidget(
                hintText: getPlaceholder,
                fillColor: resources.color.colorWhite,
                borderSide: BorderSide(
                    color: context.resources.color.sideBarItemUnselected,
                    width: 1),
                borderRadius: 0,
                onSelected: (p0) {
                  fieldValue = p0;
                  onDatachnage?.call(p0);
                },
              )),
        );
      case FormFieldType.labelheader:
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpace ?? 10.0,
              horizontal: horizontalSpace ?? 0.0,
            ),
            child: Text(
              getLabel,
              style: context.textFontWeight600.onColor(
                resources.color.viewBgColor,
              ),
            ),
          ),
        );
      case FormFieldType.label:
        return Visibility(
          visible: isVisible,
          child: Text(
            getLabel,
            style: context.textFontWeight500.onFontSize(
              resources.fontSize.dp12,
            ),
          ),
        );

      case FormFieldType.button:
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalSpace ?? 10.0,
            horizontal: horizontalSpace ?? 0.0,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () {},
              child: ActionButtonWidget(
                width: 110,
                text: getLabel,
                color: fieldValue != null
                    ? resources.color.viewBgColor
                    : resources.iconBgColor,
                padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp20,
                  vertical: context.resources.dimen.dp7,
                ),
              ),
            ),
          ),
        );
      case FormFieldType.termsconditions:
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpace ?? 10.0,
              horizontal: horizontalSpace ?? 0.0,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: fieldValue ?? false,
                  onChanged: (value) {
                    onDatachnage?.call(value);
                  },
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text:
                          isSelectedLocalEn ? 'I have read and agree the' : '',
                      children: [
                        TextSpan(
                          text: isSelectedLocalEn
                              ? 'Terms & Conditions'
                              : 'الشروط والأحكام',
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp12)
                              .onColor(resources.color.viewBgColor)
                              .copyWith(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Dialogs.showDialogWithClose(
                                context,
                                showClose: false,
                                const SizedBox(),
                              ).then((value) {
                                if (context.mounted) {}
                              });
                            },
                        ),
                        TextSpan(
                          text: isSelectedLocalEn
                              ? ' of this service'
                              : ' لهذه الخدمة',
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp12)
                              .onColor(resources.color.viewBgColor),
                        ),
                      ],
                    ),
                    style: context.textFontWeight400
                        .onColor(resources.color.viewBgColor)
                        .onFontSize(resources.fontSize.dp12),
                  ),
                ),
              ],
            ),
          ),
        );
      case FormFieldType.pdfviewer:
        {
          return Visibility(
            visible: isVisible,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalSpace ?? 10.0,
                horizontal: horizontalSpace ?? 0.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: inputFieldData['height'],
                child: SfPdfViewer.asset(inputFieldData['url']),
              ),
            ),
          );
        }
      default:
        return const SizedBox();
    }
  }
}
