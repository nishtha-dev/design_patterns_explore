import 'package:bloc_explore/parking/bloc/parking_bloc.dart';
import 'package:bloc_explore/parking/entities/parking_slot.dart';
import 'package:bloc_explore/parking/repo/repo.dart';
import 'package:bloc_explore/parking/usecase/usecase.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockParkVehicleUseCase extends Mock implements ParkVehicleUseCase {}

class MockUnparkVehicleUseCase extends Mock implements UnparkVehicleUseCase {}

class MockGetAllSlotsUseCase extends Mock implements GetAllSlotsUseCase {}

void main() {
  late MockParkVehicleUseCase mockParkVehicleUseCase;
  late MockGetAllSlotsUseCase mockGetAllSlotsUseCase;
  late MockUnparkVehicleUseCase mockUnparkVehicleUseCase;
  late ParkingBloc parkingBloc;

  setUpAll(() {
    mockParkVehicleUseCase = MockParkVehicleUseCase();
    mockGetAllSlotsUseCase = MockGetAllSlotsUseCase();
    mockUnparkVehicleUseCase = MockUnparkVehicleUseCase();
    parkingBloc = ParkingBloc(
      parkVehicleUseCase: mockParkVehicleUseCase,
      unparkVehicleUseCase: mockUnparkVehicleUseCase,
      getAllSlotsUseCase: mockGetAllSlotsUseCase,
    );
  });

  // tearDown(() {
  //   parkingBloc.close();
  // });

  const initialState = ParkingState(
    apiStatus: ApiStatus2.initial,
    parkingSpotList: [],
    selectedPricingType: 'hourly',
    trafficLevel: 0.0,
    lastParkedTicket: null,
    lastUnparkResult: null,
  );

  group("initial state test", () {
    test('initial state is correct', () {
      expect(parkingBloc.state, initialState);
    });

    test('works properly', () {
      expect(parkingBloc, isA<ParkingBloc>());
    });
  });

  group('load parking slots', () {
    const page = 1;
    const limit = 10;
    final parkingSpotList = [
      SmallParkingSpot(name: 'small', spotId: 1, spotStatus: SpotStatus.empty),
    ];
    final PaginatedSlotsResult mockResp = PaginatedSlotsResult(
        slots: parkingSpotList,
        hasMore: true,
        currentPage: 1,
        total: parkingSpotList.length);

    blocTest(
      'load parking slots',
      build: () {
        when(
          () => mockGetAllSlotsUseCase.executeWithPagination(
            page: page,
            limit: limit,
          ),
        ).thenAnswer((_) async => mockResp);

        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadParkingSlots("hourly")),
      expect: () => [
        isA<ParkingState>().having((state) => state.apiStatus, 'apistatus',
            equals(ApiStatus2.loading)),
        isA<ParkingState>()
            .having(
                (state) => state.parkingSpotList, 'apistatus', parkingSpotList)
            .having((state) => state.selectedPricingType, 'selectedPricingType',
                equals('hourly'))
            .having((state) => state.trafficLevel, 'trafficLevel', equals(0)),
      ],
      verify: (bloc) {
        verify(
          () => mockGetAllSlotsUseCase.executeWithPagination(
            page: page,
            limit: limit,
          ),
        ).called(1);
      },
    );

    blocTest(
      'error case',
      build: () {
        when(
          () => mockGetAllSlotsUseCase.executeWithPagination(
            page: page,
            limit: limit,
          ),
        ).thenThrow(Exception());

        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadParkingSlots("hourly")),
      expect: () => [
        isA<ParkingState>().having((state) => state.apiStatus, 'apistatus',
            equals(ApiStatus2.loading)),
        isA<ParkingState>().having(
            (state) => state.apiStatus, 'apistatus', equals(ApiStatus2.error)),
      ],
      verify: (bloc) {
        verify(
          () => mockGetAllSlotsUseCase.executeWithPagination(
            page: page,
            limit: limit,
          ),
        ).called(1);
      },
    );
  });
}
