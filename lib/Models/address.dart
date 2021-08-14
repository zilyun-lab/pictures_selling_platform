class AddressModel {
  String lastName;
  String firstName;
  String phoneNumber;
  String address;
  String city;
  String prefectures;
  String postalCode;
  String secondAddress;

  AddressModel(
      {this.lastName,
      this.firstName,
      this.phoneNumber,
      this.address,
      this.city,
      this.prefectures,
      this.postalCode,
      this.secondAddress});

  AddressModel.fromJson(Map<String, dynamic> json) {
    lastName = json['lastName'];
    firstName = json['firstName'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    city = json['city'];
    prefectures = json['prefectures'];
    postalCode = json['postalCode'];
    secondAddress = json['secondAddress'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lastName'] = lastName;
    data['firstName'] = firstName;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['city'] = city;
    data['prefectures'] = prefectures;
    data['postalCode'] = postalCode;
    data['secondAddress'] = secondAddress;
    return data;
  }
}
