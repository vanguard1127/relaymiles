// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobData _$JobDataFromJson(Map<String, dynamic> json) {
  return JobData()
    ..loadNumber = json['Load_Number'] as String
    ..id = json['id'] as String
    ..price = json['price'] as String
    ..pickupAddress = json['From_Address'] as String
    ..pickupCity = json['from_address_city'] as String
    ..pickupState = json['from_address_state'] as String
    ..deliveryAddress = json['To_Address'] as String
    ..deliveryCity = json['to_address_city'] as String
    ..deliveryState = json['to_address_state'] as String
    ..notes = json['Comments'] as String
    ..pickupTime = json['Pickup_Time'] as String
    ..dropOffTime = json['Delivery_Time'] as String
    ..distance = json['distance_two'] as String
    ..poster = json['name'] as String
    ..email = json['email'] as String
    ..phone = json['phone'] as String
    ..invoiceID = json['invoiceId'] as String
    ..reviews = (json['reviews'] as num)?.toDouble()
    ..trailer = json['trailerType'] as String
    ..weight = json['weight'] as String
    ..status = json['status'] as String;
}

Map<String, dynamic> _$JobDataToJson(JobData instance) => <String, dynamic>{
      'Load_Number': instance.loadNumber,
      'id': instance.id,
      'price': instance.price,
      'From_Address': instance.pickupAddress,
      'from_address_city': instance.pickupCity,
      'from_address_state': instance.pickupState,
      'To_Address': instance.deliveryAddress,
      'to_address_city': instance.deliveryCity,
      'to_address_state': instance.deliveryState,
      'Comments': instance.notes,
      'Pickup_Time': instance.pickupTime,
      'Delivery_Time': instance.dropOffTime,
      'distance_two': instance.distance,
      'name': instance.poster,
      'email': instance.email,
      'phone': instance.phone,
      'invoiceId': instance.invoiceID,
      'reviews': instance.reviews,
      'trailerType': instance.trailer,
      'weight': instance.weight,
      'status': instance.status,
    };
