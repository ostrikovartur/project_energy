part of 'footer_bloc.dart';

abstract class FooterState extends Equatable {
  const FooterState();

  @override
  List<Object> get props => [];
}

class FooterInitial extends FooterState {
  final int currentIndex;
  
  const FooterInitial({required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];
}

class FooterIndexUpdated extends FooterState {
  final int currentIndex;
  
  const FooterIndexUpdated(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}