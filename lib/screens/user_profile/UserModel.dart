// UserModel.dart
class User {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String location;
  final String language;

  User({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.location,
    required this.language,
  });
}