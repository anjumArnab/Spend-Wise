class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String gender;
  final String bloodGroup;
  final String preferredLanguage;

  
  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.bloodGroup,
    required this.preferredLanguage,

  });
  
  // Convert UserModel to Map for database operations or API calls
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email' : email,
      'fullName': fullName,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'preferredLanguage': preferredLanguage,
    };
  }
  
  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'] ?? '',
      gender: map['gender'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      preferredLanguage: map['preferredLanguage'] ?? '',
    );
  }

}