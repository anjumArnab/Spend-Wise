class User {
  final String uid;
  final String email;
  final String fullName;
  final String gender;
  final String bloodGroup;
  final String preferredLanguage;

  
  User({
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
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'] ?? '',
      gender: map['gender'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      preferredLanguage: map['preferredLanguage'] ?? '',
    );
  }

}