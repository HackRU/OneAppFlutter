// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LcsCredential _$LcsCredentialFromJson(Map<String, dynamic> json) {
  return LcsCredential(
    json['email'] as String,
  );
}

Map<String, dynamic> _$LcsCredentialToJson(LcsCredential instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

HelpResource _$HelpResourceFromJson(Map<String, dynamic> json) {
  return HelpResource(
    json['name'] as String,
    json['desc'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$HelpResourceToJson(HelpResource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'desc': instance.description,
    };

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) {
  return Announcement(
    text: json['text'] as String,
    ts: json['ts'] as String,
  );
}

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'text': instance.text,
      'ts': instance.ts,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['email'] as String,
    Role.fromJson(json['role'] as Map<String, dynamic>),
    json['votes'] as int,
    json['github'] as String,
    json['major'] as String,
    json['short_answer'] as String,
    json['shirt_size'] as String,
    json['first_name'] as String,
    json['last_name'] as String,
    json['dietary_restrictions'] as String,
    json['special_needs'] as String,
    json['date_of_birth'] as String,
    json['school'] as String,
    json['grad_year'] as String,
    json['gender'] as String,
    json['registration_status'] as String,
    json['level_of_study'] as String,
    json['dayOf'] as Map<String, dynamic>,
  )..auth = (json['auth'] as List)
      .map((e) => Auth.fromJson(e as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'role': instance.role,
      'votes': instance.votes,
      'github': instance.github,
      'major': instance.major,
      'short_answer': instance.shortAnswer,
      'shirt_size': instance.shirtSize,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'dietary_restrictions': instance.dietaryRestrictions,
      'special_needs': instance.specialNeeds,
      'date_of_birth': instance.dateOfBirth,
      'school': instance.school,
      'grad_year': instance.gradYear,
      'gender': instance.gender,
      'registration_status': instance.registrationStatus,
      'level_of_study': instance.levelOfStudy,
      'dayOf': instance.dayOf,
      'auth': instance.auth,
    };

Role _$RoleFromJson(Map<String, dynamic> json) {
  return Role(
    json['hacker'] as bool,
    json['volunteer'] as bool,
    json['judge'] as bool,
    json['sponsor'] as bool,
    json['mentor'] as bool,
    json['organizer'] as bool,
    json['director'] as bool,
  );
}

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'hacker': instance.hacker,
      'volunteer': instance.volunteer,
      'judge': instance.judge,
      'sponsor': instance.sponsor,
      'mentor': instance.mentor,
      'organizer': instance.organizer,
      'director': instance.director,
    };

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return Auth(
    json['token'] as String,
    json['valid_until'] as String,
  );
}

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'token': instance.token,
      'valid_until': instance.validUntil,
    };
