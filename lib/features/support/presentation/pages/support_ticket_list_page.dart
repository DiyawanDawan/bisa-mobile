import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../data/datasources/support_remote_data_source.dart';
import '../../data/models/support_ticket.dart';

class SupportTicketListPage extends StatefulWidget {
  const SupportTicketListPage({super.key});

  @override
  State<SupportTicketListPage> createState() => _SupportTicketListPageState();
}

class _SupportTicketListPageState extends State<SupportTicketListPage> {
  final _api = sl<SupportRemoteDataSource>();
  List<SupportTicket> _tickets = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final tickets = await _api.listTickets();
      if (!mounted) return;
      setState(() {
        _tickets = tickets;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'support.load_list_error'.tr();
        _loading = false;
      });
    }
  }

  Future<void> _createTicket() async {
    final created = await showModalBottomSheet<SupportTicket>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => _CreateTicketSheet(api: _api),
    );
    if (!mounted || created == null) return;
    await context.push('/support/${created.id}');
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'support.tickets_title'.tr(),
        backgroundColor: AppColors.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTicket,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        icon: const Icon(LucideIcons.messageCirclePlus),
        label: Text('support.create_ticket'.tr()),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(onRefresh: _load, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_error != null && _tickets.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(24.w),
        children: [
          SizedBox(height: 120.h),
          const Icon(
            LucideIcons.cloudOff,
            color: AppColors.textSecondary,
            size: 48,
          ),
          SizedBox(height: 16.h),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
          ),
        ],
      );
    }
    if (_tickets.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(24.w),
        children: [
          SizedBox(height: 110.h),
          Container(
            width: 72.r,
            height: 72.r,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.headset,
              color: AppColors.primary,
              size: 34,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'support.empty_title'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'support.empty_subtitle'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
      itemCount: _tickets.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => _TicketCard(
        ticket: _tickets[index],
        onTap: () async {
          await context.push('/support/${_tickets[index].id}');
          await _load();
        },
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final SupportTicket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = supportStatusLabel(ticket.status);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.subject,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: ticket.isActive
                          ? AppColors.primaryLight
                          : AppColors.grey100,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: ticket.isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    LucideIcons.tag,
                    size: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    supportCategoryLabel(ticket.category),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'support.message_count'.tr(
                      namedArgs: {'count': '${ticket.messageCount}'},
                    ),
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateTicketSheet extends StatefulWidget {
  const _CreateTicketSheet({required this.api});

  final SupportRemoteDataSource api;

  @override
  State<_CreateTicketSheet> createState() => _CreateTicketSheetState();
}

class _CreateTicketSheetState extends State<_CreateTicketSheet> {
  final _subject = TextEditingController();
  final _message = TextEditingController();
  String _category = 'OTHER';
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_subject.text.trim().length < 5 || _message.text.trim().isEmpty) {
      setState(() => _error = 'support.validation_required'.tr());
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final ticket = await widget.api.createTicket(
        subject: _subject.text.trim(),
        category: _category,
        source: 'HELP_CENTER',
        initialMessage: _message.text,
      );
      if (mounted) Navigator.pop(context, ticket);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = 'support.create_failed'.tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w,
          18.h,
          20.w,
          MediaQuery.viewInsetsOf(context).bottom + 20.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'support.create_ticket_title'.tr(),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 18.h),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: 'support.category'.tr(),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'ACCOUNT',
                    child: Text('support.category_account'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'PAYMENT',
                    child: Text('support.category_payment'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'KYC',
                    child: Text('support.category_kyc'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'ORDER',
                    child: Text('support.category_order'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'OTHER',
                    child: Text('support.category_other'.tr()),
                  ),
                ],
                onChanged: _submitting
                    ? null
                    : (value) => setState(() => _category = value!),
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: _subject,
                enabled: !_submitting,
                maxLength: 160,
                decoration: InputDecoration(labelText: 'support.subject'.tr()),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _message,
                enabled: !_submitting,
                minLines: 3,
                maxLines: 6,
                maxLength: 4000,
                decoration: InputDecoration(
                  labelText: 'support.message_label'.tr(),
                ),
              ),
              if (_error != null) ...[
                SizedBox(height: 8.h),
                Text(
                  _error!,
                  style: TextStyle(color: AppColors.error, fontSize: 12.sp),
                ),
              ],
              SizedBox(height: 16.h),
              FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, 48.h),
                ),
                icon: _submitting
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          color: AppColors.textOnPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(LucideIcons.send),
                label: Text(
                  _submitting
                      ? 'support.sending'.tr()
                      : 'support.send_to_cs'.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String supportStatusLabel(String status) => switch (status) {
  'OPEN' => 'support.status_open'.tr(),
  'ASSIGNED' => 'support.status_assigned'.tr(),
  'WAITING_USER' => 'support.status_waiting_user'.tr(),
  'RESOLVED' => 'support.status_resolved'.tr(),
  'CLOSED' => 'support.status_closed'.tr(),
  _ => status,
};

String supportCategoryLabel(String category) => switch (category) {
  'ACCOUNT' => 'support.category_account'.tr(),
  'PAYMENT' => 'support.category_payment'.tr(),
  'KYC' => 'support.category_kyc'.tr(),
  'ORDER' => 'support.category_order'.tr(),
  _ => 'support.category_other'.tr(),
};
