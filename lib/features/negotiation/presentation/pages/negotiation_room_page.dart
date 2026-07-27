import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_bisa/core/constants/app_text_styles.dart';
import 'package:mobile_bisa/core/core.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/core/utils/product_pricing.dart';
import 'package:mobile_bisa/core/utils/translation_util.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/negotiation/domain/entities/negotiation_entity.dart';
import 'package:mobile_bisa/features/negotiation/domain/entities/negotiation_entity_extensions.dart';
import 'package:mobile_bisa/features/negotiation/presentation/bloc/negotiation_cubit.dart';
import 'package:mobile_bisa/features/negotiation/presentation/utils/negotiation_status_ui.dart';
import 'package:mobile_bisa/features/negotiation/presentation/utils/admin_mediation_message.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/bisa_dialog.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';
import 'package:mobile_bisa/shared/widgets/bisa_media_skeleton.dart';
import 'package:mobile_bisa/shared/widgets/bisa_network_image.dart';
import 'package:mobile_bisa/shared/widgets/chat_room_skeleton.dart';
import 'package:mobile_bisa/features/invoice/presentation/utils/invoice_export_helper.dart';
import 'package:mobile_bisa/features/partnership/presentation/utils/partnership_pdf_export_helper.dart';
import 'package:mobile_bisa/features/negotiation/presentation/widgets/negotiation_closure_dialog.dart';
import 'package:mobile_bisa/shared/widgets/handwriting_input_sheet.dart';
import 'package:mobile_bisa/shared/widgets/linkified_text.dart';
import 'package:mobile_bisa/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:mobile_bisa/features/negotiation/domain/repositories/negotiation_repository.dart';
import 'package:mobile_bisa/features/orders/domain/repositories/order_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class NegotiationRoomPage extends StatefulWidget {
  final String negotiationId;

  /// `inquiry` untuk chat tanya produk; null = negosiasi harga.
  final String? chatMode;

  const NegotiationRoomPage({
    super.key,
    required this.negotiationId,
    this.chatMode,
  });

  @override
  State<NegotiationRoomPage> createState() => _NegotiationRoomPageState();
}

class _NegotiationRoomPageState extends State<NegotiationRoomPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _typingTimer;
  bool _isCurrentlyTyping = false;
  String? _editingMessageId;

  // Track F: on-device translation state
  // key = message ID, value = translated text (null = not translated)
  final Map<String, String?> _translatedTexts = {};
  // IDs currently being translated (hanya jika butuh >150ms)
  final Set<String> _translatingIds = {};
  bool _modelsPreparing = false;

  /// Panel "Tagihan dari Supplier" — bisa collapse biar input chat tidak ketutup.
  bool _invoicePanelExpanded = true;
  bool _wasKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    // Prefetch model supaya tap Terjemahkan hampir instan.
    TranslationUtil.warmUp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Keyboard muncul → auto-collapse tagihan supaya input chat terlihat.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 80;
    if (keyboardOpen && !_wasKeyboardOpen && _invoicePanelExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _invoicePanelExpanded = false);
      });
    }
    _wasKeyboardOpen = keyboardOpen;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  NegotiationEntity? _cachedNegotiation;

  bool _isInquiryMode(NegotiationEntity n) =>
      widget.chatMode == 'inquiry' || n.isInquiryChat;

  // ─── Track F: translate a single message on-tap ──────────────────────────
  Future<void> _translateMessage(String msgId, String content) async {
    // Already translated → toggle back to original
    if (_translatedTexts.containsKey(msgId)) {
      setState(() => _translatedTexts.remove(msgId));
      return;
    }

    if (_translatingIds.contains(msgId)) return;

    // Model belum siap: unduh dulu sekali (bukan spinner per-pesan).
    if (!TranslationUtil.isReady) {
      if (_modelsPreparing) return;
      setState(() => _modelsPreparing = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('negotiation.translate_downloading_model'.tr()),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      final ready = await TranslationUtil.ensureModelsReady();
      if (mounted) setState(() => _modelsPreparing = false);
      if (!ready) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('negotiation.translate_failed'.tr()),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }
    }

    // Spinner hanya jika terjemahan >150ms (biasanya instan setelah model siap).
    var showSpinner = false;
    final spinnerTimer = Timer(const Duration(milliseconds: 150), () {
      if (!mounted) return;
      showSpinner = true;
      setState(() => _translatingIds.add(msgId));
    });

    try {
      final pair = await TranslationUtil.resolveIdEnDirection(content);
      if (pair == null) {
        // Hanya URL / tanpa teks bermakna — tidak ada yang diterjemahkan.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('negotiation.translate_unavailable'.tr()),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      final result = await TranslationUtil.translate(
        text: content,
        sourceLanguageCode: pair.source,
        targetLanguageCode: pair.target,
      );

      if (mounted) setState(() => _translatedTexts[msgId] = result);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('negotiation.translate_failed'.tr()),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      spinnerTimer.cancel();
      if (mounted && (showSpinner || _translatingIds.contains(msgId))) {
        setState(() => _translatingIds.remove(msgId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NegotiationCubit>()
        ..getDetail(widget.negotiationId)
        ..subscribeToNegotiation(widget.negotiationId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        appBar: BisaAppBar(
          backgroundColor: AppColors.surface,
          centerTitle: false,
          titleWidget: BlocBuilder<NegotiationCubit, NegotiationState>(
            builder: (context, state) {
              final n = state.maybeWhen(
                detailLoaded: (n, _, __) => n,
                orElse: () => _cachedNegotiation,
              );
              final isTyping = state.maybeWhen(
                detailLoaded: (_, typing, __) => typing,
                orElse: () => false,
              );

              if (n == null) {
                return Text(
                  widget.chatMode == 'inquiry'
                      ? 'negotiation.room_title_inquiry'.tr()
                      : 'negosiasi'.tr(),
                );
              }
              if (_isInquiryMode(n)) {
                return Text('negotiation.room_title_inquiry'.tr());
              }

              final userState = context.watch<AuthCubit>().state;
              final currentUser = userState.maybeWhen(
                authenticated: (u) => u,
                orElse: () => null,
              );
              final isSupplier = currentUser?.role == 'SUPPLIER';

              final otherParty = isSupplier ? n.buyer : n.seller;
              return Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.grey100,
                      backgroundImage: resolveMediaImageProvider(otherParty.avatarUrl),
                      child: otherParty.avatarUrl == null
                          ? Icon(
                              Icons.person,
                              size: 20.sp,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSupplier
                              ? n.buyer.name
                              : n.seller.companyName ?? n.seller.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6.r,
                              height: 6.r,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'negotiation.room_online'.tr(),
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (isTyping) ...[
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'negotiation.room_typing'.tr(),
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 10.sp,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, size: 20.sp),
              onPressed: () => _showRoomMenu(context),
            ),
          ],
        ),
        body: BlocConsumer<NegotiationCubit, NegotiationState>(
          listener: (context, state) {
            state.maybeWhen(
              detailLoaded: (n, typing, _) {
                _cachedNegotiation = n;
                context.read<NegotiationCubit>().markMessagesAsRead(widget.negotiationId);
                _scrollToBottom();
              },
              success: (msg) {
                showSuccessSnackBar(context, msg);
              },
              error: (msg) => showErrorSnackBar(context, msg),
              orElse: () {},
            );
          },
          builder: (context, state) {
            final userState = context.watch<AuthCubit>().state;
            final currentUser = userState.maybeWhen(
              authenticated: (u) => u,
              orElse: () => null,
            );
            final isSupplier = currentUser?.role == 'SUPPLIER';

            final n = state.maybeWhen(
              detailLoaded: (n, _, __) => n,
              orElse: () => _cachedNegotiation,
            );
            final isLoadingOlder = state.maybeWhen(
              detailLoaded: (_, __, loading) => loading,
              orElse: () => false,
            );
            final hasOlderMessages = n != null &&
                context.read<NegotiationCubit>().hasOlderMessages(n);

            if (n == null) {
              return state.maybeWhen(
                loading: () => const ShimmerChatRoomPlaceholder(),
                orElse: () => const ShimmerChatRoomPlaceholder(),
              );
            }

            return Column(
              children: [
                if (_isInquiryMode(n))
                  _buildInquiryHUD(n, isSupplier, currentUser?.id)
                else
                  _buildNegotiationHUD(n, isSupplier, currentUser?.id),
                if (_isDisputeMediationActive(n))
                  _buildDisputeMediationBanner(context, n),
                Expanded(
                  child: Stack(
                    children: [
                      Container(color: AppColors.background),
                      n.messages == null || n.messages!.isEmpty
                          ? _buildEmptyChat(inquiry: _isInquiryMode(n))
                          : RefreshIndicator(
                              color: AppColors.primary,
                              onRefresh: () => context
                                  .read<NegotiationCubit>()
                                  .getDetail(widget.negotiationId),
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.lg,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: n.messages!.length +
                                    (hasOlderMessages ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (hasOlderMessages && index == 0) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: AppSpacing.md12),
                                      child: Center(
                                        child: isLoadingOlder
                                            ? SizedBox(
                                                width: AppSpacing.xlPx.r,
                                                height: AppSpacing.xlPx.r,
                                                child: const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.primary,
                                                ),
                                              )
                                            : TextButton(
                                                onPressed: () => context
                                                    .read<NegotiationCubit>()
                                                    .loadOlderChatMessages(
                                                      widget.negotiationId,
                                                    ),
                                                child: Text(
                                                  'Muat pesan lama'.tr(),
                                                  style: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    );
                                  }

                                  final msgIndex =
                                      hasOlderMessages ? index - 1 : index;
                                  final msg = n.messages![msgIndex];
                                  final showDate =
                                      msgIndex == 0 ||
                                      !_isSameDay(
                                        msg.createdAt,
                                        n.messages![msgIndex - 1].createdAt,
                                      );

                                  return Column(
                                    children: [
                                      if (showDate)
                                        _buildDateHeader(msg.createdAt),
                                      _buildChatBubble(
                                        context,
                                        n,
                                        msg,
                                        currentUser?.id == msg.senderId ||
                                            msg.senderId == 'me',
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
                _buildBottomActions(context, n, isSupplier, currentUser),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildDateHeader(DateTime date) {
    String dateText = '';
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    if (_isSameDay(date, now)) {
      dateText = 'negotiation.date_today'.tr();
    } else if (_isSameDay(date, yesterday)) {
      dateText = 'negotiation.date_yesterday'.tr();
    } else {
      dateText = DateFormat('d MMMM yyyy').format(date);
    }

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.grey200.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        child: Text(
          dateText,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _openProductContext(NegotiationEntity n, String? userId) {
    if (userId == null || !n.isParticipant(userId)) {
      showErrorSnackBar(context, 'negotiation.data_mismatch_reload'.tr());
      return;
    }
    if (n.isSellerParticipant(userId)) {
      context.push('/negotiation/${n.id}/product');
    } else {
      context.push('/product/${n.productId}');
    }
  }

  void _openSupplierProfile(NegotiationEntity n) {
    context.push(
      '/supplier/${n.seller.id}',
      extra: {'name': n.seller.companyName ?? n.seller.name},
    );
  }

  Widget _buildInquiryHUD(
    NegotiationEntity n,
    bool isSupplier, [
    String? userId,
  ]) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md12, AppSpacing.md, AppSpacing.md12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: n.product.thumbnailUrl != null &&
                          n.product.thumbnailUrl!.isNotEmpty
                      ? BisaNetworkImage(
                          imageUrl: n.product.thumbnailUrl!,
                          width: 48.w,
                          height: 48.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 48.w,
                          height: 48.w,
                          color: AppColors.info.withValues(alpha: 0.08),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.info,
                            size: 20.sp,
                          ),
                        ),
                ),
                SizedBox(width: AppSpacing.md12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.product.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        n.seller.companyName ?? n.seller.name,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatMoneyIdr(n.product.pricePerUnit * n.quantity),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'negotiation.inquiry_badge'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.info,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs6, horizontal: AppSpacing.md),
            color: AppColors.info.withValues(alpha: 0.05),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 12.sp, color: AppColors.info),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    isSupplier
                        ? 'negotiation.inquiry_banner_supplier'.tr()
                        : 'negotiation.inquiry_banner_buyer'.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNegotiationHUD(
    NegotiationEntity n,
    bool isSupplier,
    String? userId,
  ) {
    final isSellerInRoom =
        userId != null && n.isSellerParticipant(userId);
    final display = NegotiationStatusDisplay.forRoom(
      n.status,
      isSupplier: isSupplier,
      orderStatus: _linkedOrderStatus(n),
    );
    final statusColor = display.color;
    final statusText = display.label;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md12, AppSpacing.md, AppSpacing.md),
            child: Row(
              children: [
                // Product Image
                GestureDetector(
                  onTap: () => _openProductContext(n, userId),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child:
                        n.product.thumbnailUrl != null &&
                            n.product.thumbnailUrl!.isNotEmpty
                        ? BisaNetworkImage(
                            imageUrl: n.product.thumbnailUrl!,
                            width: 48.w,
                            height: 48.w,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => BisaMediaSkeleton(
                              width: 48.w,
                              height: 48.w,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 48.w,
                              height: 48.w,
                              color: AppColors.primary.withValues(alpha: 0.08),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                            ),
                          )
                        : Container(
                            width: 48.w,
                            height: 48.w,
                            color: AppColors.primary.withValues(alpha: 0.08),
                            child: Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: AppSpacing.md12),
                // Product & Seller Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _openProductContext(n, userId),
                        child: Text(
                          n.product.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onTap: () => _openProductContext(n, userId),
                        child: Text(
                          isSellerInRoom
                              ? 'negotiation.product_link_seller'.tr()
                              : 'negotiation.product_link_buyer'.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onTap: () => _openSupplierProfile(n),
                        child: Row(
                          children: [
                            Icon(
                              Icons.storefront,
                              size: 12.sp,
                              color: AppColors.textHint,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                n.seller.companyName ?? n.seller.name,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              LucideIcons.badgeCheck,
                              color: AppColors.info,
                              size: 12.sp,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${n.quantity} ${n.product.unit}',
                        style: AppTextStyles.caption(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Price Comparison
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    if (n.product.pricePerUnit > n.pricePerUnit)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          formatMoneyIdr(n.product.pricePerUnit * n.quantity),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.error,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    if (n.product.pricePerUnit > n.pricePerUnit)
                      SizedBox(height: 4.h),
                    Text(
                      formatMoneyIdr(n.totalEstimate as num),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: statusColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ],
            ),
          ),
          if (n.status == 'OPEN_NEGOTIATION')
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs6, horizontal: AppSpacing.md),
              color: AppColors.warning.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 12.sp,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'negotiation.status_waiting_bargain'.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          if (NegotiationStatusDisplay.isTerminal(n.status) &&
              (n.rejectionReason?.isNotEmpty ?? false))
            _buildClosureReasonBanner(n, isSupplier),
        ],
      ),
    );
  }

  Widget _buildEmptyChat({required bool inquiry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: AppColors.softShadow,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 40.sp,
              color: AppColors.grey300,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'negotiation.empty_chat_title'.tr(),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            inquiry
                ? 'negotiation.empty_chat_inquiry_subtitle'.tr()
                : 'negotiation.empty_chat_negotiation_subtitle'.tr(),
            style: TextStyle(color: AppColors.textHint, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(
    BuildContext context,
    NegotiationEntity n,
    NegotiationMessageEntity msg,
    bool isMe,
  ) {
    if (isAdminMediationMessageContent(msg.content) ||
        msg.senderRole?.toUpperCase() == 'ADMIN') {
      final body = stripAdminMediationPrefix(msg.content);
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: AppSpacing.md12, horizontal: AppSpacing.md12),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.scale,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'negotiation.admin_mediator_label'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                body.isNotEmpty ? body : msg.content,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (msg.isSystemMessage) {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs6),
          decoration: BoxDecoration(
            color: AppColors.grey200.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, size: 12.sp, color: AppColors.textHint),
              SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  msg.content,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (msg.isDeleted) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.section, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.grey200.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Text(
                'negotiation.message_deleted'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final canManage = isMe && !msg.id.startsWith('temp-');

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: AppRadius.tile,
              backgroundColor: AppColors.grey200,
              child: Icon(Icons.person, size: 14.sp, color: AppColors.grey400),
            ),
            SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: canManage
                  ? () => _showMessageActions(context, n, msg)
                  : null,
              child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.xl),
                      topRight: Radius.circular(AppRadius.xl),
                      bottomLeft: isMe ? Radius.circular(AppRadius.xl) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : Radius.circular(AppRadius.xl),
                    ),
                    boxShadow: isMe
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (msg.content.trim().isNotEmpty)
                        LinkifiedText(
                          text: _translatedTexts[msg.id] ?? msg.content,
                          style: TextStyle(
                            color: isMe ? AppColors.white : AppColors.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                          // Own bubble (hijau): biru muda supaya kontras; peer: biru info.
                          linkColor: isMe
                              ? AppColors.infoBorder
                              : AppColors.info,
                        ),
                      if (msg.attachmentUrl != null &&
                          msg.attachmentUrl!.isNotEmpty) ...[
                        if (msg.content.trim().isNotEmpty) SizedBox(height: AppSpacing.sm),
                        _buildMessageAttachment(msg, isMe),
                      ],
                      if (isMe) ...[
                        SizedBox(height: 2.h),
                        _buildMessageStatus(msg),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg.createdAt.toTime,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (msg.editedAt != null) ...[
                      SizedBox(width: 4.w),
                      Text(
                        '· diedit',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    // Translate button (only for non-empty text messages)
                    if (msg.content.trim().isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      _translatingIds.contains(msg.id)
                          ? SizedBox(
                              width: 10.w,
                              height: 10.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AppColors.textHint,
                              ),
                            )
                          : GestureDetector(
                              onTap: _modelsPreparing
                                  ? null
                                  : () => _translateMessage(msg.id, msg.content),
                              child: Text(
                                _translatedTexts.containsKey(msg.id)
                                    ? 'negotiation.translate_show_original'.tr()
                                    : 'negotiation.translate_button'.tr(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: _modelsPreparing
                                      ? AppColors.textHint
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: _modelsPreparing
                                      ? AppColors.textHint
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                    ],
                  ],
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canRespondToOffer(String status) =>
      status == 'OPEN_NEGOTIATION' || status == 'OFFER_SUBMITTED';

  bool _canRenegotiateAfterAccept(NegotiationEntity n) =>
      n.status == 'OFFER_ACCEPTED' && !n.isLocked && n.orderId == null;

  Widget _buildMessageAttachment(NegotiationMessageEntity msg, bool isMe) {
    final url = resolveMediaUrl(msg.attachmentUrl);
    if (url.isEmpty) return const SizedBox.shrink();

    final isPdf = url.toLowerCase().contains('.pdf') ||
        msg.content.toLowerCase().contains('pdf');

    if (!isPdf) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: BisaNetworkImage(
          imageUrl: url,
          width: 180.w,
          height: 120.h,
          fit: BoxFit.cover,
        ),
      );
    }

    final linkColor = isMe ? AppColors.white : AppColors.primary;
    return InkWell(
      onTap: () => _openAttachment(url),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm10),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.white.withValues(alpha: 0.15)
              : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isMe
                ? AppColors.white.withValues(alpha: 0.35)
                : AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf, color: linkColor, size: 22.sp),
            SizedBox(width: AppSpacing.sm),
            Text(
              'negotiation.action_open_invoice_pdf'.tr(),
              style: TextStyle(
                color: linkColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAttachment(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        showErrorSnackBar(context, 'negotiation.attachment_open_failed'.tr());
      }
    }
  }

  bool _hasIssuedInvoice(NegotiationEntity n) =>
      n.orderId != null &&
      (n.status == 'LOCKED' || n.status == 'CONTRACT_CREATED');

  String? _linkedOrderStatus(NegotiationEntity n) => n.order?.status;

  bool _orderNeedsPayment(NegotiationEntity n) {
    final status = _linkedOrderStatus(n);
    if (status == null || status.isEmpty) return true;
    return status.toUpperCase() == 'PENDING';
  }

  String _orderDetailRoute(NegotiationEntity n) {
    final orderId = n.order?.id ?? n.orderId;
    return '/order/$orderId';
  }

  /// Chat tetap boleh selama mediasi sengketa (LOCKED + DISPUTED).
  bool _canSendChat(NegotiationEntity n) {
    if (_isDisputeMediationActive(n)) return true;
    const blocked = {'OFFER_REJECTED', 'COMPLETED', 'EXPIRED', 'CANCELLED'};
    return !blocked.contains(n.status);
  }

  bool _isDisputeMediationActive(NegotiationEntity n) =>
      NegotiationStatusDisplay.isLinkedOrderDisputed(n);

  Widget _buildDisputeMediationBanner(
    BuildContext context,
    NegotiationEntity n,
  ) {
    final orderRoute = NegotiationStatusDisplay.disputeOrderRoute(n);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.section, vertical: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gavel_outlined, size: 18.sp, color: AppColors.warning),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'negotiation.dispute_mediation_active'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'negotiation.dispute_mediation_subtitle'.tr(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'negotiation.dispute_mediation_parties'.tr(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (orderRoute != null) ...[
            SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: () => context.push(orderRoute),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'detail'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _sendInvoicePdfToChat(
    BuildContext context,
    NegotiationEntity n,
  ) async {
    final orderId = n.order?.id ?? n.orderId;
    if (orderId == null || orderId.isEmpty) {
      showErrorSnackBar(context, 'invoice.error_not_issued_negotiation'.tr());
      return;
    }

    var result = await sl<OrderRepository>().getOrderDetail(orderId);
    // Refresh detail sekali jika order stale / belum sinkron setelah terbit tagihan.
    if (result.isLeft()) {
      final refreshed = await sl<NegotiationRepository>().getNegotiationDetail(n.id);
      if (!context.mounted) return;
      final freshOrderId = refreshed.fold(
        (_) => null,
        (nego) => nego.order?.id ?? nego.orderId,
      );
      if (freshOrderId != null && freshOrderId.isNotEmpty) {
        result = await sl<OrderRepository>().getOrderDetail(freshOrderId);
      }
    }
    if (!context.mounted) return;
    await result.fold(
      (failure) async {
        showFailureSnackBarFromMessage(context, failure.message);
      },
      (order) async {
        await InvoiceExportHelper.sendOrderToChat(context, n.id, order);
        if (context.mounted) {
          context.read<NegotiationCubit>().getDetail(n.id, showLoading: false);
        }
      },
    );
  }

  Future<void> _downloadInvoice(BuildContext context, String? orderId) async {
    final resolved = orderId?.trim();
    if (resolved == null || resolved.isEmpty) {
      showErrorSnackBar(context, 'invoice.error_not_issued_negotiation'.tr());
      return;
    }
    final result = await sl<OrderRepository>().getOrderDetail(resolved);
    if (!context.mounted) return;
    result.fold(
      (failure) {
        showFailureSnackBarFromMessage(context, failure.message);
      },
      (order) => InvoiceExportHelper.exportOrder(context, order),
    );
  }

  Future<void> _sendPartnershipProposalToChat(
    BuildContext context,
    NegotiationEntity n,
  ) async {
    final existing =
        await PartnershipPdfExportHelper.findPartnershipWithSupplier(n.sellerId);
    if (!context.mounted) return;

    if (existing != null &&
        existing.status != 'REJECTED' &&
        existing.status != 'TERMINATED') {
      final ok = await PartnershipPdfExportHelper.showSendProposalSheet(
        context,
        negotiationId: n.id,
        partnership: existing,
        openChatAfter: false,
      );
      if (ok && context.mounted) {
        context.read<NegotiationCubit>().getDetail(n.id, showLoading: false);
      }
      return;
    }

    context.push(
      '/partnerships/create/${n.sellerId}',
      extra: {
        'name': n.seller.name,
        'negotiationId': n.id,
      },
    );
  }

  Future<void> _showAttachOptions(
    BuildContext context,
    NegotiationEntity n,
    dynamic currentUser,
  ) async {
    final isSupplier = currentUser?.id == n.sellerId;
    final canSendInvoicePdf =
        isSupplier && (n.status == 'OFFER_ACCEPTED' || _hasIssuedInvoice(n));

    await showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md12, AppSpacing.md, AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_outlined, color: AppColors.primary),
                  title: Text('negotiation.send_photo'.tr()),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (picked != null && context.mounted) {
                      context.read<NegotiationCubit>().sendChat(
                            n.id,
                            '📷 Foto lampiran',
                            currentUser?.id ?? 'me',
                            localFilePath: picked.path,
                          );
                    }
                  },
                ),
                if (canSendInvoicePdf)
                  ListTile(
                    leading: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
                    title: Text('negotiation.send_invoice_pdf'.tr()),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      if (_hasIssuedInvoice(n)) {
                        await _sendInvoicePdfToChat(context, n);
                      } else if (n.status == 'OFFER_ACCEPTED') {
                        final previewResult =
                            await sl<InvoiceRepository>().getInvoicePreview(n.id);
                        if (!context.mounted) return;
                        await previewResult.fold(
                          (failure) async {
                            showFailureSnackBarFromMessage(context, failure.message);
                          },
                          (preview) async {
                            await InvoiceExportHelper.sendPreviewToChat(
                              context,
                              n.id,
                              preview,
                            );
                            if (context.mounted) {
                              context.read<NegotiationCubit>().getDetail(
                                    n.id,
                                    showLoading: false,
                                  );
                            }
                          },
                        );
                      }
                    },
                  ),
                if (currentUser?.id == n.buyerId)
                  ListTile(
                    leading: Icon(
                      LucideIcons.handshake,
                      color: AppColors.success,
                      size: 22.sp,
                    ),
                    title: Text('negotiation.send_partnership_proposal'.tr()),
                    subtitle: Text(
                      'negotiation.send_partnership_proposal_hint'.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      await _sendPartnershipProposalToChat(context, n);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSupplierReject(
    BuildContext context,
    NegotiationEntity n,
  ) async {
    final reason = await NegotiationClosureDialog.show(
      context,
      action: NegotiationClosureAction.rejectBySupplier,
    );
    if (reason != null && context.mounted) {
      context.read<NegotiationCubit>().rejectOffer(
            n.id,
            rejectionReason: reason,
          );
    }
  }

  Future<void> _handleBuyerCancel(
    BuildContext context,
    NegotiationEntity n,
  ) async {
    final reason = await NegotiationClosureDialog.show(
      context,
      action: NegotiationClosureAction.cancelByBuyer,
    );
    if (reason != null && context.mounted) {
      context.read<NegotiationCubit>().cancelNegotiation(
            n.id,
            cancellationReason: reason,
          );
    }
  }

  Widget _buildClosureReasonBanner(NegotiationEntity n, bool isSupplier) {
    final reason = n.rejectionReason?.trim();
    if (reason == null || reason.isEmpty) return const SizedBox.shrink();

    final title = NegotiationStatusDisplay.closureTitle(
      n.status,
      isSupplier: isSupplier,
    );
    final source = NegotiationStatusDisplay.closureSourceLabel(n.closedBy);
    final color =
        n.status == 'EXPIRED' ? AppColors.textHint : AppColors.error;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm10, horizontal: AppSpacing.md),
      color: color.withValues(alpha: 0.08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            n.status == 'EXPIRED' ? Icons.schedule : Icons.info_outline,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  source,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  reason,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    NegotiationEntity n,
    bool isSupplier,
    dynamic currentUser,
  ) {
    return SafeArea(
      top: false,
      child: Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md12, AppSpacing.md, AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xlPx.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Action Buttons (supplier: terima / tolak / nego ulang)
          if (!_isInquiryMode(n) && _canRespondToOffer(n.status)) ...[
            if (isSupplier)
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'tolak'.tr(),
                      icon: Icons.cancel_outlined,
                      color: AppColors.error,
                      onTap: () => _handleSupplierReject(context, n),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md12),
                  Expanded(
                    child: _buildActionButton(
                      label: 'nego_ulang'.tr(),
                      icon: Icons.refresh_rounded,
                      color: AppColors.primary,
                      onTap: () => _showCounterOfferDialog(context, n),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md12),
                  Expanded(
                    child: _buildActionButton(
                      label: 'terima'.tr(),
                      icon: Icons.check_circle_outline,
                      color: AppColors.secondary,
                      isFilled: true,
                      onTap: () => _showAcceptOfferDialog(context, n),
                    ),
                  ),
                ],
              )
            else ...[
              _buildInvoiceWaitingBanner(
                title: 'negotiation.banner_waiting_supplier'.tr(),
                subtitle: 'negotiation.banner_waiting_review_subtitle'.tr(),
              ),
              SizedBox(height: AppSpacing.md12),
              _buildActionButton(
                label: 'batalkan_negosiasi'.tr(),
                icon: Icons.cancel_outlined,
                color: AppColors.error,
                isHorizontal: true,
                onTap: () => _handleBuyerCancel(context, n),
              ),
            ],
            SizedBox(height: AppSpacing.md),
          ],

          // Supplier: nego ulang setelah tawaran diterima (sebelum tagihan)
          if (!_isInquiryMode(n) && isSupplier && _canRenegotiateAfterAccept(n)) ...[
            _buildActionButton(
              label: 'nego_ulang'.tr(),
              icon: Icons.refresh_rounded,
              color: AppColors.primary,
              isHorizontal: true,
              onTap: () => _showCounterOfferDialog(context, n),
            ),
            SizedBox(height: AppSpacing.md),
          ],

          // Supplier: terbitkan tagihan setelah tawaran diterima
          if (!_isInquiryMode(n) &&
              isSupplier &&
              n.status == 'OFFER_ACCEPTED' &&
              !n.isLocked) ...[
            _buildActionButton(
              label: 'invoice.issue_button'.tr(),
              icon: Icons.receipt_long_outlined,
              color: AppColors.primary,
              isFilled: true,
              isHorizontal: true,
              onTap: () => _openCreateInvoicePage(context, n),
            ),
            SizedBox(height: AppSpacing.md),
          ],

          // Supplier: tagihan sudah diterbitkan
          if (!_isInquiryMode(n) && isSupplier && _hasIssuedInvoice(n)) ...[
            _buildIssuedInvoiceActions(context, n),
            SizedBox(height: AppSpacing.md),
          ],

          // Buyer: review tagihan dari supplier (collapse/expand)
          if (!_isInquiryMode(n) && !isSupplier && _hasIssuedInvoice(n)) ...[
            _buildCollapsibleInvoiceSection(
              context,
              n,
              showPaymentPrompt: _orderNeedsPayment(n),
            ),
            SizedBox(height: AppSpacing.md12),
          ],

          // Input Field — chat tetap aktif setelah tagihan diterbitkan
          if (_canSendChat(n)) ...[
            if (_editingMessageId != null) ...[
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: AppSpacing.sm),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 16.sp, color: AppColors.warning),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'negotiation.editing_message'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _cancelEditMessage,
                      child: Text(
                        'batal'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: AppSpacing.md12),
                        // Handwriting input button
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppColors.transparent,
                              builder: (_) => HandwritingInputSheet(
                                onResult: (text) {
                                  _messageController.text =
                                      '${_messageController.text}$text';
                                  _messageController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _messageController.text.length,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Icon(
                            Icons.draw_outlined,
                            size: 20.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Icon(
                          Icons.emoji_emotions_outlined,
                          size: 20.sp,
                          color: AppColors.textHint,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(fontSize: 14.sp),
                            onChanged: (val) {
                              if (!_isCurrentlyTyping && val.isNotEmpty) {
                                _isCurrentlyTyping = true;
                                context
                                    .read<NegotiationCubit>()
                                    .updateTypingStatus(
                                      widget.negotiationId,
                                      true,
                                    );
                              }

                              _typingTimer?.cancel();
                              _typingTimer = Timer(
                                const Duration(seconds: 2),
                                () {
                                  if (_isCurrentlyTyping) {
                                    _isCurrentlyTyping = false;
                                    context
                                        .read<NegotiationCubit>()
                                        .updateTypingStatus(
                                          widget.negotiationId,
                                          false,
                                        );
                                  }
                                },
                              );
                            },
                            decoration: InputDecoration(
                              hintText: _editingMessageId != null
                                  ? 'negotiation.hint_edit_message'.tr()
                                  : 'negotiation.hint_write_message'.tr(),
                              hintStyle: TextStyle(color: AppColors.textHint),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md12,
                                vertical: AppSpacing.md12,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            size: 18.sp,
                            color: AppColors.textHint,
                          ),
                          onPressed: () =>
                              _showAttachOptions(context, n, currentUser),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md12),
                GestureDetector(
                  onTap: () => _handleSendMessage(context, n, currentUser?.id),
                  child: Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _editingMessageId != null
                            ? Icons.check_rounded
                            : Icons.send_rounded,
                        color: AppColors.surface,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
          ],
        ],
      ),
    ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isFilled = false,
    bool isHorizontal = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isHorizontal ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          vertical: isHorizontal ? AppSpacing.section : AppSpacing.sm10,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isFilled ? color : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color, width: 1.5),
        ),
        child: isHorizontal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 20.sp,
                    color: isFilled ? AppColors.white : color,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: isFilled ? AppColors.white : color,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(
                    icon,
                    size: 18.sp,
                    color: isFilled ? AppColors.white : color,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: isFilled ? AppColors.white : color,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }

  void _showAcceptOfferDialog(BuildContext context, NegotiationEntity n) {
    final priceController = TextEditingController(
      text: n.pricePerUnit.toString(),
    );
    final qtyController = TextEditingController(text: n.quantity.toString());

    showBisaFormDialog(
      context,
      title: 'negotiation.action_accept_offer'.tr(),
      submitText: 'terima_1'.tr(),
      fields: [
        CustomTextField(
          label: 'negotiation.qty_label_unit'.tr(namedArgs: {'unit': n.product.unit}),
          hint: 'negotiation.adjust_qty_hint'.tr(),
          controller: qtyController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'harga_per_unit'.tr(),
          hint: 'negotiation.adjust_price_hint'.tr(),
          controller: priceController,
          keyboardType: TextInputType.number,
        ),
      ],
      onSubmit: () {
        final newQty = double.tryParse(qtyController.text);
        final newPrice = double.tryParse(priceController.text);
        if (newQty == null || newPrice == null) return false;
        if (newQty < n.product.minOrder) {
          showErrorSnackBar(
            context,
            'negotiation.min_order_hint'.tr(namedArgs: {
              'qty': ProductPricingInfo.formatQty(n.product.minOrder),
              'unit': n.product.unit,
            }),
          );
          return false;
        }
        context.read<NegotiationCubit>().acceptOffer(
              n.id,
              quantity: newQty,
              pricePerUnit: newPrice,
            );
        return true;
      },
    );
  }

  void _showCounterOfferDialog(BuildContext context, NegotiationEntity n) {
    final priceController = TextEditingController(
      text: n.pricePerUnit.toString(),
    );
    final qtyController = TextEditingController(text: n.quantity.toString());

    showBisaFormDialog(
      context,
      title: 'nego_ulang'.tr(),
      submitText: 'kirim_tawaran'.tr(),
      fields: [
        CustomTextField(
          label: 'negotiation.qty_label_unit'.tr(namedArgs: {'unit': n.product.unit}),
          hint: 'masukkan_jumlah'.tr(),
          controller: qtyController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'harga_per_unit'.tr(),
          hint: 'masukkan_harga'.tr(),
          controller: priceController,
          keyboardType: TextInputType.number,
        ),
      ],
      onSubmit: () {
        final newQty = double.tryParse(qtyController.text);
        final newPrice = double.tryParse(priceController.text);
        if (newQty == null || newPrice == null) return false;
        if (newQty < n.product.minOrder) {
          showErrorSnackBar(
            context,
            'negotiation.min_order_hint'.tr(namedArgs: {
              'qty': ProductPricingInfo.formatQty(n.product.minOrder),
              'unit': n.product.unit,
            }),
          );
          return false;
        }
        context.read<NegotiationCubit>().counterOffer(
          n.id,
          quantity: newQty,
          pricePerUnit: newPrice,
        );
        return true;
      },
    );
  }

  Future<void> _openCreateInvoicePage(
    BuildContext context,
    NegotiationEntity n,
  ) async {
    final issued = await context.push<bool>(
      '/negotiation/${n.id}/create-invoice',
    );
    if (issued == true && context.mounted) {
      context.read<NegotiationCubit>().getDetail(
            widget.negotiationId,
            showLoading: false,
          );
    }
  }

  Future<void> _openEditInvoicePage(
    BuildContext context,
    NegotiationEntity n,
  ) async {
    final updated = await context.push<bool>(
      '/negotiation/${n.id}/edit-invoice',
    );
    if (updated == true && context.mounted) {
      context.read<NegotiationCubit>().getDetail(
            widget.negotiationId,
            showLoading: false,
          );
    }
  }

  Future<void> _navigateToReviewInvoice(
    BuildContext context,
    NegotiationEntity n,
  ) async {
    await context.push('/negotiation/${n.id}/review-invoice');
    if (context.mounted) {
      context.read<NegotiationCubit>().getDetail(
            widget.negotiationId,
            showLoading: false,
          );
    }
  }

  Widget _buildIssuedInvoiceActions(BuildContext context, NegotiationEntity n) {
    final waitingPayment = _orderNeedsPayment(n);
    return Column(
      children: [
        _buildInvoiceWaitingBanner(
          title: waitingPayment
              ? 'negotiation.invoice_sent_title'.tr()
              : 'negotiation.invoice_paid_title'.tr(),
          subtitle: waitingPayment
              ? 'negotiation.invoice_sent_subtitle'.tr()
              : 'negotiation.invoice_paid_subtitle'.tr(),
        ),
        if (!waitingPayment) ...[
          SizedBox(height: AppSpacing.sm10),
          CustomButton(
            text: 'negotiation.action_view_order'.tr(),
            height: AppSpacing.buttonHeightSm,
            isOutlined: true,
            onPressed: () => context.push(_orderDetailRoute(n)),
          ),
        ],
        SizedBox(height: AppSpacing.sm10),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'negotiation.action_view_invoice'.tr(),
                height: AppSpacing.buttonHeightSm,
                isOutlined: true,
                onPressed: () => _navigateToReviewInvoice(context, n),
              ),
            ),
            SizedBox(width: AppSpacing.sm10),
            Expanded(
              child: CustomButton(
                text: 'invoice.action_edit'.tr(),
                height: AppSpacing.buttonHeightSm,
                isOutlined: true,
                onPressed: () => _openEditInvoicePage(context, n),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        CustomButton(
          text: 'invoice.action_download_pdf'.tr(),
          height: AppSpacing.buttonHeightSm,
          isOutlined: true,
          onPressed: () => _downloadInvoice(context, n.order?.id ?? n.orderId),
        ),
        SizedBox(height: AppSpacing.sm),
        CustomButton(
          text: 'negotiation.send_pdf_to_chat'.tr(),
          height: AppSpacing.buttonHeightSm,
          isOutlined: true,
          onPressed: () => _sendInvoicePdfToChat(context, n),
        ),
      ],
    );
  }

  Widget _buildInvoiceWaitingBanner({
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.hourglass_top_rounded, color: AppColors.primary, size: 22.sp),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleInvoiceSection(
    BuildContext context,
    NegotiationEntity n, {
    required bool showPaymentPrompt,
  }) {
    final expanded = _invoicePanelExpanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: selalu terlihat — tap untuk show/hide detail
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            onTap: () => setState(() => _invoicePanelExpanded = !expanded),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md12,
                vertical: AppSpacing.md12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'negotiation.invoice_from_supplier'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (!expanded) ...[
                          SizedBox(height: 2.h),
                          Text(
                            formatMoneyIdr(n.totalEstimate),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    expanded
                        ? 'negotiation.invoice_panel_hide'.tr()
                        : 'negotiation.invoice_panel_show'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: expanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSpacing.sm10),
                    _buildInvoiceReviewCard(
                      n,
                      showPaymentPrompt: showPaymentPrompt,
                      showHeader: false,
                    ),
                    if (showPaymentPrompt) ...[
                      SizedBox(height: AppSpacing.md12),
                      CustomButton(
                        text: 'negotiation.action_review_pay'.tr(),
                        useGradient: true,
                        height: 48.h,
                        onPressed: () => _navigateToReviewInvoice(context, n),
                      ),
                      SizedBox(height: AppSpacing.sm),
                    ] else ...[
                      SizedBox(height: AppSpacing.md12),
                      _buildInvoiceWaitingBanner(
                        title: 'negotiation.banner_payment_received'.tr(),
                        subtitle: 'negotiation.banner_order_processing'
                            .tr(namedArgs: {
                          'orderNumber': n.order?.orderNumber ?? '',
                        }),
                      ),
                      SizedBox(height: AppSpacing.sm10),
                      CustomButton(
                        text: 'negotiation.action_view_order'.tr(),
                        useGradient: true,
                        height: 48.h,
                        onPressed: () => context.push(_orderDetailRoute(n)),
                      ),
                      SizedBox(height: AppSpacing.sm),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'negotiation.action_view_invoice'.tr(),
                            height: AppSpacing.buttonHeightSm,
                            isOutlined: true,
                            onPressed: () =>
                                _navigateToReviewInvoice(context, n),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm10),
                        Expanded(
                          child: CustomButton(
                            text: 'invoice.action_download_pdf'.tr(),
                            height: AppSpacing.buttonHeightSm,
                            isOutlined: true,
                            onPressed: () =>
                                _downloadInvoice(context, n.order?.id ?? n.orderId),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : (showPaymentPrompt
                  ? Padding(
                      padding: EdgeInsets.only(top: AppSpacing.sm10),
                      child: CustomButton(
                        text: 'negotiation.action_review_pay'.tr(),
                        useGradient: true,
                        height: AppSpacing.buttonHeightSm,
                        onPressed: () => _navigateToReviewInvoice(context, n),
                      ),
                    )
                  : const SizedBox.shrink()),
        ),
      ],
    );
  }

  Widget _buildInvoiceReviewCard(
    NegotiationEntity n, {
    required bool showPaymentPrompt,
    bool showHeader = true,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            Row(
              children: [
                Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20.sp),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'negotiation.invoice_from_supplier'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md12),
          ],
          _invoiceRow('invoice.label_product'.tr(), n.product.name),
          _invoiceRow(
            'invoice.label_qty'.tr(),
            '${n.quantity.toStringAsFixed(0)} ${n.product.unit}',
          ),
          _invoiceRow('invoice.label_price_unit'.tr(), formatMoneyIdr(n.pricePerUnit)),
          Divider(height: AppSpacing.lg, color: AppColors.grey200),
          _invoiceRow(
            'invoice.breakdown_total'.tr(),
            formatMoneyIdr(n.totalEstimate),
            isBold: true,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            showPaymentPrompt
                ? 'negotiation.invoice_review_buyer'.tr()
                : 'negotiation.invoice_paid_buyer'.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoiceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySecondary(color: AppColors.textSecondary),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: isBold ? 14.sp : 12.sp,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: isBold ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStatus(NegotiationMessageEntity msg) {
    if (msg.isRead) {
      return Icon(
        Icons.done_all_rounded,
        size: 14.sp,
        color: AppColors.secondary,
      );
    } else {
      return Icon(
        Icons.done_rounded,
        size: 14.sp,
        color: AppColors.white.withValues(alpha: 0.5),
      );
    }
  }

  void _cancelEditMessage() {
    setState(() {
      _editingMessageId = null;
      _messageController.clear();
    });
  }

  Future<void> _handleSendMessage(
    BuildContext context,
    NegotiationEntity n,
    String? userId,
  ) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final command = text.toLowerCase();
    if (command == '/clear' || command == '/bersihkan') {
      _messageController.clear();
      await _confirmClearChat(context);
      return;
    }
    if (command == '/bantuan' || command == '/help') {
      _messageController.clear();
      _showChatCommandsHelp(context);
      return;
    }
    if (command == '/negosiasi' || command == '/negotiate') {
      _messageController.clear();
      final summary = _buildNegotiationSummaryMessage(n);
      context.read<NegotiationCubit>().sendChat(
            n.id,
            summary,
            userId ?? 'me',
          );
      return;
    }

    if (_editingMessageId != null) {
      final messageId = _editingMessageId!;
      _cancelEditMessage();
      await context.read<NegotiationCubit>().editChatMessage(
            n.id,
            messageId,
            text,
          );
      return;
    }

    context.read<NegotiationCubit>().sendChat(
          n.id,
          text,
          userId ?? 'me',
        );
    _messageController.clear();
  }

  String _buildNegotiationSummaryMessage(NegotiationEntity n) {
    final statusLabel = NegotiationStatusDisplay.forRoom(
      n.status,
      isSupplier: false,
      orderStatus: n.order?.status,
    ).label;
    return '📋 ${'negotiation.summary_title'.tr()}\n'
        '${'negotiation.summary_product'.tr()}: ${n.product.name}\n'
        '${'negotiation.summary_qty'.tr()}: ${n.quantity.toStringAsFixed(0)} ${n.product.unit}\n'
        '${'negotiation.summary_price_unit'.tr()}: ${formatMoneyIdr(n.pricePerUnit)}\n'
        '${'negotiation.summary_total'.tr()}: ${formatMoneyIdr(n.totalEstimate)}\n'
        '${'negotiation.summary_status'.tr()}: $statusLabel';
  }

  void _showChatCommandsHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'negotiation.chat_commands_title'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.md12),
              _commandHelpRow(
                '/negosiasi',
                'negotiation.command_help_negosiasi'.tr(),
              ),
              _commandHelpRow(
                '/bersihkan',
                'negotiation.command_help_bersihkan'.tr(),
              ),
              _commandHelpRow(
                '/bantuan',
                'negotiation.command_help_bantuan'.tr(),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'negotiation.command_long_press_hint'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              CustomButton(
                text: 'negotiation.understood'.tr(),
                height: AppSpacing.buttonHeightSm,
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commandHelpRow(String command, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            command,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRoomMenu(BuildContext context) {
    final n = _cachedNegotiation;
    final canClear =
        n != null && NegotiationStatusDisplay.canClearChat(n);
    final blockedReason = n != null
        ? NegotiationStatusDisplay.clearChatBlockedReason(n)
        : '';

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              enabled: canClear,
              leading: Icon(
                Icons.cleaning_services_outlined,
                color: canClear ? null : AppColors.textHint,
              ),
              title: Text(
                'negotiation.clear_chat_title'.tr(),
                style: TextStyle(
                  color: canClear ? null : AppColors.textHint,
                ),
              ),
              subtitle: Text(
                canClear
                    ? 'negotiation.clear_chat_subtitle'.tr()
                    : blockedReason,
                style: TextStyle(
                  color: canClear
                      ? AppColors.textSecondary
                      : AppColors.warning,
                  fontSize: 11.sp,
                ),
              ),
              onTap: canClear
                  ? () {
                      Navigator.pop(ctx);
                      _confirmClearChat(context);
                    }
                  : () {
                      Navigator.pop(ctx);
                      showWarningSnackBar(context, blockedReason);
                    },
            ),
            ListTile(
              leading: const Icon(Icons.terminal_outlined),
              title: Text('negotiation.chat_commands_title'.tr()),
              subtitle: Text('negotiation.chat_commands_subtitle'.tr()),
              onTap: () {
                Navigator.pop(ctx);
                _showChatCommandsHelp(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClearChat(BuildContext context) async {
    final confirmed = await showBisaConfirmDialog(
      context,
      title: 'negotiation.clear_chat_confirm_title'.tr(),
      message: 'negotiation.clear_chat_confirm_body'.tr(),
      confirmText: 'negotiation.confirm_clear'.tr(),
      destructive: true,
    );
    if (confirmed == true && context.mounted) {
      await context.read<NegotiationCubit>().clearChatMessages(widget.negotiationId);
    }
  }

  void _showMessageActions(
    BuildContext context,
    NegotiationEntity n,
    NegotiationMessageEntity msg,
  ) {
    final canEdit = msg.content.trim().isNotEmpty &&
        DateTime.now().difference(msg.createdAt) <= const Duration(hours: 24);

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canEdit)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text('negotiation.edit_message'.tr()),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _editingMessageId = msg.id;
                    _messageController.text = msg.content;
                    _messageController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _messageController.text.length),
                    );
                  });
                },
              ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                'negotiation.delete_message_title'.tr(),
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showBisaConfirmDialog(
                  context,
                  title: 'negotiation.delete_message_confirm_title'.tr(),
                  message: 'negotiation.delete_message_confirm_body'.tr(),
                  confirmText: 'hapus'.tr(),
                  destructive: true,
                );
                if (confirmed == true && context.mounted) {
                  await context.read<NegotiationCubit>().deleteChatMessage(
                        n.id,
                        msg.id,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
