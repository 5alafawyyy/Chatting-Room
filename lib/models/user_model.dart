
class UserModel {
  static UserModel? mainUserModel;
  String? phoneNumber;
  String? fullName;
  String? bio;
  String? profilePic;
  UserModel({this.phoneNumber, this.fullName, this.bio, this.profilePic});

  UserModel.fromMap(Map<String, dynamic> map) {
    phoneNumber = map['phoneNumber'];
    fullName = map['fullName'];
    bio = map['bio'];
    profilePic = map['profilePic'];
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'bio': bio,
      'profilePic': profilePic,
    };
  }
}
