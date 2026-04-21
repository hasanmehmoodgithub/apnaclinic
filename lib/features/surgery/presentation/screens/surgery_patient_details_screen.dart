import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

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

class _SurgeryPatientDetailsScreenState
    extends State<SurgeryPatientDetailsScreen> {
  // In the reference screenshot, "Corneal transplant." is the highlighted row
  // inside the expanded list — so selectedSurgery is different from what's
  // shown in the collapsed header ("Refractive Surgery · Rs. 115,000/-").
  bool showSurgeryOptions = true;
  String selectedSurgery = 'Corneal transplant.';
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
    patientNameController = TextEditingController();
    ageController = TextEditingController();
    contactNumberController = TextEditingController();
    emergencyContactController = TextEditingController();
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

    return Scaffold(
      backgroundColor: const Color(0xFFA6E3DA), // solid teal background
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ---------- Top teal header ----------
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 8.h, 12.w, 16.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF061E40),
                    ),
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

            // ---------- White rounded content area ----------
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 20.h),
                        children: [
                          Text(
                            'Patient Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF061E40),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          _DoctorSummary(widget: widget),
                          SizedBox(height: 20.h),

                          _TextInputField(
                            title: 'Patient Name',
                            hintText: 'Haseeb Qasim',
                            controller: patientNameController,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 14.h),
                          _TextInputField(
                            title: 'Age',
                            hintText: '24',
                            controller: ageController,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 14.h),
                          _TextInputField(
                            title: 'Contact Number',
                            hintText: '0341-1234567',
                            controller: contactNumberController,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 14.h),
                          _TextInputField(
                            title: 'Emergency Contact',
                            hintText: '0341-1234567',
                            controller: emergencyContactController,
                            keyboardType: TextInputType.phone,
                            hasError: showEmergencyError,
                            errorText: 'Enter Phone Number',
                          ),
                          SizedBox(height: 14.h),

                          Text(
                            'Surgery',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF061E40),
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // ---------- Surgery dropdown header ----------
                          InkWell(
                            onTap: () => setState(
                                  () => showSurgeryOptions = !showSurgeryOptions,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: const Color(0xFFF1F1F1),
                              ),

                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Refractive Surgery',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color: const Color(0xFF9AA4B0),
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Rs. 115,000/-',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF9AA4B0),
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Icon(
                                      showSurgeryOptions
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: const Color(0xFFB6BDC8),
                                      size: 17.r,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          // ---------- Expanded list of surgery options ----------
                          if (showSurgeryOptions)
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: List.generate(options.length, (i) {
                                  final option = options[i];
                                  final selected =
                                      option.name == selectedSurgery;
                                  final isLast = i == options.length - 1;
                                  return InkWell(
                                    onTap: () => setState(
                                          () => selectedSurgery = option.name,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? const Color(0xFFF1F1F1)
                                            : Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        border: Border(
                                          bottom: BorderSide(
                                            color: isLast
                                                ? Colors.transparent
                                                : const Color(0xFFEDEDED),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 14.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              option.name,
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                color: const Color(
                                                  0xFF061E40,
                                                ),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                option.price,
                                                style: theme
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                  color: const Color(
                                                    0xFF061E40,
                                                  ),
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                option.oldPrice,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                  color: const Color(
                                                    0xFFB4B4B4,
                                                  ),
                                                  fontSize: 12.sp,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),

                    // ---------- Bottom "Proceed Checkout" button ----------
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            blurRadius: 20,
                            offset: Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            final emergency = emergencyContactController.text
                                .trim();
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
                            minimumSize: Size.fromHeight(54.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            'Proceed Checkout',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17.sp,
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
                colors: [Colors.white, Colors.white, Colors.white,Color.fromRGBO(1, 205, 222, 0.08),],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60.r,
                  height: 60.r,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF8DD57C),
                    size: 60.r,
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
                      if (mounted) {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0FAA9A),
                      minimumSize: Size.fromHeight(54.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17.sp,
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

// ======================= Doctor Summary Card =======================
class _DoctorSummary extends StatelessWidget {
  const _DoctorSummary({required this.widget});

  final SurgeryPatientDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Doctor row — NO card background, sits directly on white
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 56.r,
                height: 56.r,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFEFEFEF),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                ),
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.speciality,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFA6A6A6),
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    '${widget.experience}  ${widget.qualifications}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFA6A6A6),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            // Partner logo (oladoc)
            Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.21),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: ClipOval(
                child: Image.network(
                  widget.partnerLogoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 14.h),

        // Hospital + price row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 2.h),
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
                Text(
                  'Stating from',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF777272),
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  widget.price,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  widget.oldPrice,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFB4B4B4),
                    fontSize: 13.sp,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 14.h),

        // Book Now button
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0FAA9A),
              minimumSize: Size.fromHeight(44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
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
    );
  }
}

// ======================= Text Input Field =======================
class _TextInputField extends StatelessWidget {
  const _TextInputField({
    required this.title,
    required this.controller,
    required this.keyboardType,
    this.hintText,
    this.hasError = false,
    this.errorText,
  });

  final String title;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool hasError;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // In error state we show the error message as the hint.
    // Otherwise we show the provided hintText in a light placeholder color.
    final String? effectiveHint = hasError ? errorText : hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF061E40),
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 48.h,
          padding: EdgeInsets.only(left: 12.w, right: 8.w),
          decoration: BoxDecoration(
            color: hasError
                ? const Color(0xFFFFF8F8)
                : const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border(
              bottom: BorderSide(
                color: hasError
                    ? const Color(0xFF852221)
                    : Colors.transparent,
                width: 0.6,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  // Typed text style — darker "filled" color
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: hasError
                        ? const Color(0xFFBA2025)
                        : const Color(0xFF4A555F),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    hintText: effectiveHint,
                    // Hint text style — light placeholder grey
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: hasError
                          ? const Color(0xFFBA2025)
                          : const Color(0xFFB6BDC8),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFFB6BDC8),
                size: 20.r,
              ),
            ],
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
