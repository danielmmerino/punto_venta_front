import '../data/models/vendor.dart';

class VendorsState {
  const VendorsState({
    this.isLoading = false,
    this.vendors = const [],
    this.error,
  });

  final bool isLoading;
  final List<Vendor> vendors;
  final String? error;

  VendorsState copyWith({
    bool? isLoading,
    List<Vendor>? vendors,
    String? error,
  }) =>
      VendorsState(
        isLoading: isLoading ?? this.isLoading,
        vendors: vendors ?? this.vendors,
        error: error,
      );
}
