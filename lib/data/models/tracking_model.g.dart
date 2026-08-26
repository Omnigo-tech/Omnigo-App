// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingModel _$TrackingModelFromJson(Map<String, dynamic> json) =>
    TrackingModel(
      orderId: json['orderId'] as String,
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String,
      location: json['location'] as String?,
      rider: json['rider'] == null
          ? null
          : RiderModel.fromJson(json['rider'] as Map<String, dynamic>),
      timeline: json['timeline'] == null
          ? null
          : TimelineModel.fromJson(json['timeline'] as Map<String, dynamic>),
      estimatedTime: json['estimatedTime'] as String? ?? '10-15 Min',
      storeName: json['storeName'] as String? ?? 'Grocery Store',
      destinationAddress:
          json['destinationAddress'] as String? ?? 'Your Address',
    );

Map<String, dynamic> _$TrackingModelToJson(TrackingModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderNumber': instance.orderNumber,
      'status': instance.status,
      'location': instance.location,
      'rider': instance.rider?.toJson(),
      'timeline': instance.timeline?.toJson(),
      'estimatedTime': instance.estimatedTime,
      'storeName': instance.storeName,
      'destinationAddress': instance.destinationAddress,
    };

RiderModel _$RiderModelFromJson(Map<String, dynamic> json) => RiderModel(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$RiderModelToJson(RiderModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
    };

TimelineModel _$TimelineModelFromJson(Map<String, dynamic> json) =>
    TimelineModel(
      orderPlaced: json['orderPlaced'] as String?,
      riderAssigned: json['riderAssigned'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$TimelineModelToJson(TimelineModel instance) =>
    <String, dynamic>{
      'orderPlaced': instance.orderPlaced,
      'riderAssigned': instance.riderAssigned,
      'updatedAt': instance.updatedAt,
    };
