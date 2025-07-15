import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../routes/app_route.dart';

class HomeAddRepoView extends GetView<HomeController> {
  const HomeAddRepoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        title: Text('Add Repo'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Repo 이름",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffff8126),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    controller: controller.repoTitleController,
                    decoration: InputDecoration(
                      hintText: "ex) C++",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Repo 설명",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffff8126),
                    ),
                  ),
                  TextField(
                    controller: controller.repoDescriptionController,
                    decoration: InputDecoration(
                      hintText: "ex) 하루에 커밋 하나만!",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      controller.gitAddressApproved.value
                          ? Color(0xffd9d9d9)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x20000000),
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Repo 주소",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.gitAddressApproved.value ? Colors.white : Color(0xffff8126),
                      ),
                    ),
                    TextField(
                      controller: controller.repoAddressController,
                      enabled: !controller.gitAddressApproved.value,
                      decoration: InputDecoration(
                        hintText: "https://github.com/...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    controller.gitAddressApproved.value
                        ? SizedBox.shrink()
                        : Center(
                      child: ElevatedButton(
                        onPressed: () => controller.approveRepoAddress(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffff8126),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        ),
                        child: Text(
                          "주소 확인",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    controller.gitAddressApproved.value
                        ? Center(child: Text("확인되었습니다.", style: TextStyle(color: Colors.white)))
                        : Center(child: Text("github 주소를 확인해주세요.", style: TextStyle(color: Color(0xffff8126)))),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.home),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "취소",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.makeNewRepo(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffff8126),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "저장",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
