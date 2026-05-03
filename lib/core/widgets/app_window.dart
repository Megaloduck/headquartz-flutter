import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// A draggable region used at the top of the desktop window.
///
/// Wrap any widget in [WindowDragArea] to make it act as a window-move
/// handle. Uses Flutter's built-in window drag (no plugin).
class WindowDragArea extends StatelessWidget {
  const WindowDragArea({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) async {
        if (event.kind != PointerDeviceKind.mouse) return;
        if (event.buttons != kPrimaryButton) return;
        // Best-effort drag: SystemChannels.platform startSystemDragging
        try {
          await SystemChannels.platform.invokeMethod<void>(
            'WindowManager.startWindowDrag',
          );
        } catch (_) {}
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

/// Standard window-control buttons for desktop platforms.
class WindowControls extends StatelessWidget {
  const WindowControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Btn(
            icon: Icons.minimize_rounded,
            tooltip: 'Minimize',
            onTap: () =>
                SystemChannels.platform.invokeMethod('WindowManager.minimize')),
        _Btn(
            icon: Icons.crop_square_rounded,
            tooltip: 'Maximize',
            onTap: () => SystemChannels.platform
                .invokeMethod('WindowManager.toggleMaximize')),
        _Btn(
            icon: Icons.close_rounded,
            tooltip: 'Close',
            danger: true,
            onTap: () => SystemNavigator.pop()),
      ],
    );
  }
}

class _Btn extends StatefulWidget {
  const _Btn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool danger;

  @override
  State<_Btn> createState() => _BtnState();
}

class _BtnState extends State<_Btn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final hoverBg =
        widget.danger ? AppColors.danger : AppColors.surfaceHover;
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 44,
            height: 28,
            color: _hover ? hoverBg : Colors.transparent,
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: 14,
              color: _hover && widget.danger
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
