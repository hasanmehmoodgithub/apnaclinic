import 'package:apnaclinic/features/lab_test/domain/entities/lab_test_cart_item.dart';
import 'package:apnaclinic/features/lab_test/domain/repositories/lab_test_cart_repository.dart';
import 'package:apnaclinic/features/lab_test/domain/use_cases/get_lab_test_detail_use_case.dart';
import 'package:apnaclinic/features/lab_test/presentation/cubit/lab_test_booking_cubit.dart';
import 'package:apnaclinic/features/lab_test/presentation/cubit/lab_test_cart_cubit.dart';
import 'package:apnaclinic/features/lab_test/presentation/lab_test_route_args.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLabTestCartRepository implements LabTestCartRepository {
  List<LabTestCartItem> items = [];

  @override
  Future<List<LabTestCartItem>> readCart() async => items;

  @override
  Future<void> writeCart(List<LabTestCartItem> next) async {
    items = next;
  }
}

class _FakeGetLabTestDetailUseCase implements GetLabTestDetailUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('LabTestBookingCubit patientDetails from cart', () {
    late _FakeLabTestCartRepository cartRepository;
    late LabTestCartCubit cartCubit;
    late _FakeGetLabTestDetailUseCase getDetailUseCase;

    setUp(() {
      cartRepository = _FakeLabTestCartRepository();
      cartCubit = LabTestCartCubit(cartRepository);
      getDetailUseCase = _FakeGetLabTestDetailUseCase();
    });

    tearDown(() {
      cartCubit.close();
    });

    LabTestCartItem createCartItem({required String patientAge}) {
      return LabTestCartItem(
        testId: 1,
        testTitle: 'CBC',
        city: 'Lahore',
        labId: '1',
        labDisplayName: 'Chughtai',
        labLogoUrl: '',
        partnerId: '1',
        partnerLogoUrl: '',
        partnerName: 'Chughtai Lab',
        sampleType: 'Blood',
        requirementLabel: null,
        requirementLines: const [],
        discountedFee: '1000',
        originalFee: '1000',
        discountPercent: 0,
        discountAmount: '0',
        discountCode: '',
        totalAmount: '1000',
        bookingMethodIsHomeSample: true,
        patientName: 'Jane Doe',
        patientAge: patientAge,
        patientGender: 'female',
      );
    }

    test('clears patient age if cart item has age > 99', () async {
      cartRepository.items = [createCartItem(patientAge: '105')];

      final cubit = LabTestBookingCubit(
        args: const LabTestBookingArgs.pending(
          testId: 1,
          city: 'Lahore',
          requirementLines: [],
        ),
        cartRepository: cartRepository,
        sharedCartCubit: cartCubit,
        getLabTestDetailUseCase: getDetailUseCase,
      );

      await cubit.hydrate();

      expect(cubit.state.patientDetails, isNotNull);
      expect(cubit.state.patientDetails!.name, 'Jane Doe');
      expect(cubit.state.patientDetails!.age, '');
      expect(cubit.state.patientDetails!.gender, 'female');

      await cubit.close();
    });

    test('preserves patient age if cart item has age <= 99', () async {
      cartRepository.items = [createCartItem(patientAge: '75')];

      final cubit = LabTestBookingCubit(
        args: const LabTestBookingArgs.pending(
          testId: 1,
          city: 'Lahore',
          requirementLines: [],
        ),
        cartRepository: cartRepository,
        sharedCartCubit: cartCubit,
        getLabTestDetailUseCase: getDetailUseCase,
      );

      await cubit.hydrate();

      expect(cubit.state.patientDetails, isNotNull);
      expect(cubit.state.patientDetails!.name, 'Jane Doe');
      expect(cubit.state.patientDetails!.age, '75');
      expect(cubit.state.patientDetails!.gender, 'female');

      await cubit.close();
    });
  });
}
