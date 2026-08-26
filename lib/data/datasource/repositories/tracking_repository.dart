import '../../../core/network/api_service.dart';
import '../../models/tracking_model.dart';

class TrackingRepository {
  final ApiService apiService;

  TrackingRepository(this.apiService);

  Future<TrackingModel> getTracking(
      String orderId,
      ) async {

    final response = await apiService.getTracking(orderId);

    return response;
  }
}