import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/gis/domain/entities/region_entity.dart';
import 'package:mobile_bisa/features/gis/domain/repositories/gis_repository.dart';
import 'package:mobile_bisa/features/gis/presentation/bloc/gis_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/safe_navigator.dart';
import '../../../../core/services/location_service.dart';
import '../../../../injection_container.dart';
import '../bloc/profile_cubit.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/osm_location_picker_page.dart';
import '../../../orders/presentation/widgets/order_tracking_map.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

class AddressListPage extends StatelessWidget {
  const AddressListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProfileCubit>()..getAddresses()),
        BlocProvider(create: (context) => sl<GisCubit>()..getCountries()),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BisaAppBar(
            title: 'Alamat Pengiriman',
            backgroundColor: Colors.white,
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => ShimmerListPlaceholder(
                  itemCount: 4,
                  itemHeight: 100.h,
                  scrollable: true,
                  padding: EdgeInsets.all(16.w),
                ),
                error: (message) => Center(child: Text(message)),
                addressesLoaded: (addresses) {
                  if (addresses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            size: 64.sp,
                            color: AppColors.grey300,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'belum_ada_alamat_tersimpan'.tr(),
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.all(20.w),
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return _buildAddressItem(context, address);
                    },
                  );
                },
                orElse: () => const SizedBox(),
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: CustomButton(
                text: 'Tambah Alamat Baru',
                onPressed: () => _showAddAddressDialog(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressItem(BuildContext context, dynamic address) {
    // Formatter untuk memastikan tidak ada koma ganda jika data kosong
    final List<String> locationParts = [];
    if (address.village != null && address.village.isNotEmpty)
      locationParts.add(address.village);
    if (address.district != null && address.district.isNotEmpty)
      locationParts.add(address.district);
    if (address.city != null && address.city.isNotEmpty)
      locationParts.add(address.city);
    if (address.province != null && address.province.isNotEmpty)
      locationParts.add(address.province);
    if (address.country != null && address.country.isNotEmpty)
      locationParts.add(address.country);

    final locationText = locationParts.join(', ');
    final postalText =
        (address.postalCode != null && address.postalCode.isNotEmpty)
        ? ' ${address.postalCode}'
        : '';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: address.isPrimary ? AppColors.primary : AppColors.grey200,
          width: address.isPrimary ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.mapPin,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    address.name?.isNotEmpty == true
                        ? address.name
                        : 'Alamat Pengiriman',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              if (address.isPrimary)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Utama',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          if (address.phoneNumber?.isNotEmpty == true) ...[
            Row(
              children: [
                Icon(
                  LucideIcons.phone,
                  size: 14.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  address.phoneNumber,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            address.address ?? '',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$locationText$postalText',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!address.isPrimary) ...[
                InkWell(
                  onTap: () => context.read<ProfileCubit>().setDefaultAddress(
                    address.id,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.check,
                          size: 16.sp,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Jadikan Utama',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              InkWell(
                onTap: () => _showAddAddressDialog(context, address),
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.pencil,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              InkWell(
                onTap: () =>
                    context.read<ProfileCubit>().deleteAddress(address.id),
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.trash2,
                        size: 16.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'hapus'.tr(),
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, [dynamic existingAddress]) {
    final pageMessenger = ScaffoldMessenger.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        final sheetHeight = MediaQuery.sizeOf(sheetContext).height * 0.92;
        return SizedBox(
          height: sheetHeight,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocProvider.value(
              value: context.read<ProfileCubit>(),
              child: BlocProvider.value(
                value: context.read<GisCubit>(),
                child: _AddAddressSheet(
                  existingAddress: existingAddress,
                  pageMessenger: pageMessenger,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddAddressSheet extends StatefulWidget {
  final dynamic existingAddress;
  final ScaffoldMessengerState pageMessenger;

  const _AddAddressSheet({
    this.existingAddress,
    required this.pageMessenger,
  });

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  final _labelController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fullAddressController = TextEditingController();
  final _zipCodeController = TextEditingController();

  RegionEntity? _selectedCountry;
  RegionEntity? _selectedProvince;
  RegionEntity? _selectedRegency;
  RegionEntity? _selectedDistrict;
  RegionEntity? _selectedVillage;
  bool _isPrimary = false;
  double? _latitude;
  double? _longitude;
  String? _mapAddressLabel;
  bool _pickingMap = false;
  bool _detectingGps = false;
  bool _hydratingRegions = false;
  bool _saving = false;
  bool _formReady = false;
  String? _formError;

  void _showMessage(String message, {bool isError = false}) {
    widget.pageMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initDefaultCountry();
      if (widget.existingAddress != null) {
        await _hydrateExistingRegions();
      }
      if (mounted) setState(() => _formReady = true);
    });
    if (widget.existingAddress != null) {
      // Force populate fields even if they are empty in the database by using fallbacks
      final existingName = widget.existingAddress.name?.toString() ?? '';
      final existingPhone =
          widget.existingAddress.phoneNumber?.toString() ?? '';
      final existingAddr = widget.existingAddress.address?.toString() ?? '';

      _labelController.text = existingName.isNotEmpty
          ? existingName
          : 'Alamat Tersimpan';
      _phoneController.text = existingPhone.isNotEmpty ? existingPhone : '-';
      _fullAddressController.text = existingAddr.isNotEmpty
          ? existingAddr
          : existingName;
      _zipCodeController.text =
          widget.existingAddress.postalCode?.toString() ?? '';
      _isPrimary = widget.existingAddress.isPrimary ?? false;

      // Tampilkan data wilayah lama sebagai dummy agar UI tidak terlihat kosong
      if (widget.existingAddress.country?.isNotEmpty == true) {
        _selectedCountry = RegionEntity(
          id: widget.existingAddress.countryId ?? '',
          name: widget.existingAddress.country,
        );
      }
      if (widget.existingAddress.province?.isNotEmpty == true) {
        _selectedProvince = RegionEntity(
          id: widget.existingAddress.provinceId ?? '',
          name: widget.existingAddress.province,
        );
      }
      if (widget.existingAddress.city?.isNotEmpty == true) {
        _selectedRegency = RegionEntity(
          id: widget.existingAddress.regencyId ?? '',
          name: widget.existingAddress.city,
        );
      }
      if (widget.existingAddress.district?.isNotEmpty == true) {
        _selectedDistrict = RegionEntity(
          id: widget.existingAddress.districtId ?? '',
          name: widget.existingAddress.district,
        );
      }
      if (widget.existingAddress.village?.isNotEmpty == true) {
        _selectedVillage = RegionEntity(
          id: widget.existingAddress.villageId ?? '',
          name: widget.existingAddress.village,
        );
      }

      final lat = widget.existingAddress.latitude;
      final lng = widget.existingAddress.longitude;
      if (lat != null && lng != null && lat != 0 && lng != 0) {
        _latitude = lat is num ? lat.toDouble() : double.tryParse('$lat');
        _longitude = lng is num ? lng.toDouble() : double.tryParse('$lng');
      }
    }
  }

  String _normalizeRegionName(String? name) {
    if (name == null) return '';
    return name
        .trim()
        .toLowerCase()
        .replaceAll(
          RegExp(r'^(kabupaten|kota|kecamatan|kelurahan|desa)\s+'),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  RegionEntity? _matchRegionByName(List<RegionEntity> regions, String? name) {
    final target = _normalizeRegionName(name);
    if (target.isEmpty) return null;
    for (final region in regions) {
      final candidate = _normalizeRegionName(region.name);
      if (candidate == target ||
          candidate.contains(target) ||
          target.contains(candidate)) {
        return region;
      }
    }
    return null;
  }

  bool _allRegionIdsResolved() {
    return (_selectedCountry?.id.isNotEmpty ?? false) &&
        (_selectedProvince?.id.isNotEmpty ?? false) &&
        (_selectedRegency?.id.isNotEmpty ?? false) &&
        (_selectedDistrict?.id.isNotEmpty ?? false) &&
        (_selectedVillage?.id.isNotEmpty ?? false);
  }

  bool _hasValidPinCoords() {
    if (_latitude == null || _longitude == null) return false;
    if (_latitude == 0 && _longitude == 0) return false;
    return true;
  }

  Map<String, dynamic> _optionalCoordFields() {
    if (!_hasValidPinCoords()) return const {};
    return {
      'latitude': _latitude,
      'longitude': _longitude,
    };
  }

  Future<List<RegionEntity>> _fetchRegions({
    required String level,
    String? parentId,
  }) async {
    final repo = sl<GisRepository>();
    final result = await repo.getRegions(level: level, parentId: parentId);
    return result.fold((_) => <RegionEntity>[], (regions) => regions);
  }

  Future<void> _initDefaultCountry() async {
    if (_selectedCountry != null && _selectedCountry!.id.isNotEmpty) return;
    final countries = await _fetchRegions(level: 'country');
    final indonesia = _matchRegionByName(countries, 'Indonesia') ??
        (countries.isNotEmpty ? countries.first : null);
    if (!mounted || indonesia == null) return;
    setState(() => _selectedCountry = indonesia);
  }

  Future<void> _hydrateExistingRegions() async {
    if (widget.existingAddress == null) return;
    if (_allRegionIdsResolved()) return;
    setState(() => _hydratingRegions = true);
    try {
      await _initDefaultCountry();
      if (_selectedCountry == null || _selectedCountry!.id.isEmpty) return;

      if (_selectedProvince != null &&
          _selectedProvince!.id.isEmpty &&
          _selectedProvince!.name.isNotEmpty) {
        final provinces = await _fetchRegions(
          level: 'province',
          parentId: _selectedCountry!.id,
        );
        _selectedProvince =
            _matchRegionByName(provinces, _selectedProvince!.name) ??
                _selectedProvince;
      }

      if (_selectedProvince != null &&
          _selectedProvince!.id.isNotEmpty &&
          _selectedRegency != null &&
          _selectedRegency!.id.isEmpty &&
          _selectedRegency!.name.isNotEmpty) {
        final regencies = await _fetchRegions(
          level: 'regency',
          parentId: _selectedProvince!.id,
        );
        _selectedRegency =
            _matchRegionByName(regencies, _selectedRegency!.name) ??
                _selectedRegency;
      }

      if (_selectedRegency != null &&
          _selectedRegency!.id.isNotEmpty &&
          _selectedDistrict != null &&
          _selectedDistrict!.id.isEmpty &&
          _selectedDistrict!.name.isNotEmpty) {
        final districts = await _fetchRegions(
          level: 'district',
          parentId: _selectedRegency!.id,
        );
        _selectedDistrict =
            _matchRegionByName(districts, _selectedDistrict!.name) ??
                _selectedDistrict;
      }

      if (_selectedDistrict != null &&
          _selectedDistrict!.id.isNotEmpty &&
          _selectedVillage != null &&
          _selectedVillage!.id.isEmpty &&
          _selectedVillage!.name.isNotEmpty) {
        final villages = await _fetchRegions(
          level: 'village',
          parentId: _selectedDistrict!.id,
        );
        _selectedVillage =
            _matchRegionByName(villages, _selectedVillage!.name) ?? _selectedVillage;
      }
    } finally {
      if (mounted) setState(() => _hydratingRegions = false);
    }
  }

  /// Susun teks alamat lengkap dari hasil pencarian/pin OpenStreetMap.
  String _fullAddressFromOsmPick({
    required String formattedAddress,
    required Map<String, dynamic> addressData,
  }) {
    final formatted = formattedAddress.trim();
    if (formatted.length >= 10) return formatted;

    final parts = <String>[];
    final road = (addressData['road'] ??
            addressData['street'] ??
            addressData['pedestrian'] ??
            addressData['residential'])
        ?.toString()
        .trim();
    final house = addressData['house_number']?.toString().trim();
    if (road != null && road.isNotEmpty) {
      parts.add(house != null && house.isNotEmpty ? '$road No. $house' : road);
    }

    for (final key in [
      'neighbourhood',
      'suburb',
      'village',
      'hamlet',
      'city_district',
      'district',
      'town',
      'city',
      'municipality',
      'county',
      'state',
      'postcode',
    ]) {
      final value = addressData[key]?.toString().trim();
      if (value != null && value.isNotEmpty && !parts.contains(value)) {
        parts.add(value);
      }
    }

    if (parts.isNotEmpty) return parts.join(', ');
    return formatted.isNotEmpty ? formatted : '';
  }

  Future<void> _applyRegionsFromMapData(Map<String, dynamic> addressData) async {
    final provinceName = (addressData['state'] ?? addressData['region'])?.toString();
    final regencyName = (addressData['county'] ??
            addressData['city'] ??
            addressData['town'] ??
            addressData['municipality'])
        ?.toString();
    final districtName =
        (addressData['suburb'] ?? addressData['district'] ?? addressData['city_district'])
            ?.toString();
    final villageName = (addressData['village'] ??
            addressData['neighbourhood'] ??
            addressData['hamlet'])
        ?.toString();

    await _initDefaultCountry();
    if (_selectedCountry == null || _selectedCountry!.id.isEmpty) return;

    if (provinceName != null && provinceName.isNotEmpty) {
      final provinces = await _fetchRegions(
        level: 'province',
        parentId: _selectedCountry!.id,
      );
      final matched = _matchRegionByName(provinces, provinceName);
      if (matched != null) _selectedProvince = matched;
    }

    if (_selectedProvince != null && _selectedProvince!.id.isNotEmpty) {
      final regencies = await _fetchRegions(
        level: 'regency',
        parentId: _selectedProvince!.id,
      );
      final matched = _matchRegionByName(regencies, regencyName);
      if (matched != null) {
        _selectedRegency = matched;
      } else if (regencyName != null && regencyName.isNotEmpty) {
        _selectedRegency = RegionEntity(id: '', name: regencyName);
      }
    }

    if (_selectedRegency != null && _selectedRegency!.id.isNotEmpty) {
      final districts = await _fetchRegions(
        level: 'district',
        parentId: _selectedRegency!.id,
      );
      final matched = _matchRegionByName(districts, districtName);
      if (matched != null) {
        _selectedDistrict = matched;
      } else if (districtName != null && districtName.isNotEmpty) {
        _selectedDistrict = RegionEntity(id: '', name: districtName);
      }
    }

    if (_selectedDistrict != null && _selectedDistrict!.id.isNotEmpty) {
      final villages = await _fetchRegions(
        level: 'village',
        parentId: _selectedDistrict!.id,
      );
      final matched = _matchRegionByName(villages, villageName);
      if (matched != null) {
        _selectedVillage = matched;
      } else if (villageName != null && villageName.isNotEmpty) {
        _selectedVillage = RegionEntity(id: '', name: villageName);
      }
    }
  }

  Future<bool> _resolveMissingRegionIds() async {
    if (!_allRegionIdsResolved()) {
      await _hydrateExistingRegions();
    }

    if (_selectedDistrict != null &&
        _selectedDistrict!.id.isNotEmpty &&
        (_selectedVillage == null ||
            _selectedVillage!.id.isEmpty ||
            _selectedVillage!.name.isEmpty)) {
      final villages = await _fetchRegions(
        level: 'village',
        parentId: _selectedDistrict!.id,
      );
      if (villages.length == 1) {
        _selectedVillage = villages.first;
      }
    }
    return _selectedCountry != null &&
        _selectedCountry!.id.isNotEmpty &&
        _selectedProvince != null &&
        _selectedProvince!.id.isNotEmpty &&
        _selectedRegency != null &&
        _selectedRegency!.id.isNotEmpty &&
        _selectedDistrict != null &&
        _selectedDistrict!.id.isNotEmpty &&
        _selectedVillage != null &&
        _selectedVillage!.id.isNotEmpty;
  }

  Future<void> _openMapPicker() async {
    setState(() => _pickingMap = true);
    try {
      final picked = await OsmLocationPickerPage.open(
        context,
        initialLatitude: _latitude,
        initialLongitude: _longitude,
      );
      if (!mounted || picked == null) return;

      await _applyRegionsFromMapData(picked.addressData);
      if (!mounted) return;

      final fullAddress = _fullAddressFromOsmPick(
        formattedAddress: picked.formattedAddress,
        addressData: picked.addressData,
      );

      setState(() {
        _latitude = picked.latLong.latitude;
        _longitude = picked.latLong.longitude;
        _mapAddressLabel = fullAddress.isNotEmpty ? fullAddress : picked.formattedAddress;

        // Hasil cari/pilih di peta selalu masuk ke alamat lengkap.
        if (fullAddress.isNotEmpty) {
          _fullAddressController.text = fullAddress;
        }

        final postcode = picked.addressData['postcode']?.toString();
        if (postcode != null && postcode.isNotEmpty) {
          _zipCodeController.text = postcode;
        }
      });

      if (mounted && fullAddress.isNotEmpty) {
        _showMessage('Alamat lengkap diisi dari peta');
      }
    } finally {
      if (mounted) setState(() => _pickingMap = false);
    }
  }

  Future<void> _useCurrentGps() async {
    setState(() => _detectingGps = true);
    try {
      final fix = await LocationService.instance.getCurrentFix();
      if (!mounted) return;
      if (fix == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Izin lokasi ditolak atau GPS tidak tersedia. Buka pengaturan perangkat.',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final gpsAddress = (fix.address?.trim().isNotEmpty ?? false)
          ? fix.address!.trim()
          : fix.shortLabel;

      setState(() {
        _latitude = fix.latitude;
        _longitude = fix.longitude;
        _mapAddressLabel = gpsAddress;
        if (gpsAddress.isNotEmpty) {
          _fullAddressController.text = gpsAddress;
        }
      });

      if (mounted && gpsAddress.isNotEmpty) {
        _showMessage('Alamat lengkap diisi dari GPS');
      }
    } finally {
      if (mounted) setState(() => _detectingGps = false);
    }
  }

  Widget _buildMapPickerSection() {
    final hasPin = _hasValidPinCoords();
    final previewLat = _latitude ?? -6.2088;
    final previewLng = _longitude ?? 106.8456;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pin Lokasi (OpenStreetMap)',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'Opsional',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _pickingMap ? null : _openMapPicker,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AbsorbPointer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    height: 140.h,
                    width: double.infinity,
                    child: OrderTrackingMap(lat: previewLat, lng: previewLng),
                  ),
                ),
              ),
              if (!hasPin)
                Container(
                  height: 140.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.black.withValues(alpha: 0.28),
                  ),
                ),
              if (_pickingMap)
                const CircularProgressIndicator(color: Colors.white)
              else
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.search,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        hasPin ? 'Ubah / cari di peta' : 'Ketuk untuk cari alamat',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (hasPin && (_mapAddressLabel?.isNotEmpty ?? false)) ...[
          SizedBox(height: 6.h),
          Text(
            _mapAddressLabel!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
        SizedBox(height: 8.h),
        OutlinedButton.icon(
          onPressed: (_pickingMap || _detectingGps) ? null : _useCurrentGps,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 42.h),
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.35)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          icon: _detectingGps
              ? SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(LucideIcons.locateFixed, size: 16.sp),
          label: Text(
            'Gunakan Lokasi GPS Saya',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Opsional: ketuk peta untuk cari alamat. Hasil peta/GPS mengisi alamat lengkap.',
          style: TextStyle(fontSize: 11.sp, color: AppColors.textHint, height: 1.35),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _phoneController.dispose();
    _fullAddressController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 8.h,
        bottom: viewInsets.bottom,
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            if (_formError != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  _formError!,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingAddress != null
                      ? 'Edit Alamat'
                      : 'Tambah Alamat Baru',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    LucideIcons.x,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildMapPickerSection(),
            SizedBox(height: 12.h),
            if (_hydratingRegions)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Memuat data wilayah...',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            if (_selectedVillage != null &&
                _selectedVillage!.name.isNotEmpty &&
                _selectedVillage!.id.isEmpty)
              Container(
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.triangleAlert,
                      color: AppColors.warning,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Desa/Kelurahan belum valid. Tap dropdown Desa/Kelurahan lalu pilih ulang dari daftar.',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 8.h),
            CustomTextField(
              label: 'labelalamat'.tr().tr(),
              hint: 'contohrumahkantor'.tr().tr(),
              controller: _labelController,
            ),
            SizedBox(height: 12.h),
            CustomTextField(
              label: 'nomortelepon'.tr().tr(),
              hint: '0812xxxxxxxx'.tr().tr(),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12.h),

            // GIS Dropdowns
            _buildRegionDropdown(
              label: 'negara_1'.tr().tr(),
              value: _selectedCountry,
              onChanged: (val) {
                setState(() {
                  _selectedCountry = val;
                  _selectedProvince = null;
                  _selectedRegency = null;
                  _selectedDistrict = null;
                  _selectedVillage = null;
                });
                if (val != null) context.read<GisCubit>().getProvinces(val.id);
              },
              level: 'country',
            ),
            SizedBox(height: 12.h),
            _buildRegionDropdown(
              label: 'provinsi_1'.tr().tr(),
              value: _selectedProvince,
              enabled: _selectedCountry != null,
              onChanged: (val) {
                setState(() {
                  _selectedProvince = val;
                  _selectedRegency = null;
                  _selectedDistrict = null;
                  _selectedVillage = null;
                });
                if (val != null) context.read<GisCubit>().getRegencies(val.id);
              },
              level: 'province',
            ),
            SizedBox(height: 12.h),
            _buildRegionDropdown(
              label: 'kotakabupaten'.tr().tr(),
              value: _selectedRegency,
              enabled: _selectedProvince != null,
              onChanged: (val) {
                setState(() {
                  _selectedRegency = val;
                  _selectedDistrict = null;
                  _selectedVillage = null;
                });
                if (val != null) context.read<GisCubit>().getDistricts(val.id);
              },
              level: 'regency',
            ),
            SizedBox(height: 12.h),
            _buildRegionDropdown(
              label: 'kecamatan_1'.tr().tr(),
              value: _selectedDistrict,
              enabled: _selectedRegency != null,
              onChanged: (val) {
                setState(() {
                  _selectedDistrict = val;
                  _selectedVillage = null;
                });
                if (val != null) context.read<GisCubit>().getVillages(val.id);
              },
              level: 'district',
            ),
            SizedBox(height: 12.h),
            _buildRegionDropdown(
              label: 'desakelurahan'.tr().tr(),
              value: _selectedVillage,
              enabled: _selectedDistrict != null,
              onChanged: (val) {
                setState(() {
                  _selectedVillage = val;
                });
              },
              level: 'village',
            ),
            SizedBox(height: 12.h),

            CustomTextField(
              label: 'alamatlengkap'.tr().tr(),
              hint: 'namajalannorumahblokdll'.tr().tr(),
              controller: _fullAddressController,
              maxLines: 3,
            ),
            SizedBox(height: 12.h),
            CustomTextField(
              label: 'kodepos'.tr().tr(),
              hint: 'xxxxx'.tr().tr(),
              controller: _zipCodeController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Atur sebagai alamat utama',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Switch(
                  value: _isPrimary,
                  onChanged: (val) {
                    setState(() {
                      _isPrimary = val;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(0, 8.h, 0, bottomSafe + 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.grey200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: CustomButton(
              text: _saving
                  ? 'Menyimpan...'
                  : (!_formReady || _hydratingRegions)
                      ? 'Memuat...'
                      : 'simpan'.tr(),
              onPressed: (_saving || !_formReady || _hydratingRegions)
                  ? null
                  : _submit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionDropdown({
    required String label,
    required RegionEntity? value,
    required Function(RegionEntity?) onChanged,
    required String level,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: enabled
              ? () {
                  final gisCubit = context.read<GisCubit>();
                  // Trigger fetch based on level
                  switch (level) {
                    case 'country':
                      gisCubit.getCountries();
                      break;
                    case 'province':
                      if (_selectedCountry != null) {
                        gisCubit.getProvinces(_selectedCountry!.id);
                      }
                      break;
                    case 'regency':
                      if (_selectedProvince != null) {
                        gisCubit.getRegencies(_selectedProvince!.id);
                      }
                      break;
                    case 'district':
                      if (_selectedRegency != null) {
                        gisCubit.getDistricts(_selectedRegency!.id);
                      }
                      break;
                    case 'village':
                      if (_selectedDistrict != null) {
                        gisCubit.getVillages(_selectedDistrict!.id);
                      }
                      break;
                  }
                  _showRegionPicker(context, label, level, onChanged);
                }
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: enabled ? Colors.white : AppColors.grey100,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value?.name ?? 'Pilih $label',
                    style: TextStyle(
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                      fontSize: 14.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey400,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showRegionPicker(
    BuildContext context,
    String title,
    String level,
    Function(RegionEntity?) onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<GisCubit>(),
        child: _RegionPickerSheet(title: title, level: level),
      ),
    ).then((result) {
      if (result != null && result is RegionEntity) {
        onSelected(result);
      }
    });
  }

  Future<void> _submit() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _formError = null;
    });

    final regionsReady = await _resolveMissingRegionIds();

    String? error;
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      error = 'Label alamat wajib diisi (misal: Rumah, Kantor)';
    } else if (_zipCodeController.text.trim().isEmpty) {
      error = 'Kode pos wajib diisi';
    } else if (_selectedCountry == null || _selectedCountry!.id.isEmpty) {
      error = 'Negara belum dimuat. Tunggu sebentar lalu coba lagi.';
    } else if (!regionsReady) {
      if (_selectedVillage == null || _selectedVillage!.id.isEmpty) {
        error = 'Desa/Kelurahan belum dipilih dari daftar';
      } else {
        error = 'Wilayah alamat belum lengkap (Negara/Provinsi/Kota/Kecamatan)';
      }
    } else if (_fullAddressController.text.trim().isEmpty) {
      error = 'Alamat lengkap belum diisi';
    }

    if (error != null) {
      if (mounted) {
        setState(() {
          _saving = false;
          _formError = error;
        });
        _showMessage(error, isError: true);
      }
      return;
    }

    final phoneRaw = _phoneController.text.trim();
    final data = {
      'label': label,
      'countryId': _selectedCountry!.id,
      'provinceId': _selectedProvince!.id,
      'regencyId': _selectedRegency!.id,
      'districtId': _selectedDistrict!.id,
      'villageId': _selectedVillage!.id,
      'fullAddress': _fullAddressController.text.trim(),
      'zipCode': _zipCodeController.text.trim(),
      if (phoneRaw.isNotEmpty && phoneRaw != '-') 'phone': phoneRaw,
      ..._optionalCoordFields(),
      'isPrimary': _isPrimary,
    };

    final cubit = context.read<ProfileCubit>();
    final addressId = widget.existingAddress?.id?.toString();
    final bool success;
    try {
      if (addressId != null && addressId.isNotEmpty) {
        success = await cubit.updateAddress(addressId, data);
      } else {
        success = await cubit.addAddress(data);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _formError = 'Gagal menyimpan: $e';
      });
      _showMessage(_formError!, isError: true);
      return;
    }

    if (!mounted) return;
    setState(() => _saving = false);

    if (!success) {
      final message = cubit.state.maybeWhen(
        error: (msg) => msg,
        orElse: () => 'Gagal menyimpan alamat. Periksa data wilayah dan coba lagi.',
      );
      setState(() => _formError = message);
      _showMessage(message, isError: true);
      return;
    }

    _showMessage(
      widget.existingAddress != null
          ? 'Alamat berhasil diperbarui'
          : 'Alamat berhasil ditambahkan',
    );
    if (mounted) Navigator.of(context).pop();
  }
}

class _RegionPickerSheet extends StatelessWidget {
  final String title;
  final String level;

  const _RegionPickerSheet({required this.title, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih $title',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  LucideIcons.x,
                  color: AppColors.textSecondary,
                  size: 20.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: BlocBuilder<GisCubit, GisState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => ShimmerListPlaceholder(
                    itemCount: 8,
                    itemHeight: 48.h,
                    scrollable: true,
                  ),
                  loaded: (regions) => ListView.separated(
                    itemCount: regions.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final region = regions[index];
                      return ListTile(
                        title: Text(region.name),
                        onTap: () => safeNavigatorPop(context, region),
                      );
                    },
                  ),
                  error: (message) => Center(child: Text(message)),
                  orElse: () =>  Center(child: Text('tidak_ada_data'.tr())),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
