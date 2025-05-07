class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}

class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String fullName;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['fullName'] = fullName;
    return data;
  }
}

class LoginResponse {
  final String token;
  final DateTime expiration;
  final String userId;
  final String username;
  String? refreshToken;

  LoginResponse({
    required this.token,
    required this.expiration,
    required this.userId,
    required this.username,
    this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      expiration: DateTime.parse(json['expiration']),
      userId: json['userId'],
      username: json['username'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['expiration'] = expiration.toIso8601String();
    data['userId'] = userId;
    data['username'] = username;
    data['refreshToken'] = refreshToken;
    return data;
  }
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
      success: json['success'],
      message: json['message'],
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
  final String confirmPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currentPassword'] = currentPassword;
    data['newPassword'] = newPassword;
    data['confirmPassword'] = confirmPassword;
    return data;
  }
}