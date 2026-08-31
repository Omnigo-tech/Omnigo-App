import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/network/api_service.dart';
import '../../models/profile_response_model.dart';
import '../../models/update_profile_picture_response_model.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  Future<ProfileResponseModel> getMyProfile(String userId) async {
    try {
      return await _apiService.getMyProfile(userId);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<UpdateProfilePictureResponseModel> updateProfilePicture(
    String userId,
    String profilePicture,
  ) async {
    try {
      final body = {"profilePicture": profilePicture};

      return await _apiService.updateProfilePicture(userId, body);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
