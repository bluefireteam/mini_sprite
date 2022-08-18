// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubEntry _$HubEntryFromJson(Map<String, dynamic> json) => HubEntry(
      name: json['name'] as String,
      description: json['description'] as String,
      data: json['data'] as String,
      thumb: json['thumb'] as String,
      gridSize: json['gridSize'] as int,
      author: json['author'] as String,
    );

Map<String, dynamic> _$HubEntryToJson(HubEntry instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'thumb': instance.thumb,
      'data': instance.data,
      'gridSize': instance.gridSize,
      'author': instance.author,
    };
