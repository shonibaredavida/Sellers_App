class Address {
  String? city;
  String? completeAddress;
  String? phoneNumber;
  String? name;
  String? flatHouseNumber;
  String? streetNumber;
  String? stateCountry;
  Address(
      {this.name,
      this.phoneNumber,
      this.streetNumber,
      this.flatHouseNumber,
      this.city,
      this.stateCountry,
      this.completeAddress});

  Address.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    completeAddress = json['completeAddress'];
    streetNumber = json['streetNumber'];
    phoneNumber = json['phoneNumber'];
    flatHouseNumber = json['flatHouseNumber'];
    city = json['city'];
    stateCountry = json['stateCountry'];
  }
}
