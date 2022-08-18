import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hub_entry_result.g.dart';

/// {@template hub_entry_result}
/// Model representing a hub entry resulted from a search.
/// {@endtemplate}
@JsonSerializable()
class HubEntryResult extends Equatable {
  /// {@macro hub_entry}
  const HubEntryResult({
    required this.name,
    required this.description,
    required this.path,
  });

  /// {@macro hub_entry_result}
  factory HubEntryResult.fromJson(Map<String, dynamic> json) =>
      _$HubEntryResultFromJson(json);

  /// This as a json.
  Map<String, dynamic> toJson() => _$HubEntryResultToJson(this);

  /// The name of the entry.
  final String name;

  /// The description of the entry.
  final String description;

  /// The path of the entry.
  final String path;

  @override
  List<Object?> get props => [
        name,
        description,
        path,
      ];
}
