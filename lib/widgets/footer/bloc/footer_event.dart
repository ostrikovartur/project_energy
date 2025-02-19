part of 'footer_bloc.dart';

abstract class FooterEvent extends Equatable {
  const FooterEvent();

  @override
  List<Object> get props => [];
}

class UpdateFooterIndex extends FooterEvent {
  final int index;
  const UpdateFooterIndex(this.index);

  @override
  List<Object> get props => [index];
}