import 'package:json_annotation/json_annotation.dart';

part 'tracking_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TrackingModel {
  @JsonKey(name: 'orderId')
  final String orderId;

  @JsonKey(name: 'orderNumber')
  final String orderNumber;

  final String status;

  @JsonKey(name: 'location')
  final String? location;


  // Sub-models for nested objects
  @JsonKey(name: 'rider')
  final RiderModel? rider;

  @JsonKey(name: 'timeline')
  final TimelineModel? timeline;

  // Non-backend fields standard default values ke sath
  @JsonKey(defaultValue: "10-15 Min")
  final String estimatedTime;

  @JsonKey(defaultValue: "Grocery Store")
  final String storeName;

  @JsonKey(defaultValue: "Your Address")
  final String destinationAddress;

  TrackingModel({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.location,
    this.rider,
    this.timeline,
    this.estimatedTime = "10-15 Min",
    this.storeName = "Grocery Store",
    this.destinationAddress = "Your Address",
  });

  // UI Layers ko break hone se bachane ke liye getters (aapki screen ka code change nahi karna parega)
  String get deliveryHeroName => rider?.name ?? 'Assigning Rider...';
  String get phonenumber => rider?.phone ?? '';
  String get orderPlacedTime => timeline?.orderPlaced ?? '';
  String get riderAssignedTime => timeline?.riderAssigned ?? '';

  // API wrapper structure handling
  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json.containsKey('tracking')
        ? json['tracking'] as Map<String, dynamic>
        : json;
    return _$TrackingModelFromJson(data);
  }

  Map<String, dynamic> toJson() => _$TrackingModelToJson(this);

  // Socket updates ke liye safe copyWith state modifier
  TrackingModel copyWith({String? newStatus}) {
    return TrackingModel(
      orderId: this.orderId,
      orderNumber: this.orderNumber,
      status: newStatus ?? this.status,
      location: this.location,
      rider: this.rider,
      timeline: this.timeline,
      estimatedTime: this.estimatedTime,
      storeName: this.storeName,
      destinationAddress: this.destinationAddress,
    );
  }
}

// ==========================================
// RIDER SUB MODEL
// ==========================================
@JsonSerializable()
class RiderModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? phone;

  RiderModel({this.id, this.name, this.phone});

  factory RiderModel.fromJson(Map<String, dynamic> json) => _$RiderModelFromJson(json);
  Map<String, dynamic> toJson() => _$RiderModelToJson(this);
}

// ==========================================
// TIMELINE SUB MODEL
// ==========================================
@JsonSerializable()
class TimelineModel {
  final String? orderPlaced;
  final String? riderAssigned;
  final String? updatedAt;

  TimelineModel({this.orderPlaced, this.riderAssigned, this.updatedAt});

  factory TimelineModel.fromJson(Map<String, dynamic> json) => _$TimelineModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimelineModelToJson(this);
}