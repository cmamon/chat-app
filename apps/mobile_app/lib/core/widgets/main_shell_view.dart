import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kora_chat/config/routes.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:kora_chat/features/home/presentation/views/home_view.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class MainShellView extends ConsumerWidget {
  final Widget child;
  final String? selectedChatId;

  const MainShellView({super.key, required this.child, this.selectedChatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          final currentPath = GoRouterState.of(context).matchedLocation;
          final isProfile = currentPath.startsWith(AppRoutes.profile.path);

          return Scaffold(
            backgroundColor: KoraColors.background,
            body: Row(
              children: [
                // Navigation Sidebar
                _buildSidebar(context, ref),

                // Chat List (Master) - Show only if not on profile page
                if (!isProfile) ...[
                  const SizedBox(width: 350, child: HomeView(isEmbedded: true)),
                  const VerticalDivider(width: 1, color: KoraColors.surface),
                ],

                // Content (Detail)
                Expanded(child: child),
              ],
            ),
          );
        }

        // Mobile Layout: standard Scaffold with bottom nav or drawer if needed
        return Scaffold(
          body: child,
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 80,
      color: KoraColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _SidebarItem(
            icon: Icons.chat_bubble_outline,
            isSelected:
                currentPath.startsWith('/home') ||
                currentPath.startsWith('/chat'),
            onTap: () => context.go(AppRoutes.home.path),
          ),
          _SidebarItem(
            icon: Icons.add_circle_outline,
            isSelected: currentPath.startsWith('/search'),
            onTap: () => context.go(AppRoutes.search.path),
          ),
          _SidebarItem(
            icon: Icons.person_outline,
            isSelected: currentPath.startsWith('/profile'),
            onTap: () => context.go(AppRoutes.profile.path),
          ),
          const Spacer(),
          _SidebarItem(
            icon: Icons.logout_outlined,
            isSelected: false,
            onTap: () => ref.read(authViewModelProvider.notifier).logout(),
          ),
          _SidebarItem(
            icon: Icons.settings_outlined,
            isSelected: false,
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget? _buildBottomNav(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;

    // Hide bottom nav on mobile for chat details and search
    if (currentPath.startsWith('/chat/') || currentPath.startsWith('/search')) {
      return null;
    }

    int currentIndex = 0;
    if (currentPath.startsWith('/profile')) {
      currentIndex = 1;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: KoraColors.surface,
      selectedItemColor: KoraColors.primaryLight,
      unselectedItemColor: KoraColors.textSecondary,
      onTap: (index) {
        if (index == 0) context.go(AppRoutes.home.path);
        if (index == 1) context.go(AppRoutes.profile.path);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected
                ? KoraColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? KoraColors.primaryLight
                : KoraColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
