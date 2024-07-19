import 'package:equatable/equatable.dart';
import 'package:ithelpdesk/domain/entities/api_entity.dart';
import 'package:ithelpdesk/domain/entities/master_data_entities.dart';
import 'package:ithelpdesk/domain/usecase/master_data_usecase.dart';
import 'package:ithelpdesk/presentation/bloc/services/services_bloc.dart';
import '../../../core/error/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'master_data_state.dart';

class MasterDataBloc extends Cubit<MasterDataState> {
  final MasterDataUseCase masterDataUseCase;
  MasterDataBloc({required this.masterDataUseCase}) : super(Init());

  Future<ListEntity> getSubCategories(
      {required Map<String, dynamic> requestParams}) async {
    //emit(OnMasterDataLoading());
    final result =
        await masterDataUseCase.getSubCategories(requestParams: requestParams);
    return result.fold((l) => ListEntity(),
        (r) => OnDataSuccess(listEntity: r).listEntity.entity ?? ListEntity());
  }

  Future<ListEntity> getReasons(
      {required Map<String, dynamic> requestParams}) async {
    //emit(OnMasterDataLoading());
    final result =
        await masterDataUseCase.getReasons(requestParams: requestParams);
    return result.fold((l) => ListEntity(),
        (r) => OnDataSuccess(listEntity: r).listEntity.entity ?? ListEntity());
  }

  Future<ListEntity> getEservices(
      {required Map<String, dynamic> requestParams}) async {
    //emit(OnMasterDataLoading());
    final result =
        await masterDataUseCase.getEservices(requestParams: requestParams);
    return result.fold((l) => ListEntity(),
        (r) => OnDataSuccess(listEntity: r).listEntity.entity ?? ListEntity());
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
