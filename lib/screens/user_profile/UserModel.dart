

class User {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender; // Added gender field
  final String location;
  final String language;

  User({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender, // Added gender field
    required this.location,
    required this.language,
  });
  final User user = User(
    fullName: '',
    username: '',
    email: '',
    phone: '',
    dateOfBirth: '',
    location: '',
    language: '',
    gender: '',
  );

}