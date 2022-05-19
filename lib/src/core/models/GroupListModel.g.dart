// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupListModel _$GroupListModelFromJson(Map<String, dynamic> json) {
  return GroupListModel(
    groups: (json['groups'] as List)
<<<<<<< HEAD
        ?.map((e) =>
            e == null ? null : GroupModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
=======
        .map((e) =>
            e == null ? null : GroupModel.fromJson(e as Map<String, dynamic>))
        .toList(),
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0
  );
}

Map<String, dynamic> _$GroupListModelToJson(GroupListModel instance) =>
    <String, dynamic>{
      'groups': instance.groups,
    };
