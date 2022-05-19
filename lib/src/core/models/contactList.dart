import 'contact.dart';
import 'package:json_annotation/json_annotation.dart';
part 'contactList.g.dart';

@JsonSerializable()
class ContactList {
<<<<<<< HEAD
  final List<Contact> users;
=======
  final List<Contact?>? users;
>>>>>>> 95fd6584abf96bb0dfe2c53a6712964e820512c0
  ContactList({this.users});
  factory ContactList.fromJson(Map<String, dynamic> json) =>
      _$ContactListFromJson(json);
  Map<String, dynamic> toJson() => _$ContactListToJson(this);
}
