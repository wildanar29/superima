import '../repositories/schedule_repository.dart';

class CheckParamedicScheduleUseCase {
  final ParamedicScheduleRepository repository;

  CheckParamedicScheduleUseCase(this.repository);

  Future<bool> execute(
      String dateStart,
      String dateEnd,
      String paramedicID,
      String serviceUnitID,
      ) {
    return repository.hasParamedicSchedule(
      dateStart,
      dateEnd,
      paramedicID,
      serviceUnitID,
    );
  }
}
