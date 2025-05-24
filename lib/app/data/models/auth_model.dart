class LoginRequest {
  final String phoneNumber;
  final String password;

  LoginRequest({
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    return data;
  }
}

class RegisterRequest {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String email;

  RegisterRequest({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['email'] = email;
    return data;
  }
}

// Fixed User Model to match API response
class User {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String? profilePictureUrl;

  User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    if (profilePictureUrl != null) data['profilePictureUrl'] = profilePictureUrl;
    return data;
  }
}

// Fixed LoginResponse to match actual API response
class LoginResponse {
  final String token;
  final String refreshToken;
  final DateTime expiration;
  final User user;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.expiration,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiration: DateTime.parse(json['expiration']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['expiration'] = expiration.toIso8601String();
    data['user'] = user.toJson();
    return data;
  }

  // Helper getter for userId (backward compatibility)
  String get userId => user.id;
}

class RegisterResponse {
  final bool success;
  final String message;
  final String userId;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.userId,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'تم تسجيل المستخدم بنجاح',
      userId: json['userId'],
    );
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['refreshToken'] = refreshToken;
    return data;
  }
}

class RefreshTokenResponse {
  final String token;
  final DateTime expiration;

  RefreshTokenResponse({
    required this.token,
    required this.expiration,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      token: json['token'],
      expiration: DateTime.parse(json['expiration']),
    );
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currentPassword'] = currentPassword;
    data['newPassword'] = newPassword;
    data['confirmNewPassword'] = confirmNewPassword;
    return data;
  }
}

class VerifyPhoneRequest {
  final String phoneNumber;
  final String verificationCode;

  VerifyPhoneRequest({
    required this.phoneNumber,
    required this.verificationCode,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['verificationCode'] = verificationCode;
    return data;
  }
}

class SendVerificationCodeRequest {
  final String phoneNumber;

  SendVerificationCodeRequest({
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

class ForgotPasswordRequest {
  final String phoneNumber;

  ForgotPasswordRequest({
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

class ResetPasswordRequest {
  final String phoneNumber;
  final String verificationCode;
  final String newPassword;
  final String confirmNewPassword;

  ResetPasswordRequest({
    required this.phoneNumber,
    required this.verificationCode,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['verificationCode'] = verificationCode;
    data['newPassword'] = newPassword;
    data['confirmNewPassword'] = confirmNewPassword;
    return data;
  }
}

class VerificationResponse {
  final bool success;
  final String message;

  VerificationResponse({
    required this.success,
    required this.message,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'تم بنجاح',
    );
  }
}