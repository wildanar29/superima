import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_paramedics_usecase.dart';
import 'paramedic_event.dart';
import 'paramedic_state.dart';

class ParamedicBloc extends Bloc<ParamedicEvent, ParamedicState> {
  final GetAllParamedicsUseCase getAllParamedicsUseCase;

  ParamedicBloc(this.getAllParamedicsUseCase) : super(ParamedicInitial()) {
    on<FetchParamedics>((event, emit) async {
      try {
        emit(ParamedicLoading());
        final paramedics = await getAllParamedicsUseCase.execute();
        emit(ParamedicLoaded(paramedics));
      } catch (e) {
        emit(ParamedicError(e.toString()));
      }
    });
  }
}
