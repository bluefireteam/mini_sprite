// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_entry_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubEntryResult _$HubEntryResultFromJson(Map<String, dynamic> json) =>
    HubEntryResult(
      name: json['name'] as String,
      description: json['description'] as String,
      path: json['path'] as String,
    );

Map<String, dynamic> _$HubEntryResultToJson(HubEntryResult instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'path': instance.path,
    };
