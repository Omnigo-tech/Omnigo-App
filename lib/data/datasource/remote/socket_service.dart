import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;
  String? _currentUserId; // Active User ID tracking for reconnection
  String? _currentConversationId; // Active Chat Room tracking for reconnection
  String? _activeTrackingOrderId; // 👇 NEW: Reconnection ke liye track rakhein

  final StreamController<Map<String, dynamic>> _statusController =
  StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get orderStatusStream => _statusController.stream;

  void initSocket() {
    _socket = IO.io('http://192.168.100.69:5000', IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build());

    _socket.onConnect((_) {
      log('🚀 Socket Connected Successfully');

      // Reconnect hone par auto-recovery channels mapping
      if (_currentUserId != null) {
        _socket.emit('join', _currentUserId);
        log('💬 Re-joined User Room on Connect: $_currentUserId');
      }
      if (_currentConversationId != null) {
        _socket.emit('joinConversation', _currentConversationId);
        log('💬 Re-joined Chat Room on Connect: $_currentConversationId');
      }
      // 👇 NEW: Network drop hone ke baad reconnect ho to khud tracking room dobara join kare
      if (_activeTrackingOrderId != null) {
        _socket.emit('joinOrderTracking', _activeTrackingOrderId);
        log('📡 Re-joined Tracking Room on Connect: order_$_activeTrackingOrderId');
      }
    });

    // ================= GLOBAL EVENT LISTENERS =================

    // 1. Purana Order Tracking Listener (Agar kisi aur jagah backup me chal rha ho)
    _socket.on('orderStatusUpdated', (data) {
      log('📥 Live Tracking Update: $data');
      if (data != null) {
        final extendedData = Map<String, dynamic>.from(data);
        extendedData['event'] = 'orderStatusUpdated';
        _statusController.add(extendedData);
      }
    });

    // 👇 NEW: 1.1 Timeline Live Status Listener (Rider Test Scripts Se Match)
    _socket.on('orderTrackingStatusLive', (data) {
      log('📥 Live Timeline Status Update: $data');
      if (data != null) {
        final extendedData = Map<String, dynamic>.from(data);
        extendedData['event'] = 'orderTrackingStatusLive';
        _statusController.add(extendedData);
      }
    });

    // 👇 NEW: 1.2 Rider Live Assignment Listener
    _socket.on('riderAssignedLive', (data) {
      log('📥 Live Rider Assignment Update: $data');
      if (data != null) {
        final extendedData = Map<String, dynamic>.from(data);
        extendedData['event'] = 'riderAssignedLive';
        _statusController.add(extendedData);
      }
    });

    // 👇 NEW: 1.3 Rider Live Map Location Listener
    _socket.on('riderLocationLive', (data) {
      if (data != null) {
        final extendedData = Map<String, dynamic>.from(data);
        extendedData['event'] = 'riderLocationLive';
        _statusController.add(extendedData);
      }
    });

    // 2. Real-time Chat Message Listener (UNTOUCHED)
    _socket.on('receiveMessage', (data) {
      log('📩 Live Chat Message Received: $data');
      if (data != null) {
        final extendedData = Map<String, dynamic>.from(data);
        extendedData['event'] = 'receiveMessage';
        _statusController.add(extendedData);
      }
    });

    // 3. Incoming Call Signal Listener (UNTOUCHED)
    _socket.on('incomingCall', (data) {
      log('📞 Incoming Call Signal Received: $data');
      if (data != null) {
        final extendedData = Map<String, dynamic>.from(data);
        extendedData['event'] = 'incomingCall';
        _statusController.add(extendedData);
      }
    });

    // 4. Call Ended Signal Listener (UNTOUCHED)
    _socket.on('callEnded', (data) {
      log('❌ Call Ended Signal Received: $data');
      if (data != null) {
        final extendedData = Map<String, dynamic>.from(data);
        extendedData['event'] = 'callEnded';
        _statusController.add(extendedData);
      }
    });

    _socket.onDisconnect((_) => log('❌ Socket Disconnected'));
    _socket.onConnectError((err) => log('⚠️ Connect Error: $err'));
    _socket.onError((err) => log('🚨 Socket Error: $err'));
  }

  // ================= ROOM JOIN EMITTERS =================

  void joinUserRoom(String userId) {
    _currentUserId = userId;
    if (_socket.connected) {
      _socket.emit('join', userId);
      log('💬 Identity Registered Room: $userId');
    } else {
      log('⚠️ Socket initializing context... Will auto-join identity pool.');
      _socket.connect();
    }
  }

  void joinConversationRoom(String conversationId) {
    _currentConversationId = conversationId;
    if (_socket.connected) {
      _socket.emit('joinConversation', conversationId);
      log('💬 Joined Chat Room Pipeline: $conversationId');
    }
  }

  // 👇 NEW: Backend ki script "joinOrderTracking" ke sath mapping function
  void joinOrderTrackingRoom(String orderId) {
    _activeTrackingOrderId = orderId;
    if (_socket.connected) {
      _socket.emit('joinOrderTracking', orderId);
      log('📡 Joined Tracking Room pipeline for: order_$orderId');
    }
  }

  // 👇 NEW: Tracking Screen leave karne par memory aur socket free karne ke liye
  void leaveOrderTrackingRoom(String orderId) {
    _activeTrackingOrderId = null;
    if (_socket.connected) {
      _socket.emit('leaveOrderTracking', orderId);
      log('❌ Left Tracking Room pipeline for: order_$orderId');
    }
  }

  // ================= DATA EMITTERS PIPELINES (UNTOUCHED) =================

  void emitMessage({
    required String conversationId,
    required String sender,
    required String receiver,
    required String message,
  }) {
    if (_socket.connected) {
      _socket.emit('sendMessage', {
        'conversationId': conversationId,
        'sender': sender,
        'receiver': receiver,
        'message': message,
      });
      log('💬 Message Emitted to Server Line');
    }
  }

  void emitInitiateCall({
    required String conversationId,
    required String callerId,
    required String receiverId,
  }) {
    if (_socket.connected) {
      _socket.emit('initiateCall', {
        'conversationId': conversationId,
        'callerId': callerId,
        'receiverId': receiverId,
        'signalData': {'sdp': 'dummy-webrtc-handshake', 'type': 'offer'},
        'callType': 'audio',
      });
      log('📞 Call Signal Emitted across Socket Engine');
    }
  }

  void emitEndCall({
    required String conversationId,
    required String targetId,
    String reason = 'ended',
  }) {
    if (_socket.connected) {
      _socket.emit('endCall', {
        'conversationId': conversationId,
        'targetId': targetId,
        'reason': reason,
      });
      log('❌ End Call Terminate Event Emitted');
    }
  }

  void dispose() {
    _statusController.close();
    _socket.disconnect();
  }
}