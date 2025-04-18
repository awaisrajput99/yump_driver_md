import 'dart:convert';

class DriverPaymentModal {
  DriverPaymentModal({
    required this.success,
    required this.error,
    required this.data,
  });
  late final String success;
  late final String error;
  late final Data data;

  DriverPaymentModal.fromJson(Map<String, dynamic> json){
    success = json['success'];
    error = json['error'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.idUserApp,
    required this.idConducteur,
    required this.departName,
    required this.destinationName,
    required this.latitudeDepart,
    required this.longitudeDepart,
    required this.latitudeArrivee,
    required this.longitudeArrivee,
    required this.stops,
    required this.place,
    required this.numberPoeple,
    required this.distance,
    required this.distanceUnit,
    required this.duree,
    required this.montant,
    required this.tipAmount,
    this.tax,
    this.discount,
    required this.adminCommission,
    required this.transactionId,
    required this.trajet,
    required this.statut,
    required this.statutPaiement,
    required this.idPaymentMethod,
    required this.creer,
    required this.modifier,
    required this.dateRetour,
    required this.heureRetour,
    required this.statutRound,
    required this.statutCourse,
    required this.idConducteurAccepter,
    required this.tripObjective,
    required this.tripCategory,
    required this.ageChildren1,
    required this.ageChildren2,
    required this.ageChildren3,
    required this.feelSafe,
    required this.feelSafeDriver,
    required this.carDriverConfirmed,
    required this.otp,
    required this.otpCreated,
    this.deletedAt,
    this.updatedAt,
    this.dispatcherId,
    this.rideType,
    this.userInfo,
    this.rejectedDriverId,
    required this.rideDate,
    required this.riderFirebaseId,
    required this.driveFirebaseId,
    this.driverLiveLatitude,
    this.driverLiveLongitude,
    required this.appliedTaxes,
    required this.taxAmount,
    required this.paymentIntentId,
    required this.vehicleId,
    required this.zoneId,
    required this.baseAmount,
    this.sessionId,
    required this.driverPayment,
    required this.paymentMethod,
    required this.amount,
    required this.amountDriver,
  });
  late final String id;
  late final String idUserApp;
  late final String idConducteur;
  late final String departName;
  late final String destinationName;
  late final String latitudeDepart;
  late final String longitudeDepart;
  late final String latitudeArrivee;
  late final String longitudeArrivee;
  List<Stops>? stops;
  late final String place;
  late final String numberPoeple;
  late final String distance;
  late final String distanceUnit;
  late final String duree;
  late final String montant;
  late final String tipAmount;
  late final String? tax;
  late final String? discount;
  late final String adminCommission;
  late final String transactionId;
  late final String trajet;
  late final String statut;
  late final String statutPaiement;
  late final String idPaymentMethod;
  late final String creer;
  late final String modifier;
  late final String dateRetour;
  late final String heureRetour;
  late final String statutRound;
  late final String statutCourse;
  late final String idConducteurAccepter;
  late final String tripObjective;
  late final String tripCategory;
  late final String ageChildren1;
  late final String ageChildren2;
  late final String ageChildren3;
  late final String feelSafe;
  late final String feelSafeDriver;
  late final String carDriverConfirmed;
  late final String otp;
  late final String otpCreated;
  late final String? deletedAt;
  late final String? updatedAt;
  late final String? dispatcherId;
  late final String? rideType;
  late final String? userInfo;
  late final String? rejectedDriverId;
  late final String rideDate;
  late final String riderFirebaseId;
  late final String driveFirebaseId;
  late final String? driverLiveLatitude;
  late final String? driverLiveLongitude;
  late final String appliedTaxes;
  late final String taxAmount;
  late final String paymentIntentId;
  late final String vehicleId;
  late final String zoneId;
  late final String baseAmount;
  late final String? sessionId;
  late final String driverPayment;
  late final String paymentMethod;
  late final String amount;
  late final String amountDriver;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    idUserApp = json['id_user_app'];
    idConducteur = json['id_conducteur'];
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    latitudeDepart = json['latitude_depart'];
    longitudeDepart = json['longitude_depart'];
    latitudeArrivee = json['latitude_arrivee'];
    longitudeArrivee = json['longitude_arrivee'];
    if (json['stops'] is List) {
      stops = [];
      json['stops'].forEach((v) {
        stops!.add(v); // or RideStop.fromJson(v) if stops is a list of objects
      });
    } else if (json['stops'] is String) {
      // Try to decode the string to a List if possible
      try {
        List<dynamic> parsed = jsonDecode(json['stops']);
        stops = parsed.cast<Stops>();
      } catch (e) {
        stops = [];
      }
    }
    place = json['place'];
    numberPoeple = json['number_poeple'];
    distance = json['distance'];
    distanceUnit = json['distance_unit'];
    duree = json['duree'];
    montant = json['montant'];
    tipAmount = json['tip_amount'];
    tax = json['tax'];
    discount = json['tax'];
    adminCommission = json['admin_commission'];
    transactionId = json['transaction_id'];
    trajet = json['trajet'];
    statut = json['statut'];
    statutPaiement = json['statut_paiement'];
    idPaymentMethod = json['id_payment_method'];
    creer = json['creer'];
    modifier = json['modifier'];
    dateRetour = json['date_retour'];
    heureRetour = json['heure_retour'];
    statutRound = json['statut_round'];
    statutCourse = json['statut_course'];
    idConducteurAccepter = json['id_conducteur_accepter'];
    tripObjective = json['trip_objective'];
    tripCategory = json['trip_category'];
    ageChildren1 = json['age_children1'];
    ageChildren2 = json['age_children2'];
    ageChildren3 = json['age_children3'];
    feelSafe = json['feel_safe'];
    feelSafeDriver = json['feel_safe_driver'];
    carDriverConfirmed = json['car_driver_confirmed'];
    otp = json['otp'];
    otpCreated = json['otp_created'];
    deletedAt = null;
    updatedAt = null;
    dispatcherId = null;
    rideType = null;
    userInfo = null;
    rejectedDriverId = null;
    rideDate = json['ride_date'];
    riderFirebaseId = json['rider_firebase_id'];
    driveFirebaseId = json['drive_firebase_id'];
    driverLiveLatitude = null;
    driverLiveLongitude = null;
    appliedTaxes = json['applied_taxes'];
    taxAmount = json['tax_amount'];
    paymentIntentId = json['payment_intent_id'];
    vehicleId = json['vehicle_id'];
    zoneId = json['zone_id'];
    baseAmount = json['base_amount'];
    sessionId = null;
    driverPayment = json['driver_payment'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    amountDriver = json['amount_driver'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['id_user_app'] = idUserApp;
    _data['id_conducteur'] = idConducteur;
    _data['depart_name'] = departName;
    _data['destination_name'] = destinationName;
    _data['latitude_depart'] = latitudeDepart;
    _data['longitude_depart'] = longitudeDepart;
    _data['latitude_arrivee'] = latitudeArrivee;
    _data['longitude_arrivee'] = longitudeArrivee;
    _data['stops'] = stops;
    _data['place'] = place;
    _data['number_poeple'] = numberPoeple;
    _data['distance'] = distance;
    _data['distance_unit'] = distanceUnit;
    _data['duree'] = duree;
    _data['montant'] = montant;
    _data['tip_amount'] = tipAmount;
    _data['tax'] = tax;
    _data['discount'] = discount;
    _data['admin_commission'] = adminCommission;
    _data['transaction_id'] = transactionId;
    _data['trajet'] = trajet;
    _data['statut'] = statut;
    _data['statut_paiement'] = statutPaiement;
    _data['id_payment_method'] = idPaymentMethod;
    _data['creer'] = creer;
    _data['modifier'] = modifier;
    _data['date_retour'] = dateRetour;
    _data['heure_retour'] = heureRetour;
    _data['statut_round'] = statutRound;
    _data['statut_course'] = statutCourse;
    _data['id_conducteur_accepter'] = idConducteurAccepter;
    _data['trip_objective'] = tripObjective;
    _data['trip_category'] = tripCategory;
    _data['age_children1'] = ageChildren1;
    _data['age_children2'] = ageChildren2;
    _data['age_children3'] = ageChildren3;
    _data['feel_safe'] = feelSafe;
    _data['feel_safe_driver'] = feelSafeDriver;
    _data['car_driver_confirmed'] = carDriverConfirmed;
    _data['otp'] = otp;
    _data['otp_created'] = otpCreated;
    _data['deleted_at'] = deletedAt;
    _data['updated_at'] = updatedAt;
    _data['dispatcher_id'] = dispatcherId;
    _data['ride_type'] = rideType;
    _data['user_info'] = userInfo;
    _data['rejected_driver_id'] = rejectedDriverId;
    _data['ride_date'] = rideDate;
    _data['rider_firebase_id'] = riderFirebaseId;
    _data['drive_firebase_id'] = driveFirebaseId;
    _data['driver_live_latitude'] = driverLiveLatitude;
    _data['driver_live_longitude'] = driverLiveLongitude;
    _data['applied_taxes'] = appliedTaxes;
    _data['tax_amount'] = taxAmount;
    _data['payment_intent_id'] = paymentIntentId;
    _data['vehicle_id'] = vehicleId;
    _data['zone_id'] = zoneId;
    _data['base_amount'] = baseAmount;
    _data['session_id'] = sessionId;
    _data['driver_payment'] = driverPayment;
    _data['payment_method'] = paymentMethod;
    _data['amount'] = amount;
    _data['amount_driver'] = amountDriver;
    return _data;
  }
}

class Stops {
  String? latitude;
  String? location;
  String? longitude;

  Stops({this.latitude, this.location, this.longitude});

  Stops.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'].toString();
    location = json['location'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['location'] = location;
    data['longitude'] = longitude;
    return data;
  }
}