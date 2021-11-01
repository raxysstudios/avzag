class Contribution {
  String uid;
  String? overwriteId;

  Contribution(
    this.uid, {
    this.overwriteId,
  });

  Contribution.fromJson(Map<String, dynamic> json)
      : this(
          json['uid'],
          overwriteId: json['overwriteId'],
        );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "overwriteId": overwriteId,
      };
}
