class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? profilePicture;
  final String? dob;
  final String? phoneNumber;
  final int user;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.profilePicture,
    this.dob,
    this.phoneNumber,
    required this.user,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      dob: json['dob'],
      phoneNumber: json['phone_number'],
      user: json['user'],
    );
  }
}