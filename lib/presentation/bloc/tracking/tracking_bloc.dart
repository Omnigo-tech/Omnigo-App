import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/remote/socket_service.dart';
import '../../../data/datasource/repositories/tracking_repository.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingRepository repository;
  final SocketService socketService;
  StreamSubscription? _socketSubscription;

  TrackingBloc(this.repository, this.socketService) : super(TrackingInitial()) {
    on<FetchTrackingDetails>(_fetchTracking);
    on<UpdateLiveStatus>((event, emit) {
      if (state is TrackingLoaded) {
        final currentModel = (state as TrackingLoaded).trackingModel;
        log("🔄 UI mai naya status emit ho rha hai: ${event.status}");
        final updatedModel = currentModel.copyWith(newStatus: event.status);
        emit(TrackingLoaded(updatedModel));
      }
    });
  }

  Future<void> _fetchTracking(FetchTrackingDetails event, Emitter<TrackingState> emit) async {
    emit(TrackingLoading());
    try {
      // 1. Fetch REST Data
      final tracking = await repository.getTracking(event.orderId);
      emit(TrackingLoaded(tracking));

      // 2. Core Fix: Identity mapping setup aur ORDER tracker room join
      socketService.joinUserRoom(event.userId);
      socketService.joinOrderTrackingRoom(event.orderId); // 👈 ROOM JOINED NOW!

      // 3. Setup Stream safely without duplicating listeners
      await _socketSubscription?.cancel();
      _socketSubscription = socketService.orderStatusStream.listen(
            (data) {
          log("📡 Socket Stream Hooked Data: $data");
          final incomingOrderId = data['orderId']?.toString();

          if (incomingOrderId == event.orderId) {
            // Scene A: Status Timeline Changed Event
            if (data['event'] == 'orderTrackingStatusLive') {
              final newStatus = data['status']?.toString() ?? "";
              add(UpdateLiveStatus(newStatus));
            }

            // Scene B: Rider Assignment Data Accepted Event
            else if (data['event'] == 'riderAssignedLive') {
              // Agar rider assign ho jaye, to status change karne ke liye event push karein
              final newStatus = data['status']?.toString() ?? "confirmed";
              add(UpdateLiveStatus(newStatus));

              // Note: Agar full model replace karna hai (Rider Name ke sath), to aap fresh REST data bhi call kar sakte hain:
              // add(FetchTrackingDetails(orderId: event.orderId, userId: event.userId));
            }
          }
        },
        onError: (error) => log("Stream Error: $error"),
      );

    } catch (e) {
      emit(TrackingError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    return super.close();
  }
}