import 'package:intl/intl.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/domain/entities/iso_entity.dart';

enum DynamicReportColumnAction { filter, sort }

enum DynamicReportFilterType { requestStatus, currentStep }

class DynamicReportHeaderEntity {
  final String label;
  final String? labelAr;
  final String? fieldKey;
  final DynamicReportColumnAction? action;
  final DynamicReportFilterType? filterType;

  const DynamicReportHeaderEntity({
    required this.label,
    this.labelAr,
    this.fieldKey,
    this.action,
    this.filterType,
  });

  bool get hasFilter => action == DynamicReportColumnAction.filter;
  bool get hasSort => action == DynamicReportColumnAction.sort;

  String get resolvedFieldKey => fieldKey ?? label;

  @override
  String toString() => (isSelectedLocalEn ? label : labelAr ?? label);
}

DynamicReportHeaderEntity buildReportHeader(String label, {String? fieldKey}) {
  switch (label) {
    case 'Request Status':
      return DynamicReportHeaderEntity(
        label: label,
        fieldKey: 'requestStatus',
        action: DynamicReportColumnAction.filter,
        filterType: DynamicReportFilterType.requestStatus,
      );
    case 'Current Step':
      return DynamicReportHeaderEntity(
        label: label,
        fieldKey: 'currentStep',
        action: DynamicReportColumnAction.filter,
        filterType: DynamicReportFilterType.currentStep,
      );
    case 'Created On':
      return DynamicReportHeaderEntity(
        label: label,
        fieldKey: 'createdAt',
        action: DynamicReportColumnAction.sort,
      );
    case 'Updated On':
      return DynamicReportHeaderEntity(
        label: label,
        fieldKey: 'updatedAt',
        action: DynamicReportColumnAction.sort,
      );
    default:
      return DynamicReportHeaderEntity(
        label: label,
        fieldKey: fieldKey,
      );
  }
}

List<DynamicReportHeaderEntity> buildReportHeadersFromKeys(
  List<String> labels, {
  List<Map<String, dynamic>>? reportFields,
}) {
  final keyByLabel = <String, String>{};
  for (final field in reportFields ?? []) {
    final name = field['Name']?.toString();
    final key = field['key']?.toString();
    if (name != null && key != null) {
      keyByLabel[name] = key;
    }
  }
  return labels
      .map((label) => buildReportHeader(label, fieldKey: keyByLabel[label]))
      .toList();
}

dynamic getReportFieldValue(dynamic row, DynamicReportHeaderEntity header) {
  final fieldKey = header.resolvedFieldKey;
  if (row is CRRequestEntity) {
    switch (fieldKey) {
      case 'requestStatus':
        return row.requestStatus;
      case 'currentStep':
        return row.currentStepName ?? row.currentStep;
      case 'createdAt':
        return row.createdAt;
      case 'updatedAt':
        return row.updatedAt;
      default:
        break;
    }
  }
  final rowJson = row.toJson() as Map<String, dynamic>;
  return rowJson[fieldKey] ?? rowJson[header.label];
}

int parseReportDateMicros(dynamic value) {
  final date = value?.toString() ?? '';
  if (date.isEmpty) {
    return 0;
  }
  const formats = [
    'dd-MMM-yyyy HH:mm',
    'dd/MM/yyyy HH:mm',
    'dd/MM/yyyy',
    'yyyy-MM-dd HH:mm:ss',
    'yyyy-MM-dd',
    'dd-MMM-yyyy',
  ];
  for (final format in formats) {
    try {
      return DateFormat(format).parse(date).microsecondsSinceEpoch;
    } catch (_) {}
  }
  return 0;
}

List<dynamic> sortReportData(
  List<dynamic> data,
  DynamicReportHeaderEntity header, {
  required bool ascending,
}) {
  final sorted = List<dynamic>.from(data);
  sorted.sort((a, b) {
    final aValue = getReportFieldValue(a, header);
    final bValue = getReportFieldValue(b, header);
    final compare =
        parseReportDateMicros(aValue).compareTo(parseReportDateMicros(bValue));
    return ascending ? compare : -compare;
  });
  return sorted;
}
