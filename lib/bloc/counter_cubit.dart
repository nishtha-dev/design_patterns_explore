import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  @override
  Future<void> close() {
    print("cubit closed");
    return super.close();
  }

  @override
  void onChange(Change<int> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}

class CounterState {}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print("${bloc.runtimeType}, $change");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

sealed class CounterEvent {}

final class CounterIncrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>(
      (event, emit) {
        emit(state + 1);
      },
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  @override
  void onChange(Change<int> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    // TODO: implement onTransition
    super.onTransition(transition);
  }
}

class AppIdeasRepository {
  int _currentAppIdea = 0;
  final List<String> _ideas = [
    "Future prediction app that rewards you if you predict the next day's news",
    'Dating app for fish that lets your aquarium occupants find true love',
    'Social media app that pays you when your data is sold',
    'JavaScript framework gambling app that lets you bet on the next big thing',
    'Solitaire app that freezes before you can win',
  ];

  Stream<String> productIdeas() async* {
    while (true) {
      yield _ideas[_currentAppIdea++ % _ideas.length];
      await Future<void>.delayed(const Duration(minutes: 1));
    }
  }
}

class AppIdeaRankingBloc
    extends Bloc<AppIdeaRankingEvent, AppIdeaRankingState> {
  AppIdeaRankingBloc({required AppIdeasRepository appIdeasRepo})
      : _appIdeasRepo = appIdeasRepo,
        super(AppIdeaInitialRankingState()) {
    on<AppIdeaStartRankingEvent>((event, emit) async {
      // emit.call(state);
      emit(state);

      await emit.onEach(goalDataServiceRepository.getAllGoalsData(),
          onData: (docSnapShotList) {
        add(SaveGoalDetailsEvent(docSnapShotList: docSnapShotList));
      }, onError: (error, stackTrace) {
        emit(state.copyWith(
            goalDetailsDataStatus: GoalDetailsDataStatus.failure));
      });

      // When we are told to start ranking app ideas, we will listen to the
      // stream of app ideas and emit a state for each one.
      await emit.forEach(
        _appIdeasRepo.productIdeas(),
        onData: (String idea) => AppIdeaRankingIdeaState(idea: idea),
      );
    });
  }

  final AppIdeasRepository _appIdeasRepo;
}
