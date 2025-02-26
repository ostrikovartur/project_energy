part of 'power_device_bloc.dart';

sealed class PowerDeviceState extends Equatable {
  const PowerDeviceState();
  
  @override
  List<Object> get props => [];
}

final class PowerDeviceInitial extends PowerDeviceState {}
