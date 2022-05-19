import 'package:json_annotation/json_annotation.dart';
part 'contact.g.dart';
<<<<<<< HEAD
 
=======

>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0
@JsonSerializable()
class Contact {
  int user_id;
  dynamic email;
  String ref_id;
  String full_name;
<<<<<<< HEAD
  bool isSelected = false;
 
  Contact({this.user_id, this.ref_id, this.full_name,this.email, this.isSelected = false});
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
=======
  bool? isSelected = false;

  Contact(
      {required this.user_id,
      required this.ref_id,
      required this.full_name,
      this.email,
      this.isSelected = false});
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0
