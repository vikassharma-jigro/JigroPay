class AuthModel {
  var status;

  bool? success;
  String? message;
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  User? user;

  AuthModel({
    this.status,
    this.success,
    this.message,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.user,
  });

  AuthModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  var username;
  var otp;
  var emailOtp;
  var mobile_otp;
  String? email;
  var emailVerifiedAt;
  var password;
  var photo;
  var photoPath;
  String? phone;
  var address;
  var latitude;
  var longitude;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? role;

  User({
    this.id,
    this.name,
    this.username,
    this.otp,
    this.emailOtp,
    this.mobile_otp,
    this.email,
    this.emailVerifiedAt,
    this.password,
    this.photo,
    this.photoPath,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.status,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    otp = json['otp'];
    username = json['username'];
    emailOtp = json['emailOtp'];
    mobile_otp = json['mobile_otp'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    photo = json['photo'];
    photoPath = json['photo_path'];
    phone = json['phone'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['otp'] = this.otp;
    data['username'] = this.username;
    data['emailOtp'] = this.emailOtp;
    data['mobile_otp'] = this.mobile_otp;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['photo'] = this.photo;
    data['photo_path'] = this.photoPath;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
