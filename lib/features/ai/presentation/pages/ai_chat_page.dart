import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_logo.dart';
import '../../../../injection_container.dart';
import '../bloc/ai_cubit.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../support/data/datasources/support_remote_data_source.dart';
import '../../../support/data/models/support_ticket.dart';

/// Deteksi permintaan hubungkan ke CS dari teks chat (bukan lewat AI).
bool looksLikeCsHandoffRequest(String raw) {
  final t = raw.toLowerCase().trim();
  if (t.isEmpty) return false;
  if (RegExp(
    r'\b(customer\s*service|customer\s*support|live\s*agent|live\s*chat|chat\s*cs)\b',
  ).hasMatch(t)) {
    return true;
  }
  // "cs" sebagai kata utuh (hindari false positive seperti "pcs")
  if (RegExp(r'(^|\s)cs(\s|$)').hasMatch(t)) return true;
  final wantsConnect = RegExp(
    r'hubung|hubungkan|sambung|alihkan|transfer|bicara|hubungi|bantuan',
  ).hasMatch(t);
  final mentionsCs = RegExp(
    r'\b(cs|support|admin|manusia|operator|agen)\b',
  ).hasMatch(t);
  return wantsConnect && mentionsCs;
}

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  List<String> get _suggestedPrompts => [
    'ai.prompt_biochar'.tr(),
    'ai.prompt_biomass'.tr(),
    'ai.prompt_negotiation'.tr(),
    'ai.prompt_marketplace'.tr(),
  ];

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _supportApi = sl<SupportRemoteDataSource>();
  SupportTicket? _activeSupportTicket;
  bool _checkingSupport = true;
  bool _startingHandoff = false;

  @override
  void initState() {
    super.initState();
    _checkActiveSupport();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _checkActiveSupport() async {
    try {
      final ticket = await _supportApi.getActiveTicket();
      if (!mounted) return;
      setState(() {
        _activeSupportTicket = ticket;
        _checkingSupport = false;
      });
    } catch (_) {
      if (mounted) setState(() => _checkingSupport = false);
    }
  }

  void _syncCsHandoffFlag(BuildContext blocContext) {
    final cubit = blocContext.read<AiCubit>();
    final shouldPause = _activeSupportTicket != null;
    if (cubit.csHandoffActive != shouldPause) {
      cubit.setCsHandoffActive(shouldPause);
    }
  }

  Future<void> _openCustomerService(BuildContext blocContext) async {
    if (_startingHandoff) return;

    final isLoggedIn = blocContext.read<AuthCubit>().state.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
    if (!isLoggedIn) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('support.login_required'.tr())));
      AuthSheet.show(context);
      return;
    }

    if (_activeSupportTicket != null) {
      await context.push('/support/${_activeSupportTicket!.id}');
      await _checkActiveSupport();
      if (mounted) _syncCsHandoffFlag(blocContext);
      return;
    }

    final messages = blocContext.read<AiCubit>().messages;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('support.handoff_title'.tr()),
        content: Text('support.handoff_body'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('batal'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('support.chat_cs'.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final transcript = messages
        .where((m) => m.text.trim().isNotEmpty)
        .take(30)
        .map(
          (message) => {
            'role': message.isUser ? 'user' : 'assistant',
            'content': message.text.length > 2000
                ? message.text.substring(0, 2000)
                : message.text.trim(),
          },
        )
        .toList();
    String? lastUserMessage;
    for (final message in messages.reversed) {
      if (message.isUser && message.text.trim().isNotEmpty) {
        lastUserMessage = message.text.trim();
        break;
      }
    }

    setState(() => _startingHandoff = true);
    try {
      final ticket = await _supportApi.createTicket(
        subject: 'support.handoff_subject'.tr(),
        category: 'OTHER',
        source: 'AI_HANDOFF',
        initialMessage:
            lastUserMessage ?? 'support.handoff_default_message'.tr(),
        aiTranscript: transcript,
      );
      if (!mounted) return;
      setState(() => _activeSupportTicket = ticket);
      _syncCsHandoffFlag(blocContext);
      await context.push('/support/${ticket.id}');
      await _checkActiveSupport();
      if (mounted) _syncCsHandoffFlag(blocContext);
    } on DioException catch (e) {
      if (!mounted) return;
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('support.login_required'.tr())));
        AuthSheet.show(context);
        return;
      }
      final existing = await _supportApi.getActiveTicket().catchError(
        (_) => null,
      );
      if (!mounted) return;
      if (existing != null) {
        setState(() => _activeSupportTicket = existing);
        _syncCsHandoffFlag(blocContext);
        await context.push('/support/${existing.id}');
        return;
      }
      final data = e.response?.data;
      String detail = 'support.handoff_failed'.tr();
      if (data is Map) {
        final metaMsg = data['meta']?['message']?.toString();
        final details = data['data'];
        if (details is List && details.isNotEmpty) {
          final first = details.first;
          if (first is Map && first['message'] != null) {
            detail = first['message'].toString();
          }
        } else if (metaMsg != null && metaMsg.isNotEmpty) {
          detail = metaMsg;
        }
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(detail)));
    } catch (_) {
      if (!mounted) return;
      final existing = await _supportApi.getActiveTicket().catchError(
        (_) => null,
      );
      if (!mounted) return;
      if (existing != null) {
        setState(() => _activeSupportTicket = existing);
        _syncCsHandoffFlag(blocContext);
        await context.push('/support/${existing.id}');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('support.handoff_failed'.tr())));
      }
    } finally {
      if (mounted) setState(() => _startingHandoff = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AiCubit>(),
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _syncCsHandoffFlag(context);
          });
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              backgroundColor: AppColors.surface,
              titleWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Container(
                      color: AppColors.surface,
                      padding: EdgeInsets.all(4.r),
                      child: BisaLogo(size: 24.r),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'ai.title'.tr(),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: _activeSupportTicket == null
                      ? 'support.chat_cs'.tr()
                      : 'support.continue_chat_cs'.tr(),
                  icon: _startingHandoff || _checkingSupport
                      ? SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Icon(
                          LucideIcons.headset,
                          color: _activeSupportTicket == null
                              ? AppColors.primary
                              : AppColors.warning,
                        ),
                  onPressed: _checkingSupport || _startingHandoff
                      ? null
                      : () => _openCustomerService(context),
                ),
                IconButton(
                  icon: const Icon(
                    LucideIcons.trash2,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => _showClearChatConfirmation(context),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<AiCubit, AiState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        initial: () => _buildEmptyState(),
                        chatLoaded: (messages, isTyping) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _scrollToBottom(),
                          );
                          return ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.all(16.w),
                            itemCount: messages.length + (isTyping ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == messages.length && isTyping) {
                                return const _TypingIndicator();
                              }
                              return _buildChatBubble(context, messages[index]);
                            },
                          );
                        },
                        loading: () => ShimmerLoading(
                          child: ListView(
                            padding: EdgeInsets.all(16.w),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Bone(
                                  width: 200.w,
                                  height: 48.h,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Bone(
                                  width: 160.w,
                                  height: 40.h,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Bone(
                                  width: 240.w,
                                  height: 64.h,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                        error: (message) {
                          final display = localizeFailureMessage(message);
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.r),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    display,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  TextButton(
                                    onPressed: () =>
                                        context.read<AiCubit>().sendMessage(''),
                                    child: Text('market.retry'.tr()),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _sendSuggestedPrompt(BuildContext context, String text) {
    context.read<AiCubit>().sendMessage(text);
    _messageController.clear();
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageGutter,
            vertical: AppSpacing.spacious,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - AppSpacing.spacious * 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEmptyHero(),
                SizedBox(height: AppSpacing.spacious),
                Text(
                  'ai.greeting'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'ai.empty_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 28.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ai.suggested_title'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                ..._suggestedPrompts.map(
                  (prompt) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _SuggestedPromptCard(
                      text: prompt,
                      onTap: () => _sendSuggestedPrompt(context, prompt),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyHero() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 140.w,
          height: 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primaryLight,
                AppColors.primaryLight.withValues(alpha: 0.15),
              ],
            ),
          ),
        ),
        Container(
          width: 96.w,
          height: 96.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryMedium, AppColors.primary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 28.sp,
                color: AppColors.white.withValues(alpha: 0.35),
              ),
              Padding(
                padding: EdgeInsets.all(18.w),
                child: BisaLogo(size: 52.w),
              ),
            ],
          ),
        ),
        Positioned(
          right: 8.w,
          bottom: 4.h,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              LucideIcons.messageCircle,
              size: 18.sp,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(bool isUser) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageGutter),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: const Icon(LucideIcons.trash2, color: AppColors.white),
    );
  }

  Widget _buildChatBubble(BuildContext context, ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Dismissible(
        key: ValueKey(message.id),
        direction: message.isUser
            ? DismissDirection.endToStart
            : DismissDirection.startToEnd,
        background: _buildSwipeBackground(message.isUser),
        onDismissed: (direction) {
          context.read<AiCubit>().deleteMessage(message.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ai.message_deleted'.tr()),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: GestureDetector(
          onLongPress: () => _showMessageOptions(context, message),
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            constraints: BoxConstraints(maxWidth: 0.70.sw),
            decoration: BoxDecoration(
              color: message.isUser ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
                bottomLeft: message.isUser
                    ? Radius.circular(12.r)
                    : Radius.zero,
                bottomRight: message.isUser
                    ? Radius.zero
                    : Radius.circular(12.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? AppColors.white : AppColors.textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessageOptions(BuildContext context, ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: bisaSheetPadding(bottomSheetContext),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ai.message_options'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: const Icon(LucideIcons.copy, color: AppColors.primary),
                title: Text(
                  'ai.copy_message'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.text));
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ai.message_copied'.tr()),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const Divider(color: AppColors.grey200, height: 1),
              ListTile(
                leading: const Icon(
                  LucideIcons.pencil,
                  color: AppColors.secondary,
                ),
                title: Text(
                  'ai.edit_message'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showEditMessageDialog(context, message);
                },
              ),
              const Divider(color: AppColors.grey200, height: 1),
              ListTile(
                leading: const Icon(LucideIcons.trash2, color: AppColors.error),
                title: Text(
                  'ai.delete_message'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  context.read<AiCubit>().deleteMessage(message.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ai.message_deleted'.tr()),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditMessageDialog(BuildContext context, ChatMessage message) {
    final controller = TextEditingController(text: message.text);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'ai.edit_message'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'ai.edit_message_hint'.tr(),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('batal'.tr()),
            ),
            TextButton(
              onPressed: () {
                final newText = controller.text.trim();
                if (newText.isNotEmpty) {
                  context.read<AiCubit>().editMessage(message.id, newText);
                }
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ai.message_updated'.tr())),
                );
              },
              child: Text(
                'simpan'.tr(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClearChatConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'ai.clear_chat_title'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'ai.clear_chat_body'.tr(),
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('batal'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AiCubit>().clearChat();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ai.chat_history_cleared'.tr())),
                );
              },
              child: Text(
                'hapus'.tr(),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputArea() {
    return BlocBuilder<AiCubit, AiState>(
      builder: (context, state) {
        if (_activeSupportTicket != null) {
          return SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              color: AppColors.surface,
              child: FilledButton.icon(
                onPressed: () => _openCustomerService(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                icon: const Icon(LucideIcons.headset),
                label: Text('support.continue_conversation'.tr()),
              ),
            ),
          );
        }
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: TextField(
                      controller: _messageController,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'ai.input_hint'.tr(),
                        border: InputBorder.none,
                      ),
                      onSubmitted: isLoading
                          ? null
                          : (_) => _submitMessage(context),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                CircleAvatar(
                  backgroundColor: isLoading
                      ? AppColors.grey300
                      : AppColors.primary,
                  child: IconButton(
                    icon: isLoading
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.surface,
                            ),
                          )
                        : const Icon(
                            LucideIcons.send,
                            color: AppColors.textOnPrimary,
                            size: 18,
                          ),
                    onPressed: isLoading ? null : () => _submitMessage(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitMessage(BuildContext context) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();

    if (looksLikeCsHandoffRequest(text)) {
      context.read<AiCubit>().appendLocalExchange(
        userText: text,
        assistantText: 'ai.cs_handoff_ack'.tr(),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openCustomerService(context);
      });
      return;
    }

    context.read<AiCubit>().sendMessage(text);
  }
}

class _SuggestedPromptCard extends StatelessWidget {
  const _SuggestedPromptCard({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  LucideIcons.lightbulb,
                  size: 16.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18.sp,
                color: AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated typing indicator with 3 bouncing dots
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });

    _animations = _controllers.map((c) {
      return Tween<double>(
        begin: 0,
        end: -8,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
            bottomRight: Radius.circular(12.r),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _animations[i],
              builder: (context, child) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Transform.translate(
                    offset: Offset(0, _animations[i].value),
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
