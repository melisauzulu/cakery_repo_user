class Address
{
  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? fullAddress;
  double? lat;
  double? lgn;

  Address({
    this.name,
    this.phoneNumber,
    this.flatNumber,
    this.city,
    this.state,
    this.fullAddress,
    this.lat,
    this.lgn,
});

  Address.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    flatNumber = json['flatNumber'];
    city = json['city'];
    state = json['state'];
    fullAddress = json['fullAddress'];
    lat = json['lat'];
    lgn = json['lgn'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['flatNumber'] = flatNumber;
    data['city'] = city;
    data['state'] = state;
    data['fullAddress'] = fullAddress;
    data['lat'] = lat;
    data['lgn'] = lgn;

    return data;

  }

}