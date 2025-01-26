
class CallStream {
  final String uid;
  final String username;
  final String? secondaryHostUid;
  final String? secondaryHostName;
  final startedAt;
  final String channelId;

  CallStream({
    required this.uid,
    required this.username,
    this.secondaryHostUid,
    this.secondaryHostName,
    required this.startedAt,
    required this.channelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'secondaryHostUid': secondaryHostUid,
      'secondaryHostName': secondaryHostName,
      'startedAt': startedAt,
      'channelId': channelId,
    };
  }

  factory CallStream.fromMap(Map<String, dynamic> map){
    return CallStream(
      uid: map['uid'] ?? '', 
      username: map['username'] ?? '',
      secondaryHostUid: map['secondaryHostUid'], 
      secondaryHostName: map['secondaryHostName'], 
      startedAt: map['startedAt'] ?? '', 
      channelId: map['channelId'] ?? '',
      );
  }

}