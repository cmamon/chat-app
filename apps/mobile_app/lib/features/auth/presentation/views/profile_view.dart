import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kora_chat/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:kora_chat/l10n/generated/translations.g.dart';
import 'package:kora_chat/theme/kora_design_system.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kora_chat/theme/kora_components.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.currentUser;
    final t = Translations.of(context);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: KoraColors.background,
      appBar: AppBar(
        title: Text(t.profile.profileTitle),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAvatar(context, ref, user.avatarUrl, user.username),
            const SizedBox(height: 16),
            Text(user.username, style: KoraTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: KoraTextStyles.bodyMedium.copyWith(
                color: KoraColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            _buildSection(t.profile.personalInfo, [
              _buildInfoTile(
                t.profile.username,
                user.username,
                Icons.person_outline,
              ),
              _buildInfoTile(t.profile.email, user.email, Icons.email_outlined),
            ]),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context, ref, t),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  t.profile.logout,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    WidgetRef ref,
    String? url,
    String username,
  ) {
    final isLoading = ref.watch(authViewModelProvider).isLoading;

    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              final picker = ImagePicker();
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                ref.read(authViewModelProvider.notifier).uploadAvatar(image);
              }
            },
      child: Stack(
        children: [
          KoraAvatar(imageUrl: url, size: 120, placeholder: username),
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: KoraColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: KoraTextStyles.bodySmall.copyWith(
              color: KoraColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: KoraColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: KoraColors.primary),
      title: Text(
        label,
        style: KoraTextStyles.bodySmall.copyWith(
          color: KoraColors.textSecondary,
        ),
      ),
      subtitle: Text(value, style: KoraTextStyles.bodyLarge),
      trailing: const Icon(
        Icons.chevron_right,
        color: KoraColors.textSecondary,
      ),
      onTap: () {
        // TODO: Edit field
      },
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, dynamic t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.profile.logout),
        content: Text(t.profile.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.profile.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authViewModelProvider.notifier).logout();
            },
            child: Text(
              t.profile.logout,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
