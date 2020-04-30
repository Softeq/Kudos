import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class GoogleApiService {

  Future<void> getContact(AuthService auth, logger) async {

    logger("Loading contact info...");

    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await auth.authHeaders,
    );

    if (response.statusCode != 200) {
      logger("People API gave a ${response.statusCode} response. "
          "Check logs for details.");
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);

    logger(
      namedContact != null
        ? "I see you know $namedContact!"
        : "No contacts to display."
    );
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }
}