import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:dartz/dartz.dart';

abstract class ApisRepository {
  Future<Either<Failure, ApiResponse>> get<T extends BaseModel>({
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
    String? cachePath,
  });
  Future<Either<Failure, ApiResponse>> post<T extends BaseModel>({
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
  });

  Future<Either<Failure, ApiResponse>>
      getWithCustomBaseUrl<T extends BaseModel>({
    required String baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
    String? cachePath,
  });
  Future<Either<Failure, ApiResponse>>
      postWithCustomBaseUrl<T extends BaseModel>({
    required String baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
    bool postAsArray = false,
  });
  Future<Either<Failure, dynamic>> postWithStringContent(
      {required String baseUrl,
      required String apiUrl,
      required String content,
      String? contentTypeHeader});
  Future<Either<Failure, ApiResponse>> getFromCache<T extends BaseModel>(
      {required String filePath,
      Function(Map<String, dynamic>)? responseModel});
}
