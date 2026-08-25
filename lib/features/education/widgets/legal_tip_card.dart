import 'package:flutter/material.dart';
import '../../../src/theme/app_theme.dart';
import '../models/legal_tip.dart';

class LegalTipCard extends StatefulWidget {
  final LegalTip tip;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  const LegalTipCard({
    super.key,
    required this.tip,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  State<LegalTipCard> createState() => _LegalTipCardState();
}

class _LegalTipCardState extends State<LegalTipCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            offset: const Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surfaceVariant,
                child: Text(
                  '${widget.tip.id}',
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.tip.title,
                  style: AppTextStyles.titleMedium,
                  textAlign: TextAlign.right,
                ),
              ),
              IconButton(
                onPressed: () => widget.onFavoriteChanged(!widget.isFavorite),
                icon: Icon(
                  widget.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: widget.isFavorite ? AppColors.accent : AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedCrossFade(
            firstChild: Text(
              widget.tip.content,
              style: AppTextStyles.body,
              textAlign: TextAlign.right,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              widget.tip.content,
              style: AppTextStyles.body,
              textAlign: TextAlign.right,
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
          if (widget.tip.hasLongContent)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'نمایش کمتر' : 'مشاهده بیشتر',
                  style: const TextStyle(color: AppColors.accent),
                ),
              ),
            ),
          if (widget.tip.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: widget.tip.tags.map(
                (tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(tag, style: AppTextStyles.label),
                  );
                },
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
