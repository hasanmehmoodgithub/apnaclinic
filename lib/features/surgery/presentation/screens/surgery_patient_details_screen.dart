import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';

class SurgeryPatientDetailsScreen extends StatefulWidget {
  const SurgeryPatientDetailsScreen({
    super.key,
    required this.doctorName,
    required this.speciality,
    required this.experience,
    required this.qualifications,
    required this.hospitalName,
    required this.procedureName,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.partnerLogoUrl,
  });

  final String doctorName;
  final String speciality;
  final String experience;
  final String qualifications;
  final String hospitalName;
  final String procedureName;
  final String price;
  final String oldPrice;
  final String imageUrl;
  final String partnerLogoUrl;

  @override
  State<SurgeryPatientDetailsScreen> createState() =>
      _SurgeryPatientDetailsScreenState();
}

class _SurgeryPatientDetailsScreenState extends State<SurgeryPatientDetailsScreen> {
  bool showSurgeryOptions = true;
  String selectedSurgery = 'Refractive Surgery';
  bool showEmergencyError = false;
  late final TextEditingController patientNameController;
  late final TextEditingController ageController;
  late final TextEditingController contactNumberController;
  late final TextEditingController emergencyContactController;

  final List<_SurgeryOption> options = const [
    _SurgeryOption('Refractive Surgery', 'Rs. 65,000/-', 'Rs. 100,000/-'),
    _SurgeryOption('Corneal transplant.', 'Rs. 65,000/-', 'Rs. 100,000/-'),
    _SurgeryOption('Glaucoma surgery', 'Rs. 65,000/-', 'Rs. 100,000/-'),
    _SurgeryOption('Trabeculectomy', 'Rs. 65,000/-', 'Rs. 100,000/-'),
  ];

  @override
  void initState() {
    super.initState();
    patientNameController = TextEditingController(text: 'Haseeb Qasim');
    ageController = TextEditingController(text: '24');
    contactNumberController = TextEditingController(text: '0341-1234567');
    emergencyContactController = TextEditingController(text: '0341-1234567');
  }

  @override
  void dispose() {
    patientNameController.dispose();
    ageController.dispose();
    contactNumberController.dispose();
    emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffoldGradient(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 18.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF061E40)),
                ),
                Expanded(
                  child: Text(
                    'Surgery Booking',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 40.w),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 16.h),
                      children: [
                        Text(
                          'Patient Details',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF061E40),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _DoctorSummary(widget: widget),
                        SizedBox(height: 16.h),
                        _TextInputField(
                          title: 'Patient Name',
                          controller: patientNameController,
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 12.h),
                        _TextInputField(
                          title: 'Age',
                          controller: ageController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 12.h),
                        _TextInputField(
                          title: 'Contact Number',
                          controller: contactNumberController,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 12.h),
                        _TextInputField(
                          title: 'Emergency Contact',
                          controller: emergencyContactController,
                          keyboardType: TextInputType.phone,
                          hasError: showEmergencyError,
                          errorText: 'Enter Phone Number',
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Surgery',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF061E40),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        InkWell(
                          onTap: () => setState(() => showSurgeryOptions = !showSurgeryOptions),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 13.h),
                            color: const Color(0xFFF1F1F1),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedSurgery,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF4A555F),
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Rs. 115,000/-',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF667B99),
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  showSurgeryOptions
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: const Color(0xFFB6BDC8),
                                  size: 18.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (showSurgeryOptions)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFD0D0D0), width: 0.25),
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.r)),
                            ),
                            child: Column(
                              children: options.map((option) {
                                final selected = option.name == selectedSurgery;
                                return InkWell(
                                  onTap: () => setState(() => selectedSurgery = option.name),
                                  child: Container(
                                    color: selected
                                        ? const Color(0xFFF1F1F1)
                                        : Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 15.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option.name,
                                            style: theme.textTheme.titleSmall?.copyWith(
                                              color: const Color(0xFF061E40),
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              option.price,
                                              style: theme.textTheme.titleSmall?.copyWith(
                                                color: const Color(0xFF061E40),
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              option.oldPrice,
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: const Color(0xFF979797),
                                                fontSize: 14.sp,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (selected) ...[
                                          SizedBox(width: 8.w),
                                          Icon(
                                            Icons.keyboard_arrow_up_rounded,
                                            color: const Color(0xFFB6BDC8),
                                            size: 18.r,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 14.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.07),
                          blurRadius: 30,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final emergency = emergencyContactController.text.trim();
                          if (emergency.isEmpty) {
                            setState(() => showEmergencyError = true);
                            _showEmergencyContactSnackbar();
                            return;
                          }
                          setState(() => showEmergencyError = false);
                          _showBookingSubmittedDialog();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0FAA9A),
                          minimumSize: Size.fromHeight(57.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.9.r),
                          ),
                        ),
                        child: Text(
                          'Proceed Checkout',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBookingSubmittedDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 17.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(32.w, 24.h, 32.w, 24.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color.fromRGBO(1, 205, 222, 0.1),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60.r,
                  height: 60.r,
                  child: Image.network(
                    'https://www.figma.com/api/mcp/asset/77bce850-2036-41ca-8359-b5b1faaf58f5',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.check_circle_rounded,
                      color: const Color(0xFF8DD57C),
                      size: 60.r,
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
                Text(
                  'Booking Request Submitted',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    height: 1.02,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Your surgery request has been received. Our representative '
                  'will contact you within 24 hours to gather your medical '
                  'history and relevant details for confirmation.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 16.sp,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0FAA9A),
                      minimumSize: Size.fromHeight(57.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.9.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
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

  void _showEmergencyContactSnackbar() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 98.h),
          backgroundColor: const Color(0xFFFFF8F8),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Color(0xFFFFEBEA)),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16.r,
                color: const Color(0xFFBA2025),
              ),
              SizedBox(width: 8.w),
              Text(
                'Please add emergency contact number.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFBA2025),
                      fontSize: 16.sp,
                    ),
              ),
            ],
          ),
        ),
      );
  }
}

class _DoctorSummary extends StatelessWidget {
  const _DoctorSummary({required this.widget});

  final SurgeryPatientDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(8, 97, 156, 0.2),
            blurRadius: 59,
            offset: Offset(0, 18),
            spreadRadius: -27,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7.8.r),
                child: SizedBox(
                  width: 59.h,
                  height: 59.h,
                  child: Image.network(widget.imageUrl, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctorName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.speciality,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      '${widget.experience}  ${widget.qualifications}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFA6A6A6),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black.withValues(alpha: 0.21), width: 0.2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(widget.partnerLogoUrl, fit: BoxFit.cover),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF7F7F7)),
                bottom: BorderSide(color: Color(0xFFF7F7F7)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hospitalName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        widget.procedureName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF061E40),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Stating from',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF777272),
                          fontSize: 12.sp,
                        )),
                    Text(widget.price,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        )),
                    Text(widget.oldPrice,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF979797),
                          fontSize: 14.sp,
                          decoration: TextDecoration.lineThrough,
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0FAA9A),
                minimumSize: Size.fromHeight(40.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.1.r)),
              ),
              child: Text(
                'Book Now',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextInputField extends StatelessWidget {
  const _TextInputField({
    required this.title,
    required this.controller,
    required this.keyboardType,
    this.hasError = false,
    this.errorText,
  });

  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool hasError;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF061E40),
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: hasError ? const Color(0xFFFFF8F8) : const Color(0xFFF1F1F1),
            border: Border(
              bottom: BorderSide(
                color: hasError ? const Color(0xFF852221) : const Color(0xFFF1F1F1),
                width: 0.3,
              ),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: hasError ? const Color(0xFFBA2025) : const Color(0xFF4A555F),
              fontSize: hasError ? 15.sp : 16.sp,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 15.h),
              hintText: hasError ? errorText : null,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFBA2025),
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SurgeryOption {
  const _SurgeryOption(this.name, this.price, this.oldPrice);
  final String name;
  final String price;
  final String oldPrice;
}
