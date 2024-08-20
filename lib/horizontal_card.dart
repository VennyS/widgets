import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widgets/custom_tag.dart';

class HorizontalCard extends StatelessWidget {
  final Widget? leadingVisuals;
  final bool showLeadingVisuals;
  final String? title;
  final bool showTitle;
  final String? subtitle;
  final bool showSubtitle;
  final List<CustomTag>? tags;
  final bool showtags;
  final Widget? preTrailingVisuals;
  final bool showPreTrailingVisual;
  final Widget? trailingControl;
  final bool showTrailingControl;
  final bool shouldBeRoundLeading;

  final double? width;
  final double? height;

  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const HorizontalCard(
      {super.key,
      this.showLeadingVisuals = true,
      this.title,
      this.showTitle = true,
      this.subtitle,
      this.showSubtitle = false,
      this.shouldBeRoundLeading = true,
      this.leadingVisuals,
      this.preTrailingVisuals,
      this.trailingControl,
      this.width,
      this.height,
      this.showPreTrailingVisual = false,
      this.showTrailingControl = false,
      this.onTap,
      this.showtags = false,
      this.boxShadow,
      this.tags});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 69,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFf0f6ff),
            boxShadow: boxShadow),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (showLeadingVisuals && leadingVisuals != null)
                if (shouldBeRoundLeading)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8E9F1),
                    ),
                    child: Center(child: leadingVisuals),
                  )
                else
                  leadingVisuals!,
              if (showLeadingVisuals && leadingVisuals != null)
                const SizedBox(
                  width: 16,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showTitle && title != null)
                    Text(
                      title!,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 16 / 20,
                        color: const Color(0xFF1F2024),
                      ),
                    ),
                  if (showSubtitle && subtitle != null) ...[
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 12 / 14,
                          color: const Color(0xFF71727A)),
                    )
                  ],
                  if (showtags && tags != null) ...[
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ],
              ),
              const Spacer(),
              if (showPreTrailingVisual && preTrailingVisuals != null)
                preTrailingVisuals!,
              if (showTrailingControl && trailingControl != null)
                trailingControl!
            ],
          ),
        ),
      ),
    );
  }
}
