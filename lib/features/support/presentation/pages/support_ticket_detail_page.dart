import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../data/models/support_ticket.dart';
import '../bloc/support_cubit.dart';

class SupportTicketDetailPage extends StatelessWidget {
  const SupportTicketDetailPage({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupportCubit>()
        ..loadTicket(ticketId)
        ..subscribeToTicket(ticketId),
      child: _SupportTicketDetailView(ticketId: ticketId),
    );
  }
}

class _SupportTicketDetailView extends StatefulWidget {
  const _SupportTicketDetailView({required this.ticketId});

  final String ticketId;

  @override
  State<_SupportTicketDetailView> createState() =>
      _SupportTicketDetailViewState();
}

class _SupportTicketDetailViewState extends State<_SupportTicketDetailView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _send(BuildContext context) async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;
    final ok = await context.read<SupportCubit>().sendMessage(
      widget.ticketId,
      content,
    );
    if (!mounted || !ok) return;
    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _closeTicket(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('support.close_confirm_title'.tr()),
        content: Text('support.close_confirm_body'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('batal'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('support.close_ticket'.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<SupportCubit>().closeTicket(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportCubit, SupportState>(
      listenWhen: (previous, current) {
        final prevNotice = previous.maybeWhen(
          loaded: (_, __, notice, ___) => notice,
          orElse: () => null,
        );
        final nextNotice = current.maybeWhen(
          loaded: (_, __, notice, ___) => notice,
          orElse: () => null,
        );
        final prevAction = previous.maybeWhen(
          loaded: (_, __, ___, err) => err,
          orElse: () => null,
        );
        final nextAction = current.maybeWhen(
          loaded: (_, __, ___, err) => err,
          orElse: () => null,
        );
        final messageCountChanged = previous.maybeWhen(
              loaded: (t, _, __, ___) => t.messages.length,
              orElse: () => -1,
            ) !=
            current.maybeWhen(
              loaded: (t, _, __, ___) => t.messages.length,
              orElse: () => -1,
            );
        return (nextNotice != null && nextNotice != prevNotice) ||
            (nextAction != null && nextAction != prevAction) ||
            messageCountChanged;
      },
      listener: (context, state) {
        state.whenOrNull(
          loaded: (_, __, notice, actionError) {
            if (notice != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(notice)));
            }
            if (actionError != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(actionError)));
            }
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );
          },
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (message) => Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: 'support.thread_title'.tr(),
              backgroundColor: AppColors.surface,
            ),
            body: _buildError(context, message),
          ),
          loaded: (ticket, isSending, _, __) => Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: 'support.thread_title'.tr(),
              backgroundColor: AppColors.surface,
              actions: [
                if (ticket.isActive)
                  IconButton(
                    tooltip: 'support.close_ticket'.tr(),
                    onPressed: () => _closeTicket(context),
                    icon: const Icon(
                      LucideIcons.circleCheck,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
            body: Column(
              children: [
                _buildHeader(ticket),
                Expanded(child: _buildMessages(context, ticket)),
                if (ticket.isActive)
                  _buildInput(context, isSending)
                else
                  _buildClosedBanner(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 12.h),
            OutlinedButton(
              onPressed: () =>
                  context.read<SupportCubit>().loadTicket(widget.ticketId),
              child: Text('support.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(SupportTicket ticket) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: ticket.isActive ? AppColors.primaryLight : AppColors.grey100,
      child: Row(
        children: [
          Icon(
            ticket.isActive ? LucideIcons.headset : LucideIcons.circleCheck,
            size: 20.sp,
            color: ticket.isActive
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ticket.isActive
                      ? ticket.assignedAdmin?.fullName ??
                            'support.waiting_cs'.tr()
                      : 'support.ticket_done'.tr(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(BuildContext context, SupportTicket ticket) {
    final messages = ticket.messages;
    return RefreshIndicator(
      onRefresh: () =>
          context.read<SupportCubit>().loadTicket(widget.ticketId),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        itemCount: messages.length,
        itemBuilder: (context, index) =>
            _MessageBubble(message: messages[index]),
      ),
    );
  }

  Widget _buildInput(BuildContext context, bool sending) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.all(12.w),
        color: AppColors.surface,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !sending,
                minLines: 1,
                maxLines: 4,
                maxLength: 4000,
                decoration: InputDecoration(
                  hintText: 'support.message_hint'.tr(),
                  counterText: '',
                ),
                onSubmitted: (_) => _send(context),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton.filled(
              onPressed: sending ? null : () => _send(context),
              style: IconButton.styleFrom(backgroundColor: AppColors.primary),
              icon: sending
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        color: AppColors.textOnPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      LucideIcons.send,
                      color: AppColors.textOnPrimary,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClosedBanner() {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        color: AppColors.surface,
        child: Text(
          'support.ticket_closed_banner'.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final SupportMessage message;

  @override
  Widget build(BuildContext context) {
    if (message.senderType == 'SYSTEM') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Text(
          message.content,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11.sp,
            height: 1.4,
          ),
        ),
      );
    }
    final isUser = message.senderType == 'USER';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 280.w),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  message.sender?.fullName ?? 'support.cs_name'.tr(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Text(
              message.content,
              style: TextStyle(
                color: isUser ? AppColors.textOnPrimary : AppColors.textPrimary,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
