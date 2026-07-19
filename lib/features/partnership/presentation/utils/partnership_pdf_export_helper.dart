import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../negotiation/domain/repositories/negotiation_repository.dart';
import '../../data/services/partnership_pdf_service.dart';
import '../../domain/entities/partnership_entity.dart';
import '../../domain/repositories/partnership_repository.dart';

class PartnershipPdfExportHelper {
  static PartnershipPdfLabels _labels() {
    return PartnershipPdfLabels(
      docTitle: 'partnership.pdf_doc_title'.tr(),
      draftWatermark: 'partnership.pdf_draft_watermark'.tr(),
      contractNumber: 'partnership.pdf_contract_number'.tr(),
      status: 'partnership.pdf_status'.tr(),
      parties: 'partnership.pdf_parties'.tr(),
      buyer: 'partnership.buyer_sign'.tr(),
      supplier: 'partnership.supplier_sign'.tr(),
      company: 'partnership.pdf_company'.tr(),
      terms: 'partnership.section_terms'.tr(),
      description: 'partnership.field_description'.tr(),
      category: 'partnership.field_category'.tr(),
      qty: 'partnership.field_qty'.tr(),
      price: 'partnership.field_price'.tr(),
      delivery: 'partnership.field_delivery'.tr(),
      payment: 'partnership.field_payment'.tr(),
      special: 'partnership.field_special'.tr(),
      period: 'partnership.field_period'.tr(),
      signatures: 'partnership.section_signature'.tr(),
      buyerSign: 'partnership.buyer_sign'.tr(),
      supplierSign: 'partnership.supplier_sign'.tr(),
      platformSign: 'partnership.platform_sign'.tr(),
      signed: 'partnership.pdf_signed'.tr(),
      notSigned: 'partnership.pdf_not_signed'.tr(),
      progress: 'partnership.signers_progress'.tr(),
      location: 'partnership.pdf_location'.tr(),
      signerTitle: 'partnership.pdf_signer_title'.tr(),
      digitalContract: 'partnership.pdf_digital_contract'.tr(),
      qrHint: 'partnership.pdf_qr_hint'.tr(),
      generatedAt: 'partnership.pdf_generated_at'.tr(),
      footer: 'partnership.pdf_footer'.tr(),
      draftNote: 'partnership.pdf_draft_note'.tr(),
      shareSubject: 'partnership.pdf_share_subject'.tr(),
      shareText: 'partnership.pdf_share_text'.tr(),
    );
  }

  static String _intlLocale(BuildContext context) {
    final code = context.locale.languageCode;
    return code == 'en' ? 'en_US' : 'id_ID';
  }

  static Future<void> exportEntity(
    BuildContext context,
    PartnershipEntity partnership,
  ) async {
    await _runShare(context, PartnershipPdfData.fromEntity(partnership));
  }

  static Future<void> exportDraftForm(
    BuildContext context, {
    required String title,
    required String supplierName,
    String? description,
    String? productCategory,
    double? estimatedMonthlyQty,
    String? priceAgreement,
    String? deliveryTerms,
    String? paymentTerms,
    String? specialTerms,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final user = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (user == null) {
      showErrorSnackBar(context, 'partnership.pdf_login_required'.tr());
      return;
    }

    await _runShare(
      context,
      PartnershipPdfData.fromDraftForm(
        title: title,
        buyerName: user.name,
        buyerCompany: user.companyName,
        buyerLocation: user.address,
        supplierName: supplierName,
        description: description,
        productCategory: productCategory,
        estimatedMonthlyQty: estimatedMonthlyQty,
        priceAgreement: priceAgreement,
        deliveryTerms: deliveryTerms,
        paymentTerms: paymentTerms,
        specialTerms: specialTerms,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  /// Sheet: edit pesan → kirim pesan teks + PDF ke ruang chat.
  static Future<bool> showSendProposalSheet(
    BuildContext context, {
    required String negotiationId,
    PartnershipEntity? partnership,
    PartnershipPdfData? draftData,
    String? counterpartyName,
    bool openChatAfter = true,
  }) async {
    assert(partnership != null || draftData != null);

    final defaultMsg = partnership != null
        ? 'partnership.chat_default_message'.tr(
            namedArgs: {
              'title': partnership.title,
              'number': partnership.contractNumber,
            },
          )
        : 'partnership.chat_default_draft_message'.tr(
            namedArgs: {
              'name': counterpartyName ?? 'supplier',
              'title': draftData?.title ?? '',
            },
          );

    final messageCtrl = TextEditingController(text: defaultMsg);
    final sendPdf = ValueNotifier<bool>(true);

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        final bottom = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md + bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'partnership.chat_sheet_title'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'partnership.chat_sheet_subtitle'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.md12),
              CustomTextField(
                controller: messageCtrl,
                label: 'partnership.chat_message_label'.tr(),
                hint: 'partnership.chat_message_label'.tr(),
                maxLines: 4,
                isRequired: true,
              ),
              SizedBox(height: AppSpacing.sm),
              ValueListenableBuilder<bool>(
                valueListenable: sendPdf,
                builder: (_, value, __) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: value,
                    onChanged: (v) => sendPdf.value = v ?? true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'partnership.chat_attach_pdf'.tr(),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ),
              SizedBox(height: AppSpacing.md12),
              CustomButton(
                text: 'partnership.chat_send_cta'.tr(),
                backgroundColor: AppColors.success,
                onPressed: () => Navigator.pop(sheetContext, true),
              ),
              SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => Navigator.pop(sheetContext, false),
                child: Text('batal'.tr()),
              ),
            ],
          ),
        );
      },
    );

    final message = messageCtrl.text.trim();
    final withPdf = sendPdf.value;
    messageCtrl.dispose();
    sendPdf.dispose();

    if (confirmed != true || !context.mounted) return false;
    if (message.isEmpty) {
      showErrorSnackBar(context, 'partnership.chat_message_required'.tr());
      return false;
    }

    final data = partnership != null
        ? PartnershipPdfData.fromEntity(partnership)
        : draftData!;

    final ok = await sendToChat(
      context,
      negotiationId: negotiationId,
      data: data,
      message: message,
      attachPdf: withPdf,
    );

    if (ok && openChatAfter && context.mounted) {
      context.push('/negotiation/$negotiationId');
    }
    return ok;
  }

  static Future<bool> sendEntityToChat(
    BuildContext context, {
    required PartnershipEntity partnership,
    required String negotiationId,
    String? message,
    bool attachPdf = true,
    bool openChatAfter = false,
  }) {
    return sendToChat(
      context,
      negotiationId: negotiationId,
      data: PartnershipPdfData.fromEntity(partnership),
      message: message ??
          'partnership.chat_default_message'.tr(
            namedArgs: {
              'title': partnership.title,
              'number': partnership.contractNumber,
            },
          ),
      attachPdf: attachPdf,
      openChatAfter: openChatAfter,
    );
  }

  static Future<bool> sendToChat(
    BuildContext context, {
    required String negotiationId,
    required PartnershipPdfData data,
    required String message,
    bool attachPdf = true,
    bool openChatAfter = false,
  }) async {
    if (!context.mounted) return false;
    final labels = _labels();
    final intlLocale = _intlLocale(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final repo = sl<NegotiationRepository>();

      if (attachPdf) {
        final file = await PartnershipPdfExporter.generateTempFile(
          data,
          labels: labels,
          intlLocale: intlLocale,
        );
        final result = await repo.sendChatMessage(
          negotiationId,
          message,
          localFilePath: file.path,
        );
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        final ok = result.fold(
          (failure) {
            if (context.mounted) {
              showFailureSnackBarFromMessage(context, failure.message);
            }
            return false;
          },
          (_) {
            if (context.mounted) {
              showSuccessSnackBar(context, 'partnership.chat_send_success'.tr());
            }
            return true;
          },
        );
        if (ok && openChatAfter && context.mounted) {
          context.push('/negotiation/$negotiationId');
        }
        return ok;
      }

      final result = await repo.sendChatMessage(negotiationId, message);
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      final ok = result.fold(
        (failure) {
          if (context.mounted) {
            showFailureSnackBarFromMessage(context, failure.message);
          }
          return false;
        },
        (_) {
          if (context.mounted) {
            showSuccessSnackBar(context, 'partnership.chat_send_success'.tr());
          }
          return true;
        },
      );
      if (ok && openChatAfter && context.mounted) {
        context.push('/negotiation/$negotiationId');
      }
      return ok;
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showErrorSnackBar(
          context,
          'partnership.chat_send_failed'.tr(namedArgs: {'error': '$e'}),
        );
      }
      return false;
    }
  }

  /// Cari ruang chat dengan lawan (buyer↔supplier).
  static Future<String?> findNegotiationIdWithUser(String counterpartyId) async {
    final repo = sl<NegotiationRepository>();
    final mine = await repo.getMyOffers(limit: 50);
    final fromMine = mine.fold<String?>((_) => null, (list) {
      for (final n in list) {
        if (n.sellerId == counterpartyId || n.buyerId == counterpartyId) {
          return n.id;
        }
      }
      return null;
    });
    if (fromMine != null) return fromMine;

    final incoming = await repo.getIncomingOffers(limit: 50);
    return incoming.fold<String?>((_) => null, (list) {
      for (final n in list) {
        if (n.sellerId == counterpartyId || n.buyerId == counterpartyId) {
          return n.id;
        }
      }
      return null;
    });
  }

  /// Partnership aktif/pending dengan supplier, jika ada.
  static Future<PartnershipEntity?> findPartnershipWithSupplier(
    String supplierId,
  ) async {
    final result =
        await sl<PartnershipRepository>().checkWithSupplier(supplierId);
    return result.fold((_) => null, (p) => p);
  }

  static Future<void> _runShare(
    BuildContext context,
    PartnershipPdfData data,
  ) async {
    if (!context.mounted) return;
    final labels = _labels();
    final intlLocale = _intlLocale(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      await PartnershipPdfExporter.share(
        data,
        labels: labels,
        intlLocale: intlLocale,
      );
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showSuccessSnackBar(
          context,
          data.isDraft
              ? 'partnership.pdf_draft_ready'.tr()
              : 'partnership.pdf_ready'.tr(),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showErrorSnackBar(
          context,
          'partnership.pdf_failed'.tr(namedArgs: {'error': '$e'}),
        );
      }
    }
  }
}
