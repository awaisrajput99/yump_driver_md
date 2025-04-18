class OtpSendingFailure {
  final String message;

  const OtpSendingFailure([this.message = "An unknown error occurred."]);

  factory OtpSendingFailure.code(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return const OtpSendingFailure(
          'The phone number is invalid. Please enter a valid number.',
        );
      case 'too-many-requests':
        return const OtpSendingFailure(
          'Too many requests. This device has been temporarily blocked. Try again later.',
        );
      case 'quota-exceeded':
        return const OtpSendingFailure(
          'The SMS quota has been exceeded for this project. Please try again later.',
        );
      case 'network-request-failed':
        return const OtpSendingFailure(
          'A network error occurred. Please check your internet connection and try again.',
        );
      case 'operation-not-allowed':
        return const OtpSendingFailure(
          'Phone authentication is not enabled. Please contact support.',
        );
      case 'app-not-authorized':
        return const OtpSendingFailure(
          'This app is not authorized to use Firebase Authentication. Please check your Firebase configuration.',
        );
      case 'missing-client-identifier':
        return const OtpSendingFailure(
          'Missing client identifier. Please check your Firebase setup.',
        );
      case 'user-disabled':
        return const OtpSendingFailure(
          'This user account has been disabled. Please contact support.',
        );
      default:
        return const OtpSendingFailure();
    }
  }
}