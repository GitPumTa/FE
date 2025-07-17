import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitpumta/models/repo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/home_controller.dart';
import '../models/commit.dart';
import '../routes/app_route.dart';

class HomeTimerView extends GetView<HomeController> {
  const HomeTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Obx(() {
            final activeId = controller.activeRepoId.value;
            final repo = controller.repos.firstWhereOrNull(
              (r) => r.id == activeId,
            );

            if (repo == null) {
              // 아무것도 선택 안 된 상태
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      controller.formatDuration(controller.totalDuration),
                      style: TextStyle(fontSize: 36, color: Colors.black26),
                    ),
                  ],
                ),
              );
            }

            final isRunning = repo.status == TimerStatus.running;

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    repo.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    controller.formatDuration(controller.totalDuration),
                    style: TextStyle(
                      fontSize: 36,
                      color: isRunning ? Color(0xffff8126) : Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon:
                            isRunning
                                ? HugeIcons.strokeRoundedPause
                                : HugeIcons.strokeRoundedPlay,
                        color: Color(0xffff8126),
                        onPressed: () {
                          isRunning
                              ? controller.pauseTimer()
                              : controller.startTimerFor(repo.id);
                        },
                      ),
                      SizedBox(width: 16),
                      _buildControlButton(
                        icon: HugeIcons.strokeRoundedStop,
                        color: Colors.grey,
                        onPressed: () {
                          controller.stopTimer(repo.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 20),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.repos.length,
              itemBuilder: (context, index) {
                return _buildRepo(controller.repos[index]);
              },
            ),
          ),
          SizedBox(height: 20),
          Obx(() {
            final activeId = controller.activeRepoId.value;
            final repo = controller.repos.firstWhereOrNull(
              (r) => r.id == activeId,
            );

            final isInactive = repo == null;
            if (!isInactive) return const SizedBox.shrink();

            return ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.newRepo),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                elevation: 0,
                backgroundColor: const Color(0xffFF8126),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAddCircle,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Add Repo',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.audiowide().fontFamily,
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 5),
          Obx(() {
            final commits = controller.commits;
            if (commits.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${commits.length}개의 커밋',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed:
                              () => controller.fetchRowCommit(
                                controller.activeRepoAddress.value!,
                              ),
                          icon: Icon(HugeIcons.strokeRoundedRefresh),
                        ),
                      ],
                    )),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: commits.length,
                      itemBuilder: (context, index) {
                        final commit = commits[index];
                        return _buildCommit(commit);
                      },
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildCommit(Commit commit) {
    final message = controller.shortenText(commit.message, 50);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Color(0xffd9d9d9), thickness: 1),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
          message,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  Widget _buildRepo(Repo repo) {
    final bgColor = () {
      switch (repo.status) {
        case TimerStatus.running:
          return Color(0xffFF8126);
        case TimerStatus.paused:
          return Colors.grey;
        case TimerStatus.stopped:
          return Colors.white;
      }
    }();

    final icon = () {
      switch (repo.status) {
        case TimerStatus.running:
          return HugeIcons.strokeRoundedPauseCircle;
        case TimerStatus.paused:
          return HugeIcons.strokeRoundedPlayCircle;
        case TimerStatus.stopped:
          return HugeIcons.strokeRoundedPlayCircle;
      }
    }();

    return GestureDetector(
      onTap: () => controller.toggleTimer(repo),
      onLongPress: () => controller.stopTimer(repo.id), // 옵션
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    repo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          repo.status == TimerStatus.running ||
                                  repo.status == TimerStatus.paused
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    repo.subtitle,
                    style: TextStyle(
                      color:
                          repo.status == TimerStatus.running ||
                                  repo.status == TimerStatus.paused
                              ? Colors.white
                              : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              controller.formatDuration(repo.duration),
              style: TextStyle(
                color:
                    repo.status == TimerStatus.running ||
                            repo.status == TimerStatus.paused
                        ? Colors.white
                        : Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              icon,
              color:
                  repo.status == TimerStatus.running ||
                          repo.status == TimerStatus.paused
                      ? Colors.white
                      : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
