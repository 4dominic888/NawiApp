enum CredentialDataType {
  pin(length: 4, name: 'PIN'),
  dni(length: 8, name: 'dni');

  final int length;
  final String name;

  const CredentialDataType({required this.length, required this.name});
}

class CredentialData {
  final String authCode;
  final CredentialDataType mode;

  CredentialData({required this.authCode, required this.mode});
}