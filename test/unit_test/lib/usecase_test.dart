import 'package:bloc_explore/parking/entities/parking_slot.dart';
import 'package:bloc_explore/parking/entities/ticket.dart';
import 'package:bloc_explore/parking/entities/vehiche_entity.dart';
import 'package:bloc_explore/parking/repo/repo.dart';
import 'package:bloc_explore/parking/strategy/parking_spot_find_strategy.dart';
import 'package:bloc_explore/parking/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockParkingRepository extends Mock implements ParkingRepository {}

// class MockParkingSpot extends Mock implements ParkingSpot{}
void main() {
  late MockParkingRepository mockParkingRepository;
  late ParkVehicleUseCase parkVehicleUseCase;

  setUpAll(() {
    mockParkingRepository = MockParkingRepository();
    parkVehicleUseCase =
        ParkVehicleUseCase(parkingRepository: mockParkingRepository);
  });

  group('ParkVehicleUseCase tests', () {
    const parkingSpotFindStrategy = DefaultParkingSpotFindStrategy();
    test('should park vehicle when parkingSpotFindStrategy is defines',
        () async {
      const mockVehicle = SmallCar(
          vehicleId: 1234,
          licenceNumber: '1234',
          vehicleType: VehicleType.normal);

      final mockSlotList = [
        SmallParkingSpot(
            name: 'small', spotId: 1, spotStatus: SpotStatus.empty),
        // MediumParkingSpot(
        //     name: 'medium', spotId: 1, spotStatus: SpotStatus.empty),
        // LargeParkingSpot(
        //     name: 'large', spotId: 1, spotStatus: SpotStatus.empty),
      ];

      final expectedTicket = ParkingTicket(
          id: '1234',
          entryTime: DateTime.now(),
          slotId: 1,
          vehicleSize: VehicleSize.small,
          vehicleType: VehicleType.normal);

      when(
        () => mockParkingRepository.getAllSlots(),
      ).thenAnswer((_) async => mockSlotList);
      when(
        () => mockParkingRepository.parkVehicle(1, mockVehicle),
      ).thenAnswer((_) async => expectedTicket);

      final result = await parkVehicleUseCase.execute(
          mockVehicle, parkingSpotFindStrategy);
      expect(result.$1.slotId, equals(1));
      // expect(
      //     result.$2,
      //     equals(SmallParkingSpot(
      //         name: 'small', spotId: 1, spotStatus: SpotStatus.empty)));
      expect(result.$2, equals(mockSlotList.first));
      expect(result, isA<(ParkingTicket, ParkingSpot)>());

      verify(() => mockParkingRepository.getAllSlots()).called(1);
      verify(() => mockParkingRepository.parkVehicle(1, mockVehicle)).called(1);
    });

    test('throws exception when no slot founc', () async {
      const mockVehicle = LargeCar(
          vehicleId: 1234,
          licenceNumber: '1234',
          vehicleType: VehicleType.normal);

      final mockSlotList = [
        SmallParkingSpot(
            name: 'small', spotId: 1, spotStatus: SpotStatus.empty),
      ];

      when(
        () => mockParkingRepository.getAllSlots(),
      ).thenAnswer((_) async => mockSlotList);

      expect(
          () =>
              parkVehicleUseCase.execute(mockVehicle, parkingSpotFindStrategy),
          throwsA(isA<Exception>().having((e) => e.toString(), 'error',
              contains('No suitable slot found for the vehicle'))));

      verify(() => mockParkingRepository.getAllSlots()).called(1);
      verifyNever(() => mockParkingRepository.parkVehicle(1, mockVehicle));
    });

    test('throws exception when when repository fails', () async {
      const mockVehicle = LargeCar(
          vehicleId: 1234,
          licenceNumber: '1234',
          vehicleType: VehicleType.normal);

      final mockSlotList = [
        SmallParkingSpot(
            name: 'small', spotId: 1, spotStatus: SpotStatus.empty),
      ];

      when(
        () => mockParkingRepository.getAllSlots(),
      ).thenThrow(Exception('Database error'));

      expect(
          () =>
              parkVehicleUseCase.execute(mockVehicle, parkingSpotFindStrategy),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'error', contains('Database error'))));

      verify(() => mockParkingRepository.getAllSlots()).called(1);
      verifyNever(() => mockParkingRepository.parkVehicle(1, mockVehicle));
    });
  });
}
