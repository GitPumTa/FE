import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RankingView extends StatelessWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        title: Text(
          '랭킹',
          style: GoogleFonts.audiowide(fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '랭킹 화면입니다',
          style: GoogleFonts.audiowide(fontSize: 16),
        ),
      ),
    );
  }
}
