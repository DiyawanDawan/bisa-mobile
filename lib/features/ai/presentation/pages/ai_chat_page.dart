import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_logo.dart';
import '../../../../injection_container.dart';
import '../bloc/ai_cubit.dart';
import 'package:mobile_bisa/shared/widgets/pro_required_placeholder.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  static const _suggestedPrompts = [
    'Apa itu biochar dan manfaatnya untuk tanah?',
    'Bagaimana mengolah limbah biomass jadi produk?',
    'Tips negosiasi harga yang adil dengan supplier',
    'Cara mulai jual produk di marketplace BISA',
  ];

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AiCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          backgroundColor: Colors.white,
          titleWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(4.r),
                  child: BisaLogo(size: 24.r),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Asisten BISA',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<AiCubit, AiState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    initial: () => _buildEmptyState(),
                    chatLoaded: (messages) {
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(16.w),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildChatBubble(messages[index]);
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
                      final isProError = message.contains('PRO') || message.contains('Langganan');
                      if (isProError) {
                        return ProRequiredPlaceholder(
                          message: message,
                          icon: LucideIcons.bot,
                          onRetryPressed: () => context.read<AiCubit>().sendMessage(''), // Or some refresh logic
                          onActionPressed: () => context.push('/iot-subscription'),
                        );
                      }
                      return Center(child: Text(message));
                    },
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 48.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEmptyHero(),
                SizedBox(height: 28.h),
                Text(
                  'Halo! Saya Asisten BISA',
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
                  'Belum ada percakapan. Mulai dengan mengetik di bawah atau pilih topik populer.',
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
                    'Saran pertanyaan',
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
                color: Colors.white.withValues(alpha: 0.35),
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
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
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

  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
            bottomLeft: message.isUser ? Radius.circular(12.r) : Radius.zero,
            bottomRight: message.isUser ? Radius.zero : Radius.circular(12.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : AppColors.textPrimary,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return BlocBuilder<AiCubit, AiState>(
      builder: (context, state) {
        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
        return SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
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
                      decoration: const InputDecoration(
                        hintText: 'Tulis pertanyaan tentang biochar, pasar, atau IoT...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: isLoading ? null : (_) => _submitMessage(context),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                CircleAvatar(
                  backgroundColor: isLoading ? AppColors.grey300 : AppColors.primary,
                  child: IconButton(
                    icon: isLoading
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(LucideIcons.send, color: Colors.white, size: 18),
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
    context.read<AiCubit>().sendMessage(text);
    _messageController.clear();
  }
}

class _SuggestedPromptCard extends StatelessWidget {
  const _SuggestedPromptCard({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
