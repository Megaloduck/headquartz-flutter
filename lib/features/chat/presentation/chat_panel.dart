import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bootstrap/dependency_injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/simulation/game_session.dart';

class ChatPanel extends ConsumerStatefulWidget {
  const ChatPanel({super.key, required this.session});
  final GameSession session;

  @override
  ConsumerState<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends ConsumerState<ChatPanel> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  @override
  void didUpdateWidget(covariant ChatPanel old) {
    super.didUpdateWidget(old);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final body = _ctrl.text.trim();
    if (body.isEmpty) return;
    ref.read(lobbyActionsProvider).sendChat(body);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.session.chat;
    return Column(
      children: [
        Expanded(
          child: chat.isEmpty
              ? Center(
                  child: Text('No messages yet',
                      style: AppTypography.caption),
                )
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md, vertical: Spacing.sm),
                  itemCount: chat.length,
                  itemBuilder: (context, i) {
                    final m = chat[i];
                    final color =
                        AppColors.forDepartment(m.fromRole?.key);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(m.fromName,
                                  style: AppTypography.bodySmall.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(width: Spacing.sm),
                              Text(Fmt.wallClock(m.timestamp),
                                  style: AppTypography.caption),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(m.body, style: AppTypography.bodySmall),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  onSubmitted: (_) => _send(),
                  style: AppTypography.body,
                  decoration: const InputDecoration(
                    hintText: 'Send a message…',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs),
              IconButton(
                icon:
                    const Icon(Icons.send_rounded, size: 14),
                onPressed: _send,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
