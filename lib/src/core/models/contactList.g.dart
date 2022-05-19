// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contactList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactList _$ContactListFromJson(Map<String, dynamic> json) {
  return ContactList(
    users: (json['users'] as List)
<<<<<<< HEAD
        ?.map((e) =>
            e == null ? null : Contact.fromJson(e as Map<String, dynamic>))
        ?.toList(),
=======
        .map((e) =>
            e == null ? null : Contact.fromJson(e as Map<String, dynamic>))
        .toList(),
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0
  );
}

Map<String, dynamic> _$ContactListToJson(ContactList instance) =>
    <String, dynamic>{
      'users': instance.users,
    };
