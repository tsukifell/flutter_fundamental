class DataUser {
  final List<User> data;

  DataUser({required this.data});

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
      data: List.from(json['data'].map((user) => User.fromJson(user))));
}

class User {
  final int id;
  final String firstName, lastName, email, avatar;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      avatar: json['avatar']);
}
