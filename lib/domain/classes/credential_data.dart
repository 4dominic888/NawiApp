enum CredentialDataType {
  pin, dni
}

class CredentialData {
  final String authCode;
  final CredentialDataType mode;

  CredentialData({required this.authCode, required this.mode});
}