class Contribution {
  String uid;
  String? overwriteId;

  Contribution(
    this.uid, {
    this.overwriteId,
  });

  Contribution.fromJson(Map<String, dynamic> json)
      : this(
          json['uid'] as String,
          overwriteId: json['overwriteId'] as String?,
        );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'overwriteId': overwriteId,
    };
  }
}
