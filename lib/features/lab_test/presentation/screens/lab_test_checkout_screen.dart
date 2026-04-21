import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../lab_test_figma_assets.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_figma_image.dart';

/// Checkout + patient details (Figma node `2303:63721`). Success overlay matches `2303:64679`.
class LabTestCheckoutScreen extends StatefulWidget {
  const LabTestCheckoutScreen({super.key, required this.args});

  final LabTestCheckoutArgs args;

  @override
  State<LabTestCheckoutScreen> createState() => _LabTestCheckoutScreenState();
}

class _LabTestCheckoutScreenState extends State<LabTestCheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = 'male';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _emergencyController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onProceed() {
    final code = widget.args.discountCode;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              color: const Color(0xFFF3F4F7),
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 380,
                  maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.82,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LabTestFigmaImage(
                        url: LabTestFigmaAssets.successCheckmark,
                        width: 140,
                        height: 140,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Lab Test Booked Successfully',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF0E2650),
                          fontWeight: FontWeight.w500,
                          fontSize: 21,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'A lab representative will contact you shortly.\n'
                        'Present your discount code to the lab representative.\n'
                        'To access your code later:',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF5676A8),
                          fontSize: 15,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Menu > My Bookings > Lab Test',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF0D1218),
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.discount_rounded,
                              color: Color(0xFF0D1218),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Discount Code',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: const Color(0xFF0D1218),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                              ),
                            ),
                            Text(
                              code,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF22185F),
                                    fontSize: 18,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 66,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF20A99D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            context.go(AppRoutes.path(AppRoutes.home));
                          },
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = widget.args;

    return Scaffold(
      backgroundColor: const Color(0xFFD5FFFB),
      body: Column(
        children: [
          _CheckoutHeader(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(42),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SummaryCard(args: a),
                              const SizedBox(height: 8),
                              _RequirementsCheckoutCard(
                                lines: a.requirementLines,
                                fastingLabel: a.requirementLabel,
                              ),
                              const SizedBox(height: 8),
                              _PaymentBreakdownCard(args: a),
                              const SizedBox(height: 6),
                              _PatientFormSection(
                                theme: theme,
                                nameController: _nameController,
                                phoneController: _phoneController,
                                ageController: _ageController,
                                emergencyController: _emergencyController,
                                addressController: _addressController,
                                gender: _gender,
                                onGender: (g) => setState(() => _gender = g),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _CheckoutBottomBar(onProceed: _onProceed),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x8087DDD3), Color(0x3387DDD3)],
          stops: [0, 0.34],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 18),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => context.pop(),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF061E40),
                      size: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Payment Details',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 30.9 / 20,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.args});

  final LabTestCheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x3308619C),
            blurRadius: 27,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(9),
                ),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child: LabTestFigmaImage(
                  url: args.labLogoUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            args.testTitle.split('\n').first,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF061E40),
                              fontSize: 18,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            args.labDisplayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF667B99),
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: -4,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0x352F2F2F),
                              width: 1.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: LabTestFigmaImage(
                              url: args.partnerLogoUrl,
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFF7F7F7), width: 1.0),
                        bottom: BorderSide(
                          color: Color(0xFFF7F7F7),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sample Type',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF667B99),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: const Color(0xFFE7E7E7),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            args.sampleType,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF667B99),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fee',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF667B99),
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                args.discountedFee,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF110844),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                args.originalFee,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: const Color(0xFF979797),
                                  fontSize: 12,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequirementsCheckoutCard extends StatelessWidget {
  const _RequirementsCheckoutCard({required this.lines, this.fastingLabel});

  final List<String> lines;
  final String? fastingLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33085283),
            blurRadius: 27,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Requirements',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                if (fastingLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB7EAC3),
                      borderRadius: BorderRadius.circular(59),
                    ),
                    child: Text(
                      fastingLabel!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'Afacad',
                        color: const Color(0xFF198733),
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < lines.length; i++) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 24,
                      bottom: i == lines.length - 1 ? 0 : 10,
                    ),
                    child: Text(
                      '${i + 1}. ${lines[i]}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Afacad',
                        fontSize: 16,
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBreakdownCard extends StatelessWidget {
  const _PaymentBreakdownCard({required this.args});

  final LabTestCheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4208619C),
            blurRadius: 27,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Payment Details',
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _moneyRow(theme, 'Fee', '80,000'),
                _moneyRow(
                  theme,
                  'Discount (${args.discountPercent}%)',
                  args.discountAmount,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 9, 12, 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFBA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Transform.rotate(
                              angle: 3.14159,
                              child: LabTestFigmaImage(
                                url: LabTestFigmaAssets.checkoutDiscountIcon,
                                width: 15.394,
                                height: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Discount Code',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              args.discountCode,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF110844),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16, color: Color(0x14000000)),
                        Text(
                          'Show this code to the lab representative',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF110844),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFEBECEE),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF667B99),
                        fontSize: 12,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      args.totalAmount,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF110844),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyRow(ThemeData theme, String label, String amountDigits) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF9BA6A7), width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF667B99),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
              Text(
                amountDigits,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF110844),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PatientFormSection extends StatelessWidget {
  const _PatientFormSection({
    required this.theme,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.emergencyController,
    required this.addressController,
    required this.gender,
    required this.onGender,
  });

  final ThemeData theme;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController emergencyController;
  final TextEditingController addressController;
  final String gender;
  final ValueChanged<String> onGender;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionHeader('Patient Details', trailing: 'Edit'),
        const SizedBox(height: 6),
        _formCard(
          children: [
            _fieldLabel('Patient Name'),
            _greyField(controller: nameController, hint: 'Full name'),
            const SizedBox(height: 19),
            _fieldLabel('Contact Number'),
            _greyField(
              controller: phoneController,
              hint: 'Type or select from phonebook',
              suffix: LabTestFigmaImage(
                url: LabTestFigmaAssets.checkoutAddressBook,
                width: 16,
                height: 16,
              ),
            ),
            const SizedBox(height: 19),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _fieldLabel('Gender'),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: _genderChip(
                              label: 'Male',
                              selected: gender == 'male',
                              onTap: () => onGender('male'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _genderChip(
                              label: 'Female',
                              selected: gender == 'female',
                              onTap: () => onGender('female'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 19),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _fieldLabel('Age'),
                      const SizedBox(height: 3),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF061E40),
                            fontSize: 12,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        _sectionHeader('Emergency Contact'),
        const SizedBox(height: 6),
        _formCard(
          children: [
            Text(
              'Please provide an emergency contact number, incase you are unavailable.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF667B99),
                fontSize: 12,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            _greyField(
              controller: emergencyController,
              hint: 'Enter Number here...',
            ),
          ],
        ),
        const SizedBox(height: 6),
        _sectionHeader('Address'),
        const SizedBox(height: 6),
        _formCard(
          children: [
            Text(
              'This address will be used for sample collection only.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF667B99),
                fontSize: 12,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            _greyField(
              controller: addressController,
              hint: 'Type address here...',
              minLines: 2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF024886),
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _formCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33085283),
            blurRadius: 27,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          color: const Color(0xFF061E40),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _greyField({
    required TextEditingController controller,
    required String hint,
    Widget? suffix,
    int minLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: minLines,
              maxLines: minLines > 1 ? 4 : 1,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF667B99),
                fontSize: 12,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF667B99),
                  fontSize: 12,
                ),
              ),
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }

  Widget _genderChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(51),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(51),
            border: Border.all(
              color: selected
                  ? const Color(0xFF061E40)
                  : const Color(0xFFE7E7E7),
              width: 1.0,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 13,
                  height: 13,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF061E40),
                      width: 1.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: selected
                      ? Container(
                          width: 7.082,
                          height: 6.665,
                          decoration: BoxDecoration(
                            color: const Color(0xFF061E40),
                            borderRadius: BorderRadius.circular(10.801),
                          ),
                        )
                      : null,
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: selected
                        ? const Color(0xFF061E40)
                        : const Color(0xFF667B99),
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckoutBottomBar extends StatelessWidget {
  const _CheckoutBottomBar({required this.onProceed});

  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            offset: const Offset(0, -5),
            blurRadius: 30,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 57,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAA9A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.909),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                onPressed: onProceed,
                child: const Text('Proceed Checkout'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 135,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFB9C0C9),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
