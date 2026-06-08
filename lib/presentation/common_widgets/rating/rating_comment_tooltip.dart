import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

class RatingCommentTooltip extends StatefulWidget {
  final String? comment;
  final Widget child;

  const RatingCommentTooltip({
    required this.comment,
    required this.child,
    super.key,
  });

  @override
  State<RatingCommentTooltip> createState() => _RatingCommentTooltipState();
}

class _RatingCommentTooltipState extends State<RatingCommentTooltip> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _hoveringChild = false;
  bool _hoveringOverlay = false;

  bool get _shouldShow => _hoveringChild || _hoveringOverlay;

  String? get _comment {
    final value = widget.comment?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _updateOverlay() {
    if (_comment == null) return;
    if (_shouldShow) {
      _showOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 80), () {
        if (mounted && !_shouldShow) _removeOverlay();
      });
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null || _comment == null) return;
    final resources = context.resources;
    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => Positioned(
        width: 280,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomCenter,
          followerAnchor: Alignment.topCenter,
          offset: const Offset(0, 4),
          showWhenUnlinked: false,
          child: MouseRegion(
            onEnter: (_) => _hoveringOverlay = true,
            onExit: (_) {
              _hoveringOverlay = false;
              _updateOverlay();
            },
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(resources.dimen.dp5),
              color: resources.color.viewBgColor,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: resources.dimen.dp10,
                  vertical: resources.dimen.dp8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _comment!,
                        style: context.textFontWeight400
                            .onColor(resources.color.colorWhite)
                            .onFontSize(resources.fontSize.dp11),
                      ),
                    ),
                    InkWell(
                      onTap: () => _copyComment(_comment!),
                      child: Padding(
                        padding: EdgeInsets.only(left: resources.dimen.dp8),
                        child: Icon(
                          Icons.copy,
                          size: 16,
                          color: resources.color.colorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _copyComment(String comment) {
    Clipboard.setData(ClipboardData(text: comment));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSelectedLocalEn ? 'Copied' : 'تم النسخ'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_comment == null) return widget.child;

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.help,
        onEnter: (_) {
          _hoveringChild = true;
          _updateOverlay();
        },
        onExit: (_) {
          _hoveringChild = false;
          _updateOverlay();
        },
        child: widget.child,
      ),
    );
  }
}
