// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData()
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..dotNumber = json['dot'] as String
    ..mcNumber = json['mc'] as String
    ..createdAt = json['created_at'] as String
    ..profileImg = json['photo'] as String
    ..phoneNumber = json['phone'] as String
    ..email = json['email'] as String
    ..id = json['user_entity_id'] as String
    ..encrypt_id = json['entity_id'] as String
    ..reviews = (json['reviews'] as num)?.toDouble()
    ..loadCompleted = json['load_completed'] as String;
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'dot': instance.dotNumber,
      'mc': instance.mcNumber,
      'created_at': instance.createdAt,
      'photo': instance.profileImg,
      'phone': instance.phoneNumber,
      'email': instance.email,
      'user_entity_id': instance.id,
      'entity_id': instance.encrypt_id,
      'reviews': instance.reviews,
      'load_completed': instance.loadCompleted,
    };
