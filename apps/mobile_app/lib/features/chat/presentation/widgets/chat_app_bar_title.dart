import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kora_chat/theme/kora_design_system.dart';

import 'package:kora_chat/theme/kora_components.dart';

class ChatAppBarTitle extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final String status;

  const ChatAppBarTitle({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        KoraAvatar(imageUrl: avatarUrl, size: 36, placeholder: name),
        const SizedBox(width: KoraSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 12,
                  color: KoraColors.primaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
