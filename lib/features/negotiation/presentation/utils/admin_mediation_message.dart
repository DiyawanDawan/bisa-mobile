const adminMediationPrefix = '[Admin BISA]';

bool isAdminMediationMessageContent(String content) {
  return content.trimLeft().startsWith(adminMediationPrefix);
}

String stripAdminMediationPrefix(String content) {
  final trimmed = content.trimLeft();
  if (!trimmed.startsWith(adminMediationPrefix)) return content;
  return trimmed.substring(adminMediationPrefix.length).trimLeft();
}
