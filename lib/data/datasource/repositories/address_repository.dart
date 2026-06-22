import 'package:dio/dio.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/network/api_service.dart';
import '../../models/address_response_model.dart';

class AddressRepository {
  final ApiService _apiService;
  AddressRepository(this._apiService);

  Future<AddressResponseModel> getAddresses() async {
    try {
      return await _apiService.getAddresses();
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<AddressResponseModel> addAddress(Map<String, dynamic> body) async {
    try {
      return await _apiService.addAddress(body);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<AddressResponseModel> updateAddress(String id, Map<String, dynamic> body) async {
    try {
      return await _apiService.updateAddress(id, body);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<AddressResponseModel> deleteAddress(String id) async {
    try {
      return await _apiService.deleteAddress(id);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }


}