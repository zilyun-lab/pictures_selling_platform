class AddressModel {
  String lastName;
  String firstName;
  String phoneNumber;
  String address;
  String city;
  String prefectures;
  String postalCode;

  AddressModel(
      {this.lastName,
      this.firstName,
      this.phoneNumber,
      this.address,
      this.city,
      this.prefectures,
      this.postalCode});

  AddressModel.fromJson(Map<String, dynamic> json) {
    lastName = json['lastName'];
    firstName = json['firstName'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    city = json['city'];
    prefectures = json['prefectures'];
    postalCode = json['postalCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['city'] = this.city;
    data['prefectures'] = this.prefectures;
    data['postalCode'] = this.postalCode;
    return data;
  }
}
