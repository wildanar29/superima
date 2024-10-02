abstract class ParamedicScheduleRepository {
  /// Memeriksa apakah ada jadwal paramedic berdasarkan access key, tanggal, paramedicID, dan serviceUnitID.
  Future<bool> hasParamedicSchedule(
      String dateStart,
      String dateEnd,
      String paramedicID,
      String serviceUnitID,
      );
}
