import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kora_chat/config/app_config.dart';
import 'kora_design_system.dart';

class KoraAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? placeholder;

  const KoraAvatar({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    String? fullUrl = imageUrl;
    if (imageUrl != null && imageUrl!.startsWith('/')) {
      fullUrl = '${AppConfig.apiBaseUrl}$imageUrl';
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: KoraColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: fullUrl != null && fullUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: fullUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPlaceholder(),
                errorWidget: (context, url, error) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Text(
        placeholder?.isNotEmpty == true ? placeholder![0].toUpperCase() : '?',
        style: GoogleFonts.outfit(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: KoraColors.primaryLight,
        ),
      ),
    );
  }
}

class KoraButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;

  const KoraButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: 56,
      decoration: BoxDecoration(
        gradient: onTap != null ? KoraColors.primaryGradient : null,
        color: onTap == null ? KoraColors.surfaceLight : null,
        borderRadius: BorderRadius.circular(KoraBorderRadius.lg),
        boxShadow: onTap != null
            ? [
                BoxShadow(
                  color: KoraColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(KoraBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: KoraSpacing.lg),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: KoraSpacing.sm),
                        ],
                        Text(
                          text,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: onTap != null
                                ? Colors.white
                                : KoraColors.textMuted,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class KoraCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const KoraCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KoraColors.surface,
        borderRadius: BorderRadius.circular(KoraBorderRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KoraBorderRadius.lg),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(KoraSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

class KoraTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;

  const KoraTextField({
    super.key,
    required this.label,
    this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  State<KoraTextField> createState() => _KoraTextFieldState();
}

class _KoraTextFieldState extends State<KoraTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: KoraColors.textSecondary,
          ),
        ),
        const SizedBox(height: KoraSpacing.sm),
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: GoogleFonts.outfit(color: Colors.white),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.outfit(color: KoraColors.textMuted),
            filled: true,
            fillColor: KoraColors.surface,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: KoraColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.all(KoraSpacing.md),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(KoraBorderRadius.md),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(KoraBorderRadius.md),
              borderSide: const BorderSide(color: KoraColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
