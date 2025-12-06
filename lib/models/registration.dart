class Registration {
  String username;
  String email;
  String password;

  Registration({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class RegistrationResponse {
  String status;
  String message;
  RegistrationData? data;

  RegistrationResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? RegistrationData.fromJson(json['data']) : null,
    );
  }
}

class RegistrationData {
  int memberId;
  String token;

  RegistrationData({
    required this.memberId,
    required this.token,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      memberId: int.parse(json['member_id'].toString()),
      token: json['token'],
    );
  }
}