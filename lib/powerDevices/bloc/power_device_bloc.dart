import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'power_device_event.dart';
part 'power_device_state.dart';

class PowerDeviceBloc extends Bloc<PowerDeviceEvent, PowerDeviceState> {
  PowerDeviceBloc() : super(PowerDeviceInitial()) {
    on<PowerDeviceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
