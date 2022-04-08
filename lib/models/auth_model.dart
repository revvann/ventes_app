class AuthModel {
  int? userId;
  String? jwtToken;
  int? accountActive;

  AuthModel({
    this.userId,
    this.jwtToken,
    this.accountActive,
  });
}
