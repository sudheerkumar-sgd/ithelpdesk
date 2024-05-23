import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  dynamic toEntity();
  @override
  List<Object?> get props => [];
}
