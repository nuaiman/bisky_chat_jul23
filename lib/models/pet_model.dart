import 'dart:convert';

import 'package:flutter/foundation.dart';

enum PetType {
  all('all'),
  cat('cat'),
  dog('dog'),
  bird('bird'),
  rabbit('rabbit'),
  aquatic('aquatic'),
  rodent('rodent'),
  domestic('domestic'),
  reptile('reptile'),
  others('others');

  final String type;
  const PetType(this.type);
}

extension ConvertPet on String {
  PetType toPetTypeEnum() {
    switch (this) {
      case 'others':
        return PetType.others;
      case 'cat':
        return PetType.cat;
      case 'dog':
        return PetType.dog;
      case 'rodent':
        return PetType.rodent;
      case 'bird':
        return PetType.bird;
      case 'domestic':
        return PetType.domestic;
      case 'reptile':
        return PetType.reptile;
      case 'rabbit':
        return PetType.rabbit;
      case 'aquatic':
        return PetType.aquatic;
      default:
        return PetType.cat;
    }
  }
}

// -----------------------------------------------------------------------------
enum GenderType {
  male('male'),
  female('female');

  final String type;
  const GenderType(this.type);
}

extension ConvertGender on String {
  GenderType toGenderTypeEnum() {
    switch (this) {
      case 'male':
        return GenderType.male;
      case 'female':
        return GenderType.female;
      default:
        return GenderType.male;
    }
  }
}
// -----------------------------------------------------------------------------

class PetModel {
  final String id;
  final String uid;
  final String userImage;
  final String userName;
  final PetType petType;
  final GenderType genderType;
  final String name;
  final String breedName;
  final String color;
  final String city;
  final String country;
  final String about;
  final List<String> images;
  final List<String> likes;
  final int years;
  final int months;
  final bool spayed;
  final bool pottyTrained;
  final double weight;
  final double lat;
  final double lon;
  final double distance;
  final DateTime postedAt;
  PetModel({
    required this.id,
    required this.uid,
    required this.userImage,
    required this.userName,
    required this.petType,
    required this.genderType,
    required this.name,
    required this.breedName,
    required this.color,
    required this.city,
    required this.country,
    required this.about,
    required this.images,
    required this.likes,
    required this.years,
    required this.months,
    required this.spayed,
    required this.pottyTrained,
    required this.weight,
    required this.lat,
    required this.lon,
    required this.distance,
    required this.postedAt,
  });

  PetModel copyWith({
    String? id,
    String? uid,
    String? userImage,
    String? userName,
    PetType? petType,
    GenderType? genderType,
    String? name,
    String? breedName,
    String? color,
    String? city,
    String? country,
    String? about,
    List<String>? images,
    List<String>? likes,
    int? years,
    int? months,
    bool? spayed,
    bool? pottyTrained,
    double? weight,
    double? lat,
    double? lon,
    double? distance,
    DateTime? postedAt,
  }) {
    return PetModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      petType: petType ?? this.petType,
      genderType: genderType ?? this.genderType,
      name: name ?? this.name,
      breedName: breedName ?? this.breedName,
      color: color ?? this.color,
      city: city ?? this.city,
      country: country ?? this.country,
      about: about ?? this.about,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      years: years ?? this.years,
      months: months ?? this.months,
      spayed: spayed ?? this.spayed,
      pottyTrained: pottyTrained ?? this.pottyTrained,
      weight: weight ?? this.weight,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      distance: distance ?? this.distance,
      postedAt: postedAt ?? this.postedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    // result.addAll({'id': id});
    result.addAll({'uid': uid});
    result.addAll({'userImage': userImage});
    result.addAll({'userName': userName});
    result.addAll({'petType': petType.type});
    result.addAll({'genderType': genderType.type});
    result.addAll({'name': name});
    result.addAll({'breedName': breedName});
    result.addAll({'color': color});
    result.addAll({'city': city});
    result.addAll({'country': country});
    result.addAll({'about': about});
    result.addAll({'images': images});
    result.addAll({'likes': likes});
    result.addAll({'years': years});
    result.addAll({'months': months});
    result.addAll({'spayed': spayed});
    result.addAll({'pottyTrained': pottyTrained});
    result.addAll({'weight': weight});
    result.addAll({'lat': lat});
    result.addAll({'lon': lon});
    result.addAll({'distance': distance});
    result.addAll({'postedAt': postedAt.millisecondsSinceEpoch});

    return result;
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['\$id'] ?? '',
      uid: map['uid'] ?? '',
      userImage: map['userImage'] ?? '',
      userName: map['userName'] ?? '',
      petType: (map['petType'] as String).toPetTypeEnum(),
      genderType: (map['genderType'] as String).toGenderTypeEnum(),
      name: map['name'] ?? '',
      breedName: map['breedName'] ?? '',
      color: map['color'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      about: map['about'] ?? '',
      images: List<String>.from(map['images']),
      likes: List<String>.from(map['likes']),
      years: map['years']?.toInt() ?? 0,
      months: map['months']?.toInt() ?? 0,
      spayed: map['spayed'] ?? false,
      pottyTrained: map['pottyTrained'] ?? false,
      weight: map['weight']?.toDouble() ?? 0.0,
      lat: map['lat']?.toDouble() ?? 0.0,
      lon: map['lon']?.toDouble() ?? 0.0,
      distance: map['distance']?.toDouble() ?? 0.0,
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PetModel(id: $id, uid: $uid, userImage: $userImage, userName: $userName, petType: $petType, genderType: $genderType, name: $name, breedName: $breedName, color: $color, city: $city, country: $country, about: $about, images: $images, likes: $likes, years: $years, months: $months, spayed: $spayed, pottyTrained: $pottyTrained, weight: $weight, lat: $lat, lon: $lon, distance: $distance, postedAt: $postedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PetModel &&
        other.id == id &&
        other.uid == uid &&
        other.userImage == userImage &&
        other.userName == userName &&
        other.petType == petType &&
        other.genderType == genderType &&
        other.name == name &&
        other.breedName == breedName &&
        other.color == color &&
        other.city == city &&
        other.country == country &&
        other.about == about &&
        listEquals(other.images, images) &&
        listEquals(other.likes, likes) &&
        other.years == years &&
        other.months == months &&
        other.spayed == spayed &&
        other.pottyTrained == pottyTrained &&
        other.weight == weight &&
        other.lat == lat &&
        other.lon == lon &&
        other.distance == distance &&
        other.postedAt == postedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        userImage.hashCode ^
        userName.hashCode ^
        petType.hashCode ^
        genderType.hashCode ^
        name.hashCode ^
        breedName.hashCode ^
        color.hashCode ^
        city.hashCode ^
        country.hashCode ^
        about.hashCode ^
        images.hashCode ^
        likes.hashCode ^
        years.hashCode ^
        months.hashCode ^
        spayed.hashCode ^
        pottyTrained.hashCode ^
        weight.hashCode ^
        lat.hashCode ^
        lon.hashCode ^
        distance.hashCode ^
        postedAt.hashCode;
  }
}
