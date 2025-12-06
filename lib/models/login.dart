class Login {
  String username;
  String password;

  Login({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      username: json['username'],
      password: json['password'],
    );
  }
}

class LoginResponse {
  String status;
  String message;
  LoginData? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  int memberId;
  String username;
  String email;
  String token;

  LoginData({
    required this.memberId,
    required this.username,
    required this.email,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      memberId: int.parse(json['member_id'].toString()),
      username: json['username'],
      email: json['email'],
      token: json['token'],
    );
  }
}