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
}
