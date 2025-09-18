import 'package:bloc_explore/parking/repo/remote_source.dart';
import 'package:bloc_explore/parking/repo/repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockParkingRemoteSource extends Mock implements ParkingRemoteSource {}

void main() {
  late ParkingRepositoryImpl parkingRepositoryImpl;
  late MockParkingRemoteSource mockParkingRemoteSource;

  setUp(() {
    mockParkingRemoteSource = MockParkingRemoteSource();

    parkingRepositoryImpl = ParkingRepositoryImpl(mockParkingRemoteSource);
  });

  group('getAllSlotsWithPagination', () {
    test('returns response', () async {
      int page = 1;
      int limit = 10;
      final mockDtoList = [
        {
          'spotId': 1,
          'slotType': 'vip',
          'spotStatus': 'occupied',
          'size': 'small'
        },
      ];
      final mockResponse = ApiResponse(
        status: 'success',
        message: 'Available slots retrieved successfully',
        data: {
          'slots': mockDtoList,
          'pagination': {
            'currentPage': page,
            'limit': limit,
            'total': mockDtoList.length,
            'hasMore': true,
          }
        },
      );

      when(
        () => mockParkingRemoteSource.getAllSlots(page: page, limit: limit),
      ).thenAnswer((_) async => mockResponse);

      final result = await parkingRepositoryImpl.getAllSlotsWithPagination(
          page: page, limit: limit);
      expect(result, isA<PaginatedSlotsResult>());

      expect(result.slots.first.spotId, 1);
      expect(result.hasMore, isTrue);
    });

    test('_remoteSource fails', () async {
      int page = 1;
      int limit = 10;

      when(
        () => mockParkingRemoteSource.getAllSlots(page: page, limit: limit),
      ).thenThrow(Exception('Network error'));

      // expect(
      //     () async => parkingRepositoryImpl.getAllSlotsWithPagination(
      //         page: page, limit: limit),
      //     throwsException);
      expect(
          () async => parkingRepositoryImpl.getAllSlotsWithPagination(
              page: page, limit: limit),
          throwsA(isA<Exception>()
              .having((e) => e.toString(), 'error', contains('error'))));
      verify(() =>
              mockParkingRemoteSource.getAllSlots(page: page, limit: limit))
          .called(1);
    });
  });
}
