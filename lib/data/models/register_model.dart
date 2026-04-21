class RegisterModel {
  final String lastName;
  final String firstName;
  final String email;
  final DateTime dob;
  final String phoneNumber;
  final String companyName;
  final String address;
  final String tax;
  final String password;

  RegisterModel({
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.dob,
    required this.phoneNumber,
    required this.companyName,
    required this.address,
    required this.tax,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      dob: DateTime.parse(json['dob']),
      phoneNumber: json['phoneNumber'],
      companyName: json['companyName'],
      address: json['address'],
      tax: json['tax'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'dob': dob.toIso8601String(),
      'phoneNumber': phoneNumber,
      'companyName': companyName,
      'address': address,
      'tax': tax,
      'password': password,
    };
  }
}
