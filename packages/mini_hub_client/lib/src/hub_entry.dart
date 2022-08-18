import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hub_entry.g.dart';

/// {@template hub_entry}
/// Model representing a hub entry.
/// {@endtemplate}
@JsonSerializable()
class HubEntry extends Equatable {
  /// {@macro hub_entry}
  const HubEntry({
    required this.name,
    required this.description,
    required this.data,
    required this.thumb,
    required this.gridSize,
    required this.author,
  });

  /// {@macro hub_entry}
  factory HubEntry.fromJson(Map<String, dynamic> json) =>
      _$HubEntryFromJson(json);

  /// This as a json.
  Map<String, dynamic> toJson() => _$HubEntryToJson(this);

  /// The name of the entry.
  final String name;

  /// The description of the entry.
  final String description;

  /// The thumbnail of the entry.
  final String thumb;

  /// The data of the entry.
  final String data;

  /// The grid size of the entry.
  final int gridSize;

  /// The author of the entry.
  final String author;

  @override
  List<Object?> get props => [
        name,
        description,
        data,
        thumb,
        gridSize,
        author,
      ];
}
