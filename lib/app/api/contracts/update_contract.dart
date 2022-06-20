abstract class UpdateContract {
  void onUpdateSuccess(String message);
  void onUpdateFailed(String message);
  void onUpdateError(String message);
  void onUpdateComplete();
}
