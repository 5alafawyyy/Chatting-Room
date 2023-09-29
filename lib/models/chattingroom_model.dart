class ChattingRoomModel {
  String? chattingroomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChattingRoomModel({this.chattingroomId, this.participants, this.lastMessage});

  ChattingRoomModel.fromMap(Map<String, dynamic> map) {
    chattingroomId = map["chattingroomId"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chattingroomId": chattingroomId,
      "participants": participants,
      "lastmessage": lastMessage
    };
  }
}
