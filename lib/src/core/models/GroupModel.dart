import 'package:json_annotation/json_annotation.dart';
import '../../core/models/ParticipantsModel.dart';
part 'GroupModel.g.dart';

@JsonSerializable()
class GroupModel {
  dynamic admin_id;
  dynamic auto_created;
  dynamic channel_key;
  dynamic channel_name;
  dynamic group_title;
  dynamic id;
  dynamic created_datetime;
  dynamic counter;
  dynamic typingstatus;
<<<<<<< HEAD
  List<ParticipantsModel> participants = [];
=======
  List<ParticipantsModel?> participants = [];
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0

  GroupModel(
      {this.admin_id,
      this.auto_created,
      this.channel_key,
      this.channel_name,
      this.group_title,
      this.created_datetime,
      this.typingstatus,
      this.id,
      this.counter,
<<<<<<< HEAD
      this.participants});
=======
      required this.participants});
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}
