import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/commit.dart';
import '../models/repo.dart';

import '../routes/app_route.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

enum TabType { timer, group }

class HomeController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;

  HomeController({required this.apiService, required this.tokenService});

  Rx<TabType> selected = TabType.timer.obs;

  RxList<Repo> repos = <Repo>[].obs;
  RxList<Commit> commits = <Commit>[].obs;

  RxnString activeRepoId = RxnString(null);
  RxnString activeRepoAddress = RxnString(null);
  final RxString repoValidationMessage = ''.obs; // 오류 메시지용
  final Rx<DateTime> currentTime = DateTime.now().obs;

  Timer? _timer;

  final repoTitleController = TextEditingController();
  final repoDescriptionController = TextEditingController();
  final repoAddressController = TextEditingController();

  final RxBool gitAddressApproved = false.obs;

  Duration get totalDuration =>
      repos.fold(Duration.zero, (sum, r) => sum + r.duration);

  @override
  onInit() {
    super.onInit();
    fetchRepo();
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    stopTimer(activeRepoId.value);
  }

  void toggle(TabType type) {
    selected.value = type;
  }

  Alignment get alignment {
    return selected.value == TabType.timer
        ? Alignment.centerLeft
        : Alignment.centerRight;
  }

  Future<void> fetchRepo() async {
    final token = await tokenService.getToken();

    final response = await http.get(
      Uri.parse('http://15.164.49.227:8080/main?account_id=${token.username}'),
      // Uri.parse('http://15.164.49.227:8080/ranking/user'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> repoList = decoded['repos'];

      repos.assignAll(repoList.map((e) => Repo.fromJson(e)).toList());

      print(decoded['message']); // "정상적으로 repo list 를 로드하였습니다."
    } else {
      throw Exception('레포 불러오기 실패: ${response.statusCode}');
    }
  }

  Future<void> fetchRowCommit(String address) async {
    final gitToken = await tokenService.getGithubToken();
    final username = await tokenService.getUsername();

    final response = await http.get(
      // Uri.parse('https://api.github.com/repos/tesupark/lifesam_random_pop/commits'),
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $gitToken',
      },
    );
    final body = jsonDecode(response.body);
    final name = body['name'];
    final repoUrl = convertGitHubUrlToApi(address);
    final commitResponse = await http.get(
      Uri.parse(repoUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $gitToken',
      },
    );
    if (commitResponse.statusCode != 200) {
      print('❌ Error: ${commitResponse.statusCode}');
      return;
    }

    final List<dynamic> commitsJson = jsonDecode(commitResponse.body);

    // Clear old data
    commits.clear();

    for (final item in commitsJson) {
      final authorName = item['commit']['author']['name'];
      final commit = Commit.fromJson(item);
      final commitDate = commit.date.toLocal();

      final now = DateTime.now();
      final isToday = commitDate.year == now.year &&
          commitDate.month == now.month &&
          commitDate.day == now.day;

      if (authorName == name && isToday) {
        commits.add(commit);
      }
    }
    // repo의 git address 로 api 요청 및, commit 리스트 반환, 갯수 반환 및 타이머 실행동안 커밋 수 확인 및 리더보드 등록 요청 보내기.
    final currentPlannerId = activeRepoId.value;
    final body2 = {
      'user_id': username,
      'planner_id' : currentPlannerId,
      'commits' : commits.map((c) => c.toJson()).toList(),
    };
    final response2 = await http.post(
      Uri.parse('http://15.164.49.227:8080/commit/update'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        body2
      )
    );
  }

  Future<void> timer() async {
    final token = await tokenService.getToken();
    final now = DateTime.now().toIso8601String();
    final repo = repos.firstWhereOrNull((r) => r.id == activeRepoId.value);
    final status = repo?.status == TimerStatus.running ? 0 : 1;

    final body = {
      'account_id': token.username,
      'send_at': now,
      'status': status,
      'total_duration': totalDuration.inSeconds,
      'repos': repos.map((r) => r.toJson()).toList(),
    };
    print(body);
    final response = await http.post(
      Uri.parse('http://15.164.49.227:8080/main/timer'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body)
    );
    print(response.body);
  }

  Future<void> makeNewRepo() async {
    // repoTitleController, repoDescriptionController, repoAddressController 내용을 가지고 fetch 작업을 할거임.
    await Future.delayed(Duration(seconds: 1));
    final repoTitle = repoTitleController.text;
    final repoDescription = repoDescriptionController.text;
    final repoAddress = repoAddressController.text;
    final username = await tokenService.getUsername();
    print({
      'user_id': username,
      'name': repoTitle,
      'description': repoDescription,
      'repository_link': repoAddress,
    });
    if (repoTitle.isNotEmpty && repoDescription.isNotEmpty && repoAddress.isNotEmpty && gitAddressApproved.value) {
      final response = await http.post(
        Uri.parse('http://15.164.49.227:8080/planner/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': username,
          'name': repoTitle,
          'description': repoDescription,
          'repository_link': repoAddress,
        })
      );
      repoTitleController.clear();
      repoDescriptionController.clear();
      repoAddressController.clear();
      gitAddressApproved.value = false;
      repoValidationMessage.value = '';
      Get.toNamed(AppRoutes.home);
      return;
    }
    else {
      Get.snackbar('오류', "양식을 모두 채워주세요");
      return;
    }
  }

  Future<void> approveRepoAddress() async {
    final address = repoAddressController.text.trim();

    // 빈 값 검증
    if (address.isEmpty) {
      repoValidationMessage.value = '주소를 입력해주세요.';
      return;
    }

    repoValidationMessage.value = '검사 중...';

    final exists = await checkRepoExists(address);

    if (exists) {
      gitAddressApproved.value = true;
      repoValidationMessage.value = '✅ 유효한 레포입니다.';
      print('✅ 유효한 레포입니다.');
    } else {
      gitAddressApproved.value = false;
      repoValidationMessage.value = '❌ 존재하지 않는 레포입니다.';
      print('❌ 존재하지 않는 레포입니다.');
    }
  }


  void startTimerFor(String repoId) {
    // 완전 처음일 때, 맨 처음 시작 시간(start at)(맨 처음 시작한 시간으로 커밋 데이터 자를 예정)
    // 시작 시간(send at), total duration, 상태(start), repos 서버에 전송.
    if (_timer != null && activeRepoId.value != null) {
      final prevIndex = repos.indexWhere((r) => r.id == activeRepoId.value);
      if (prevIndex != -1) {
        repos[prevIndex] = repos[prevIndex].copyWith(
          status: TimerStatus.paused,
        );
      }
      _timer!.cancel();
    }
    activeRepoId = RxnString(repoId);
    final index = repos.indexWhere((r) => r.id == repoId);
    if (index == -1) return;
    activeRepoAddress = RxnString(repos[index].repoAddress);
    final address = repos[index].repoAddress;
    fetchRowCommit(address);
    timer();
    repos[index] = repos[index].copyWith(status: TimerStatus.running);
    repos.refresh();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final i = repos.indexWhere((r) => r.id == activeRepoId.value);
      if (i != -1) {
        final updated = repos[i].copyWith(
          duration: repos[i].duration + Duration(seconds: 1),
        );
        repos[i] = updated;
        repos.refresh();
      }
    });
  }

  void pauseTimer() {
    // 일시 정지 시간(send at), total duration, 상태(pause), repos 서버에 전송.
    if (activeRepoId.value == null) return;

    final index = repos.indexWhere((r) => r.id == activeRepoId.value);
    if (index != -1) {
      repos[index] = repos[index].copyWith(status: TimerStatus.paused);
      repos.refresh();
    }

    _timer?.cancel();
    _timer = null;
    timer();
  }

  void toggleTimer(Repo repo) {
    if (activeRepoId.value == repo.id) {
      if (repo.status == TimerStatus.running) {
        pauseTimer();
        return;
      }
      if (repo.status == TimerStatus.paused) {
        startTimerFor(repo.id);
        return;
      }
    } else {
      stopTimer(activeRepoId.value);
      startTimerFor(repo.id);
    }
  }

  void stopTimer(String? repoId) {
    // 종료 시간(send_at), total_duration, 상태(stop), repos 서버에 전송.
    if (repoId == null) return;
    if (activeRepoId.value == repoId) {
      _timer?.cancel();
      _timer = null;
      activeRepoId = RxnString(null);
    }
    final index = repos.indexWhere((r) => r.id == repoId);
    if (index != -1) {
      repos[index] = repos[index].copyWith(status: TimerStatus.stopped);
      repos.refresh();
    }
    timer();
    commits.clear();
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
  //
  // double barPercent(DurationLeader leader) {
  //   final top = ranking.value.durationLeaders.first.duration.inSeconds;
  //   return (leader.duration.inSeconds / top).clamp(0.0, 1.0);
  // }

  String formatDateTime(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year.$month.$day';
  }

  String convertGitHubUrlToApi(String url) {
    // .git 제거
    if (url.endsWith('.git')) {
      url = url.substring(0, url.length - 4);
    }

    // Uri 파싱
    final uri = Uri.parse(url);

    // 유효성 검사
    if (uri.host != 'github.com') {
      throw FormatException('올바른 GitHub URL이 아닙니다.');
    }

    // 경로에서 owner/repo 추출
    final segments = uri.pathSegments;
    if (segments.length < 2) {
      throw FormatException('URL 경로가 너무 짧습니다. (예: /owner/repo)');
    }

    final owner = segments[0];
    final repo = segments[1];

    return 'https://api.github.com/repos/$owner/$repo/commits';
  }
  String shortenText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  Future<bool> checkRepoExists(String url, {String? token}) async {
    // .git 제거
    if (url.endsWith('.git')) {
      url = url.substring(0, url.length - 4);
    }

    final uri = Uri.tryParse(url);
    if (uri == null || uri.host != 'github.com') return false;

    final segments = uri.pathSegments;
    if (segments.length < 2) return false;

    final owner = segments[0];
    final repo = segments[1];
    final apiUrl = 'https://api.github.com/repos/$owner/$repo';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: token != null
          ? {'Authorization': 'Bearer $token'}
          : {},
    );

    return response.statusCode == 200;
  }

}
