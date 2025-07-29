part of 'master_data_bloc.dart';

abstract class MasterDataState extends Equatable {}

class Init extends MasterDataState {
  @override
  List<Object?> get props => [];
}

class OnMasterDataLoading extends MasterDataState {
  @override
  List<Object?> get props => [];
}

class OnDataSuccess extends ServicesState {
  final ApiEntity<ListEntity> listEntity;

  OnDataSuccess({required this.listEntity});
  @override
  List<Object?> get props => [listEntity];
}

class OnMasterDataSuccess extends MasterDataState {
  final ApiEntity<BaseEntity> responseEntity;

  OnMasterDataSuccess({required this.responseEntity});
  @override
  List<Object?> get props => [responseEntity];
}

class OnMasterDataApiError extends MasterDataState {
  final String message;

  OnMasterDataApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
