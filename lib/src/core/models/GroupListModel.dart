import 'package:json_annotation/json_annotation.dart';
import '../models/GroupModel.dart';
part 'GroupListModel.g.dart';

@JsonSerializable()
class GroupListModel {
<<<<<<< HEAD
  List<GroupModel> groups = [];
=======
  List<GroupModel?>? groups = [];
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0

  GroupListModel({this.groups});

  factory GroupListModel.fromJson(Map<String, dynamic> json) =>
      _$GroupListModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupListModelToJson(this);
}
