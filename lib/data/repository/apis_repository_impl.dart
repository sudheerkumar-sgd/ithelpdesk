import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ithelpdesk/core/common/file_utils.dart';
import 'package:ithelpdesk/core/error/failures.dart';
import 'package:ithelpdesk/core/network/network_info.dart';
import 'package:ithelpdesk/data/model/api_response_model.dart';
import 'package:ithelpdesk/data/model/base_model.dart';
import 'package:ithelpdesk/data/remote/remote_data_source.dart';
import 'package:ithelpdesk/domain/repository/apis_repository.dart';

class ApisRepositoryImpl extends ApisRepository {
  final RemoteDataSource dataSource;
  final NetworkInfo networkInfo;
  ApisRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ApiResponse>> get<T extends BaseModel>(
      {required String apiUrl,
      required Map<String, dynamic> requestParams,
      Function(Map<String, dynamic>)? responseModel,
      String? cachePath}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.get(
          apiUrl: apiUrl,
          requestParams: requestParams,
        );
        if (cachePath != null) {
          FileUtiles.writeFiletoCache(cachePath, jsonEncode(apiResponse));
        }
        var apiResponseModel =
            ApiResponse<T>.fromJson(apiResponse, responseModel);
        return Right(apiResponseModel);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> post<T extends BaseModel>({
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
  }) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.post(
          apiUrl: apiUrl,
          requestParams: requestParams,
        );
        var apiResponseModel =
            ApiResponse<T>.fromJson(apiResponse, responseModel);
        return Right(apiResponseModel);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiResponse>>
      getWithCustomBaseUrl<T extends BaseModel>(
          {required String baseUrl,
          required String apiUrl,
          required Map<String, dynamic> requestParams,
          Function(Map<String, dynamic>)? responseModel,
          String? cachePath}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.getWithCustomBaseUrl(
          baseUrl: baseUrl,
          apiUrl: apiUrl,
          requestParams: requestParams,
        );
        if (cachePath != null) {
          FileUtiles.writeFiletoCache(cachePath, jsonEncode(apiResponse));
        }
        var apiResponseModel =
            ApiResponse<T>.fromJson(apiResponse, responseModel);
        return Right(apiResponseModel);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiResponse>>
      postWithCustomBaseUrl<T extends BaseModel>({
    required String baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
    bool postAsArray = false,
  }) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.postWithCustomBaseUrl(
            baseUrl: baseUrl,
            apiUrl: apiUrl,
            requestParams: requestParams,
            postAsArray: postAsArray);
        var apiResponseModel =
            ApiResponse<T>.fromJson(apiResponse, responseModel);
        return Right(apiResponseModel);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiResponse>>
      postWithMultipartData<T extends BaseModel>({
    String? baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    Function(Map<String, dynamic>)? responseModel,
    bool postAsArray = false,
  }) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.postWithMultipartData(
            baseUrl: baseUrl,
            apiUrl: apiUrl,
            requestParams: requestParams,
            postAsArray: postAsArray);
        var apiResponseModel =
            ApiResponse<T>.fromJson(apiResponse, responseModel);
        return Right(apiResponseModel);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, dynamic>> postWithStringContent(
      {required String baseUrl,
      required String apiUrl,
      required String content,
      String? contentTypeHeader}) async {
    var isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        final apiResponse = await dataSource.postWithStringContent(
          baseUrl: baseUrl,
          apiUrl: apiUrl,
          content: content,
        );
        return Right(apiResponse);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      } catch (error) {
        return Left(Exception(error.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApiResponse<BaseModel>>>
      getFromCache<T extends BaseModel>(
          {required String filePath,
          Function(Map<String, dynamic> p1)? responseModel}) async {
    try {
      final apiResponse = await FileUtiles.readFileFromCache(filePath);
      var apiResponseModel = ApiResponse<T>.fromJson(
          jsonDecode(apiResponse.isNotEmpty ? apiResponse : '{}'),
          responseModel);
      return Right(apiResponseModel);
    } catch (error) {
      var apiResponseModel =
          ApiResponse<T>.fromJson(jsonDecode('{}'), responseModel);
      return Right(apiResponseModel);
    }
  }
}
