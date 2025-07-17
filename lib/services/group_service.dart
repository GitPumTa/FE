import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/group.dart';
import '../models/ranking.dart';

class GroupService {
  final String baseUrl = 'http://15.164.49.227:8080';

  Future<List<Group>> fetchGroups(String userId) async {
    final url = Uri.parse('$baseUrl/group/list?id=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];

      return data.map((json) {
        return Group(
          id: json['id'] ?? '',
          name: json['name'] ?? '',
          description: json['description'] ?? '',
          currentMembers: json['memberCnt'] ?? 0,
          maxMembers: json['capacity'] ?? 0,
          rules: [],
          password: '',
          isActive: true,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch groups: ${response.statusCode}');
    }
  }

  Future<List<Group>> fetchMyGroups(String userId) async {
    final url = Uri.parse('http://15.164.49.227:8080/group/myGroupList?userId=$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final groupList = data['groups'] as List<dynamic>;

      return groupList.map((e) => Group.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load my groups');
    }
  }


  Future<Map<String, dynamic>> joinGroup({
    required String groupId,
    required String userId,
    required String password,
  }) async {
    final url = Uri.parse('http://15.164.49.227:8080/group/join');

    final body = {
      'groupId': groupId,
      'password': password,
      'userId': userId,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': data['message'] ?? '가입 성공',
      };
    } else {
      return {
        'success': false,
        'message': data['error'] ?? '가입 실패',
      };
    }
  }

  Future<Group?> addGroup({
    required String userId,
    required String name,
    required String description,
    required int maxMembers,
    required List<String> rules,
    required String password,
  }) async {
    final url = Uri.parse('http://15.164.49.227:8080/group/create');

    final body = {
      "userId": userId,
      "name": name,
      "description": description,
      "capacity": maxMembers,
      "rule": rules,
      "password": password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return Group(
          id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          description: description,
          currentMembers: 1,
          maxMembers: maxMembers,
          rules: rules,
          password: password,
          isActive: true,
        );
      } else {
        if (kDebugMode) {
          print('[GROUP CREATE FAILED] ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('[GROUP CREATE ERROR] $e');
      }
      return null;
    }
  }

  Future<Ranking> fetchGroupRanking({
    required String accountId,
    required String groupId,
  }) async {
    final url = Uri.parse('http://15.164.49.227:8080/main/group?account_id=$accountId&group_id=$groupId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Ranking(
        myName: data['my_name'],
        myRank: data['my_rank'],
        myMonitoringGroup: data['my_monitoring_group'],
        myMonitoringGroupDescription: data['my_monitoring_group_description'],
        durationLeaders: (data['duration_leaders'] as List).map((e) => DurationLeader.fromJson(e)).toList(),
        commitLeaders: (data['commit_leaders'] as List).map((e) => CommitLeader.fromJson(e)).toList(),
      );
    } else {
      throw Exception('Failed to load group ranking');
    }
  }



}
