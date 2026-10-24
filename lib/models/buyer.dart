import 'dart:convert';

class Buyer {
  //define fields
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;

  Buyer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
  });

  //serialization :convert Buyer obect to a map
  //Mapis collection of key value pairs
  //why: convertinga map is an intermedia step dart makes it earier to serialize the obect to format like json for storage or transmisssion

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "email": email,
      "state": state,
      "city": city,
      "locality": locality,
      "password": password,
      "token": token,
    };
  }
  //Serialication: convert map to json String
  //this method directoly encode the the data from the map into a json String
  // the json.encode() function converts a dart object (such as map ot list)
  // into a json string perresentation, making it suitable for communication
  //between different systems

  String toJson() => json.encode(toMap());

  //deserialization:convert a map to Buyer object
  //purpose: manipulation and Buyer , : once the data convert to use object ,
  //it can be easily manipulated and use within the application . For example
  // we might want  to display the Buyer full name email etc on the ui
  // or might want to save the data locaally

  // factory constructio tke s a map (usually obtained from the json objec)
  //and it conevert into Buyer object. if a field not prsenet in the,
  //it dafaults to an empty string

  //fromMap: this constructor take a Map(String, dynamic ) and convert into Buyer object
  //it is useful when u already data in map format
  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id: map['_id'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
      email: map['email'] as String? ?? "",
      state: map['state'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
    );
  }

  //from json: the factory constructor takes json string  and decodes into a Map<String, dynamic>
  //than uses from map to  convert the map into Buyer object

  // //or factory User.fromJson(String source) {
  // final map = json.decode(source) as Map<String, dynamic>;
  // return User.fromMap(map);
}
