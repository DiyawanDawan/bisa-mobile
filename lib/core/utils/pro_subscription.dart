import '../../features/auth/domain/entities/user_entity.dart';

bool isProActive(UserEntity user) {
  if (user.tier != 'PRO') return false;
  if (user.subscriptionExpiresAt == null) return false;
  return user.subscriptionExpiresAt!.isAfter(DateTime.now());
}

bool requiresPro(UserEntity? user) {
  if (user == null) return true;
  return !isProActive(user);
}
