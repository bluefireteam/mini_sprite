import 'package:dio/dio.dart';
import 'package:mini_hub_client/mini_hub_client.dart';

/// {@template mini_hub_client}
/// A dart client that provides access to the mini sprite hub API
/// {@endtemplate}
class MiniHubClient {
  /// {@macro mini_hub_client}
  const MiniHubClient({
    this.apiUrl = 'https://bluefireteam.github.io/mini_hub',
  });

  /// The url of the api.
  final String apiUrl;

  /// Returns the search result.
  Future<List<HubEntryResult>> listEntries(String? query) async {
    final response = await Dio().get<List<dynamic>>('$apiUrl/index.json');

    return response.data
            ?.map(
              (data) => HubEntryResult.fromJson(data as Map<String, dynamic>),
            )
            .toList()
            .cast<HubEntryResult>() ??
        [];
  }

  /// Returns an entry.
  Future<HubEntry?> fetchEntry(String path) async {
    final response = await Dio().get<Map<String, dynamic>>('$apiUrl/$path');

    final data = response.data;
    if (data == null) {
      return null;
    }

    return HubEntry.fromJson(data);
  }
}
