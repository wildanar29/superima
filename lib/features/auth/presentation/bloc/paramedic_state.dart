import 'package:equatable/equatable.dart';
import '../../domain/entities/paramedic.dart';

abstract class ParamedicState extends Equatable {
  @override
  List<Object> get props => [];
}

class ParamedicInitial extends ParamedicState {}

class ParamedicLoading extends ParamedicState {}

class ParamedicLoaded extends ParamedicState {
  final List<Paramedic> paramedics;

  ParamedicLoaded(this.paramedics);

  @override
  List<Object> get props => [paramedics];
}

class ParamedicError extends ParamedicState {
  final String message;

  ParamedicError(this.message);

  @override
  List<Object> get props => [message];
}
