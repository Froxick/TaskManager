import 'package:flutter/material.dart';
import 'package:frontend/features/auth/auth_notifier.dart';
import 'package:frontend/features/user/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/theme/colors.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'TaskFlow',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _NavItem(
            title: 'Доска',
            route: '/',
            isActive: location == '/',
            icon: Icons.dashboard_outlined,
          ),
          _NavItem(
            title: 'Проекты',
            route: '/projects',
            isActive: location == '/projects',
            icon: Icons.folder_outlined,
          ),
          const Spacer(),
          _UserItem()
        ],
      ),
    );
  }
}

class _UserItem extends StatefulWidget {
  const _UserItem();

  @override
  State<_UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<_UserItem> {
  final controller = Get.find<UserController>();
  bool isHoveringUser = false;
  bool isHoveringLogout = false;

  Future<void> logoutUser() async {
    try {
      await controller.logoutUser();
      authNotifier.value = false;
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => isHoveringUser = true),
              onExit: (_) => setState(() => isHoveringUser = false),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      color:
                          isHoveringUser ? AppColors.hover : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() {
                      if (controller.loading.value) {
                        return const Text('...');
                      }

                      return Text(controller.user.value?.name ?? 'Без имени');
                    })),
              ),
            ),
          ),
          const SizedBox(width: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => isHoveringLogout = true),
            onExit: (_) => setState(() => isHoveringLogout = false),
            child: GestureDetector(
              onTap: logoutUser,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      isHoveringLogout ? AppColors.hover : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final String route;
  final bool isActive;
  final IconData icon;

  const _NavItem({
    required this.title,
    required this.route,
    required this.isActive,
    required this.icon,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;

    return MouseRegion(
      cursor: isActive ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.selected
                : isHovering
                    ? AppColors.hover
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
