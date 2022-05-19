// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return Contact(
    user_id: json['user_id'] as int,
    ref_id: json['ref_id'] as String,
    full_name: json['full_name'] as String,
    email: json['email'],
<<<<<<< HEAD
    isSelected: json['isSelected'] as bool,
=======
    isSelected: json['isSelected'],
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0
  );
}

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'email': instance.email,
      'ref_id': instance.ref_id,
      'full_name': instance.full_name,
      'isSelected': instance.isSelected,
    };
