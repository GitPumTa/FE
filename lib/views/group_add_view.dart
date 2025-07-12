// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/group_controller.dart';
//
// class GroupAddView extends GetView<GroupController> {
//   const GroupAddView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('그룹 추가'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text('그룹 추가'),
//       )
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/group_controller.dart';

class GroupAddView extends GetView<GroupController> {
  const GroupAddView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final maxController = TextEditingController();
    final rulesController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffafafa),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          '그룹 만들기',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "스터디 그룹을\n만들어주세요.",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _buildCardField(label: '그룹명', controller: nameController),
              const SizedBox(height: 16),
              _buildCardField(label: '그룹 소개', controller: descController),
              const SizedBox(height: 16),
              _buildCardField(
                label: '최대 인원',
                controller: maxController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildCardField(
                label: '그룹 규칙',
                controller: rulesController,
                maxLines: 6,
                isMultiline: true,
              ),
              const SizedBox(height: 16),
              _buildCardField(
                label: '비밀 번호',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  // 취소 버튼
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 50,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF868583),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '취소',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // 생성하기 버튼
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.addGroup(
                          name: nameController.text,
                          description: descController.text,
                          maxMembers: int.tryParse(maxController.text) ?? 50,
                          rules: rulesController.text
                              .split('\n')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList(),
                          password: passwordController.text,
                        );
                        Get.back();
                        Get.snackbar('성공', '그룹이 생성되었습니다');
                      },
                      child: Container(
                        height: 50,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFF8126),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              '생성하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Pretendard Variable',
                                fontWeight: FontWeight.w700,
                                height: 1.67,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    bool obscureText = false,
    bool isMultiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xffff8126),
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: isMultiline ? TextInputType.multiline : inputType,
            maxLines: isMultiline ? null : maxLines,
            obscureText: obscureText,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '입력해주세요',
              hintStyle: TextStyle(
                color: Color(0xFF868583),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}