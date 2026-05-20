// Device preview helpers for responsive testing (debug only).
// Release builds (`dart.vm.product`) use the stub without the package.
export 'device_preview_impl.dart'
    if (dart.vm.product) 'device_preview_stub.dart';
