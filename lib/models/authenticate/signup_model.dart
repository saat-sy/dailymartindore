class SignUpModel {
  int otp;
  SignUpModel({this.otp});
}

class SignUpInputModel {
  String name;
  String email;
  String phoneNo;
  String password;
  String cpassword;

  SignUpInputModel(
      {this.name, this.email, this.phoneNo, this.password, this.cpassword});
}
