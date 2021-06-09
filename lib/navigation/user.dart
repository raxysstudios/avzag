import 'package:avzag/utils.dart';

class EditorUser {
  String email;
  List<String>? editor;
  String? contact;

  EditorUser({
    required this.email,
    this.editor,
    this.contact,
  });

  EditorUser.fromJson(Map<String, dynamic> json, String email)
      : this(
          email: email,
          editor: json2list(json['editor']),
          contact: json['contact'],
        );

  Map<String, dynamic> toJson() => {};
}
