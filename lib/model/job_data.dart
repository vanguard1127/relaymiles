import 'package:json_annotation/json_annotation.dart';


part 'job_data.g.dart';
@JsonSerializable()
class JobData{

  @JsonKey(name: "Load_Number")
  String loadNumber;
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "price")
  String price;
  @JsonKey(name: "From_Address")
  String pickupAddress;
  @JsonKey(name: "from_address_city")
  String pickupCity;
  @JsonKey(name: "from_address_state")
  String pickupState;
  @JsonKey(name: "To_Address")
  String deliveryAddress;
  @JsonKey(name: "to_address_city")
  String deliveryCity;
  @JsonKey(name: "to_address_state")
  String deliveryState;
  @JsonKey(name: "Comments")
  String notes;
  @JsonKey(name: "Pickup_Time")
  String pickupTime;
  @JsonKey(name: "Delivery_Time")
  String dropOffTime;


  @JsonKey(name: "distance_two")
  String distance;
  @JsonKey(name: "name")
  String poster;

  @JsonKey(name: "email")
  String email;

  @JsonKey(name: "phone")
  String phone;

  @JsonKey(name: "invoiceId")
  String invoiceID;

  double reviews = 0;
  @JsonKey(name: "trailerType")
  String trailer;
  @JsonKey(name: "weight")
  String weight;
  @JsonKey(name: "status")
  String status = "0";  // 1: booked 2: started natigation 3: pickuped 4: completed 5: upload invoice

  JobData();

  factory JobData.fromJson(Map<String, dynamic> json) =>
      _$JobDataFromJson(json);
  Map<String, dynamic> toJson() => _$JobDataToJson(this);
}