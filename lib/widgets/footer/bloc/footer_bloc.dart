import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'footer_event.dart';
part 'footer_state.dart';

class FooterBloc extends Bloc<FooterEvent, FooterState> {
  FooterBloc() : super(FooterInitial(currentIndex: 0)) {
    on<UpdateFooterIndex>((event, emit) {
      emit(FooterIndexUpdated(event.index));
    });
  }
}