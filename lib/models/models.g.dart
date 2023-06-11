// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnnouncementAdapter extends TypeAdapter<Announcement> {
  @override
  final int typeId = 0;

  @override
  Announcement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Announcement(
      text: fields[0] as String?,
      ts: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Announcement obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.ts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnouncementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LcsCredential _$LcsCredentialFromJson(Map<String, dynamic> json) =>
    LcsCredential(
      json['token'] as String,
    );

Map<String, dynamic> _$LcsCredentialToJson(LcsCredential instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

HelpResource _$HelpResourceFromJson(Map<String, dynamic> json) => HelpResource(
      json['name'] as String,
      json['desc'] as String,
      json['url'] as String,
    );

Map<String, dynamic> _$HelpResourceToJson(HelpResource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'desc': instance.description,
    };

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      text: json['text'] as String?,
      ts: json['ts'] as String?,
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'text': instance.text,
      'ts': instance.ts,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
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
      json['day_of'] as Map<String, dynamic>,
      (json['qrcode'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

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
      'day_of': instance.dayOf,
      'qrcode': instance.qrcode,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      json['hacker'] as bool,
      json['volunteer'] as bool,
      json['judge'] as bool,
      json['sponsor'] as bool,
      json['mentor'] as bool,
      json['organizer'] as bool,
      json['director'] as bool,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'hacker': instance.hacker,
      'volunteer': instance.volunteer,
      'judge': instance.judge,
      'sponsor': instance.sponsor,
      'mentor': instance.mentor,
      'organizer': instance.organizer,
      'director': instance.director,
    };

Auth _$AuthFromJson(Map<String, dynamic> json) => Auth(
      json['token'] as String,
      json['valid_until'] as String,
    );

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'token': instance.token,
      'valid_until': instance.validUntil,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      summary: json['summary'] as String?,
      location: json['location'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'summary': instance.summary,
      'location': instance.location,
      'start': instance.start?.toIso8601String(),
    };
