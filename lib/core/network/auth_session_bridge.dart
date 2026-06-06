/// Notifies app layer when refresh token fails and local session is cleared.
class AuthSessionBridge {
  void Function()? onSessionExpired;

  void notifySessionExpired() => onSessionExpired?.call();
}
