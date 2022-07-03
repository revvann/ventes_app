class AuthModel {
  int? userId;
  String? jwtToken;
  int? accountActive;
  String? username;
  String? password;

  AuthModel({
    this.userId,
    this.jwtToken,
    this.accountActive,
    this.password,
    this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'jwtToken': jwtToken,
      'accountActive': accountActive,
      'password': password,
      'username': username,
    };
  }
}
