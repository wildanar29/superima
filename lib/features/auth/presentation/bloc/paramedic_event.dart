import 'package:equatable/equatable.dart';

abstract class ParamedicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchParamedics extends ParamedicEvent {}
