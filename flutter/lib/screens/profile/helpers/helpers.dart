String extractNameFromEmail(String email) {
  final atParts = email.split('@');
  if (atParts.isEmpty) return '';

  final dotParts = atParts.first.split('.');
  if (dotParts.length < 2) return '';

  return dotParts[1];
}
