import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_bisa/core/core.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/core/utils/product_pricing.dart';
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
import 'package:mobile_bisa/features/negotiation/presentation/widgets/negotiation_closure_dialog.dart';
import 'package:mobile_bisa/features/invoice/domain/repositories/invoice_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NegotiationCubit>()
        ..getDetail(widget.negotiationId)
        ..subscribeToNegotiation(widget.negotiationId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          backgroundColor: Colors.white,
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
                      ? 'Chat dengan toko'
                      : 'Negosiasi'.tr(),
                );
              }
              if (_isInquiryMode(n)) {
                return Text('Chat dengan toko');
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
                  SizedBox(width: 12.w),
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
                              'Online',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (isTyping) ...[
                              SizedBox(width: 8.w),
                              Text(
                                'sedang mengetik...',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              },
              error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              ),
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
                                  horizontal: 16.w,
                                  vertical: 20.h,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: n.messages!.length +
                                    (hasOlderMessages ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (hasOlderMessages && index == 0) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: Center(
                                        child: isLoadingOlder
                                            ? SizedBox(
                                                width: 24.r,
                                                height: 24.r,
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
      dateText = 'Hari Ini';
    } else if (_isSameDay(date, yesterday)) {
      dateText = 'Kemarin';
    } else {
      dateText = DateFormat('d MMMM yyyy').format(date);
    }

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.grey200.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8.r),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data negosiasi tidak sesuai akun. Buka ulang dari daftar chat.',
          ),
        ),
      );
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
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
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
                SizedBox(width: 12.w),
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
                      (n.product.pricePerUnit * n.quantity).toRupiah,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Chat tanya produk',
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
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
            color: AppColors.info.withValues(alpha: 0.05),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 12.sp, color: AppColors.info),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    isSupplier
                        ? 'Pembeli bertanya — balas seperti chat biasa. Tawar harga ada di ruang negosiasi terpisah.'
                        : 'Untuk tawar harga gunakan tombol Nego Harga di halaman produk.',
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
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Row(
              children: [
                // Product Image
                GestureDetector(
                  onTap: () => _openProductContext(n, userId),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
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
                              borderRadius: BorderRadius.circular(12.r),
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
                SizedBox(width: 12.w),
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
                              ? 'Info produk negosiasi →'
                              : 'Lihat detail produk →',
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
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
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
                          (n.product.pricePerUnit * n.quantity).toRupiah,
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
                      (n.totalEstimate as num).toRupiah,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
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
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
              color: AppColors.warning.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 12.sp,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Menunggu respon tawar-menawar',
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
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppColors.softShadow,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 40.sp,
              color: AppColors.grey300,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Belum ada percakapan',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            inquiry
                ? 'Kirim pesan untuk bertanya ke penjual'
                : 'Mulai negosiasi dengan mengirim pesan',
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
          margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16.r),
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
                    'Hakim BISA',
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
          margin: EdgeInsets.symmetric(vertical: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.grey200.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, size: 12.sp, color: AppColors.textHint),
              SizedBox(width: 8.w),
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
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.grey200.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Pesan dihapus',
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
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14.r,
              backgroundColor: AppColors.grey200,
              child: Icon(Icons.person, size: 14.sp, color: AppColors.grey400),
            ),
            SizedBox(width: 8.w),
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
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
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
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (msg.content.trim().isNotEmpty)
                        Text(
                          msg.content,
                          style: TextStyle(
                            color: isMe ? Colors.white : AppColors.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      if (msg.attachmentUrl != null &&
                          msg.attachmentUrl!.isNotEmpty) ...[
                        if (msg.content.trim().isNotEmpty) SizedBox(height: 8.h),
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
        borderRadius: BorderRadius.circular(10.r),
        child: BisaNetworkImage(
          imageUrl: url,
          width: 180.w,
          height: 120.h,
          fit: BoxFit.cover,
        ),
      );
    }

    final linkColor = isMe ? Colors.white : AppColors.primary;
    return InkWell(
      onTap: () => _openAttachment(url),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.white.withValues(alpha: 0.15)
              : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isMe
                ? Colors.white.withValues(alpha: 0.35)
                : AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf, color: linkColor, size: 22.sp),
            SizedBox(width: 8.w),
            Text(
              'Buka PDF Tagihan',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak bisa membuka lampiran'),
            backgroundColor: AppColors.error,
          ),
        );
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
    return '/orders/$orderId';
  }

  bool _canSendChat(NegotiationEntity n) {
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
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gavel_outlined, size: 18.sp, color: AppColors.warning),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mediasi sengketa aktif',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Diskusikan masalah di chat ini seperti grup — pembeli, supplier, dan Admin BISA bisa saling balas.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (orderRoute != null) ...[
            SizedBox(width: 8.w),
            TextButton(
              onPressed: () => context.push(orderRoute),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Detail',
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
    if (n.orderId == null) return;
    final result = await sl<OrderRepository>().getOrderDetail(n.orderId!);
    if (!context.mounted) return;
    await result.fold(
      (failure) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (order) async {
        await InvoiceExportHelper.sendOrderToChat(context, n.id, order);
        if (context.mounted) {
          context.read<NegotiationCubit>().getDetail(n.id, showLoading: false);
        }
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_outlined, color: AppColors.primary),
                  title: const Text('Kirim Foto'),
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
                    title: const Text('Kirim PDF Tagihan'),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(failure.message),
                                backgroundColor: AppColors.error,
                              ),
                            );
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
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadInvoice(BuildContext context, String orderId) async {
    final result = await sl<OrderRepository>().getOrderDetail(orderId);
    if (!context.mounted) return;
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (order) => InvoiceExportHelper.exportOrder(context, order),
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
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      color: color.withValues(alpha: 0.08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            n.status == 'EXPIRED' ? Icons.schedule : Icons.info_outline,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 8.w),
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
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                      label: 'tolak_1'.tr().tr(),
                      icon: Icons.cancel_outlined,
                      color: AppColors.error,
                      onTap: () => _handleSupplierReject(context, n),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildActionButton(
                      label: 'negoulang'.tr().tr(),
                      icon: Icons.refresh_rounded,
                      color: AppColors.primary,
                      onTap: () => _showCounterOfferDialog(context, n),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildActionButton(
                      label: 'terima_1'.tr().tr(),
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
                title: 'Menunggu Konfirmasi Supplier',
                subtitle:
                    'Tawaran Anda sedang ditinjau. Supplier akan merespons segera.',
              ),
              SizedBox(height: 12.h),
              _buildActionButton(
                label: 'batalkannegosiasi'.tr().tr(),
                icon: Icons.cancel_outlined,
                color: AppColors.error,
                isHorizontal: true,
                onTap: () => _handleBuyerCancel(context, n),
              ),
            ],
            SizedBox(height: 16.h),
          ],

          // Supplier: nego ulang setelah tawaran diterima (sebelum tagihan)
          if (!_isInquiryMode(n) && isSupplier && _canRenegotiateAfterAccept(n)) ...[
            _buildActionButton(
              label: 'negoulang'.tr().tr(),
              icon: Icons.refresh_rounded,
              color: AppColors.primary,
              isHorizontal: true,
              onTap: () => _showCounterOfferDialog(context, n),
            ),
            SizedBox(height: 16.h),
          ],

          // Supplier: terbitkan tagihan setelah tawaran diterima
          if (!_isInquiryMode(n) &&
              isSupplier &&
              n.status == 'OFFER_ACCEPTED' &&
              !n.isLocked) ...[
            _buildActionButton(
              label: 'Terbitkan Tagihan',
              icon: Icons.receipt_long_outlined,
              color: AppColors.primary,
              isFilled: true,
              isHorizontal: true,
              onTap: () => _openCreateInvoicePage(context, n),
            ),
            SizedBox(height: 16.h),
          ],

          // Supplier: tagihan sudah diterbitkan
          if (!_isInquiryMode(n) && isSupplier && _hasIssuedInvoice(n)) ...[
            _buildIssuedInvoiceActions(context, n),
            SizedBox(height: 16.h),
          ],

          // Buyer: review tagihan dari supplier
          if (!_isInquiryMode(n) && !isSupplier && _hasIssuedInvoice(n)) ...[
            _buildInvoiceReviewCard(
              n,
              showPaymentPrompt: _orderNeedsPayment(n),
            ),
            if (_orderNeedsPayment(n)) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Review & Bayar',
                      useGradient: true,
                      height: 48.h,
                      onPressed: () => _navigateToReviewInvoice(context, n),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ] else ...[
              SizedBox(height: 12.h),
              _buildInvoiceWaitingBanner(
                title: 'Pembayaran Diterima',
                subtitle:
                    'Pesanan ${n.order?.orderNumber ?? ''} sedang diproses. Pantau progres di detail pesanan.',
              ),
              SizedBox(height: 10.h),
              CustomButton(
                text: 'Lihat Pesanan',
                useGradient: true,
                height: 48.h,
                onPressed: () => context.push(_orderDetailRoute(n)),
              ),
              SizedBox(height: 8.h),
            ],
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Lihat Tagihan',
                    height: 44.h,
                    isOutlined: true,
                    onPressed: () => _navigateToReviewInvoice(context, n),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomButton(
                    text: 'Download PDF',
                    height: 44.h,
                    isOutlined: true,
                    onPressed: () => _downloadInvoice(context, n.orderId!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],

          // Input Field — chat tetap aktif setelah tagihan diterbitkan
          if (_canSendChat(n)) ...[
            if (_editingMessageId != null) ...[
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 16.sp, color: AppColors.warning),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Mengedit pesan',
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
                        'Batal',
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 12.w),
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
                                  ? 'Ubah pesan...'
                                  : 'Tulis pesan... (/bantuan)',
                              hintStyle: TextStyle(color: AppColors.textHint),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
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
                SizedBox(width: 12.w),
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
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
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
          vertical: isHorizontal ? 14.h : 10.h,
          horizontal: 8.w,
        ),
        decoration: BoxDecoration(
          color: isFilled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color, width: 1.5),
        ),
        child: isHorizontal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 20.sp,
                    color: isFilled ? Colors.white : color,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: isFilled ? Colors.white : color,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(
                    icon,
                    size: 18.sp,
                    color: isFilled ? Colors.white : color,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: isFilled ? Colors.white : color,
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
      title: 'Terima Tawaran',
      submitText: 'terima_1'.tr(),
      fields: [
        CustomTextField(
          label: 'Jumlah (${n.product.unit})',
          hint: 'Sesuaikan jumlah jika perlu',
          controller: qtyController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: 'Harga per Unit',
          hint: 'Sesuaikan harga jika perlu',
          controller: priceController,
          keyboardType: TextInputType.number,
        ),
      ],
      onSubmit: () {
        final newQty = double.tryParse(qtyController.text);
        final newPrice = double.tryParse(priceController.text);
        if (newQty == null || newPrice == null) return false;
        if (newQty < n.product.minOrder) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Min. order ${ProductPricingInfo.formatQty(n.product.minOrder)} ${n.product.unit}',
              ),
              backgroundColor: AppColors.error,
            ),
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
      title: 'Nego Ulang',
      submitText: 'kirim_tawaran'.tr(),
      fields: [
        CustomTextField(
          label: 'Jumlah (${n.product.unit})',
          hint: 'Masukkan jumlah',
          controller: qtyController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: 'Harga per Unit',
          hint: 'Masukkan harga',
          controller: priceController,
          keyboardType: TextInputType.number,
        ),
      ],
      onSubmit: () {
        final newQty = double.tryParse(qtyController.text);
        final newPrice = double.tryParse(priceController.text);
        if (newQty == null || newPrice == null) return false;
        if (newQty < n.product.minOrder) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Min. order ${ProductPricingInfo.formatQty(n.product.minOrder)} ${n.product.unit}',
              ),
              backgroundColor: AppColors.error,
            ),
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
          title: waitingPayment ? 'Tagihan Terkirim' : 'Pembayaran Diterima',
          subtitle: waitingPayment
              ? 'Pembeli sedang meninjau tagihan. Anda masih bisa chat untuk koordinasi.'
              : 'Pembeli sudah membayar. Koordinasi pengiriman tetap bisa via chat.',
        ),
        if (!waitingPayment) ...[
          SizedBox(height: 10.h),
          CustomButton(
            text: 'Lihat Pesanan',
            height: 44.h,
            isOutlined: true,
            onPressed: () => context.push(_orderDetailRoute(n)),
          ),
        ],
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Lihat Tagihan',
                height: 44.h,
                isOutlined: true,
                onPressed: () => _navigateToReviewInvoice(context, n),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomButton(
                text: 'Edit Tagihan',
                height: 44.h,
                isOutlined: true,
                onPressed: () => _openEditInvoicePage(context, n),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        CustomButton(
          text: 'Download PDF',
          height: 44.h,
          isOutlined: true,
          onPressed: () => _downloadInvoice(context, n.orderId!),
        ),
        SizedBox(height: 8.h),
        CustomButton(
          text: 'Kirim PDF ke Chat',
          height: 44.h,
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.hourglass_top_rounded, color: AppColors.primary, size: 22.sp),
          SizedBox(width: 10.w),
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

  Widget _buildInvoiceReviewCard(
    NegotiationEntity n, {
    required bool showPaymentPrompt,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Tagihan dari Supplier',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _invoiceRow('Produk', n.product.name),
          _invoiceRow(
            'Jumlah',
            '${n.quantity.toStringAsFixed(0)} ${n.product.unit}',
          ),
          _invoiceRow('Harga/Unit', n.pricePerUnit.toRupiah),
          Divider(height: 20.h, color: AppColors.grey200),
          _invoiceRow('Total Tagihan', n.totalEstimate.toRupiah, isBold: true),
          SizedBox(height: 8.h),
          Text(
            showPaymentPrompt
                ? 'Periksa detail tagihan. Jika sesuai, lanjutkan ke pembayaran.'
                : 'Tagihan sudah dibayar. Anda bisa melihat detail pesanan atau unduh PDF tagihan.',
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
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
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
        color: Colors.white.withValues(alpha: 0.5),
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
    return '📋 Ringkasan Negosiasi\n'
        'Produk: ${n.product.name}\n'
        'Jumlah: ${n.quantity.toStringAsFixed(0)} ${n.product.unit}\n'
        'Harga/Unit: ${n.pricePerUnit.toRupiah}\n'
        'Total Estimasi: ${n.totalEstimate.toRupiah}\n'
        'Status: $statusLabel';
  }

  void _showChatCommandsHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perintah Chat',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              _commandHelpRow('/negosiasi', 'Kirim ringkasan negosiasi'),
              _commandHelpRow('/bersihkan', 'Hapus semua pesan chat (sistem tetap)'),
              _commandHelpRow('/bantuan', 'Tampilkan daftar perintah'),
              SizedBox(height: 8.h),
              Text(
                'Tekan lama pesan Anda untuk edit atau hapus (maks 24 jam).',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                text: 'Mengerti',
                height: 44.h,
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
      padding: EdgeInsets.only(bottom: 8.h),
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
          SizedBox(width: 8.w),
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
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cleaning_services_outlined),
              title: const Text('Bersihkan Chat'),
              subtitle: const Text('Hapus pesan user, simpan pesan sistem'),
              onTap: () {
                Navigator.pop(ctx);
                _confirmClearChat(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.terminal_outlined),
              title: const Text('Perintah Chat'),
              subtitle: const Text('/negosiasi · /bersihkan · /bantuan'),
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
      title: 'Bersihkan Chat?',
      message:
          'Semua pesan chat akan dihapus. Pesan sistem (tagihan, sengketa, dll) tetap disimpan.',
      confirmText: 'Bersihkan',
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canEdit)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Pesan'),
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
                'Hapus Pesan',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showBisaConfirmDialog(
                  context,
                  title: 'Hapus Pesan?',
                  message: 'Pesan ini akan ditandai sebagai dihapus.',
                  confirmText: 'Hapus',
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
