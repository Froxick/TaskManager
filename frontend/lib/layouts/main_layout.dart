import 'package:flutter/material.dart';
import 'package:frontend/features/user/controllers/user_controller.dart';
import 'package:frontend/layouts/nav_bar.dart';
import 'package:get/get.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();

    if (controller.user.value == null) {
      controller.getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [NavBar(), Expanded(child: widget.child)],
      ),
    );
  }
}
