abstract class LogoutContract {
  void onLogoutSuccess(String message);
  void onLogoutFailed(String message);
  void onLogoutError(String message);
  void onLogoutComplete();
}
