abstract class TrackingEvent {}

class FetchTrackingDetails extends TrackingEvent {
  final String orderId;
  final String userId; // User ID zaroor pass karein room join karne ke liye
  FetchTrackingDetails({required this.orderId, required this.userId});
}

class UpdateLiveStatus extends TrackingEvent {
  final String status;
  UpdateLiveStatus(this.status);
}