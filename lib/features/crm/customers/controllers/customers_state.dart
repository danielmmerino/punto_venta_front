import '../data/models/customer.dart';

class CustomersState {
  const CustomersState({
    this.isLoading = false,
    this.customers = const [],
    this.error,
  });

  final bool isLoading;
  final List<Customer> customers;
  final String? error;

  CustomersState copyWith({
    bool? isLoading,
    List<Customer>? customers,
    String? error,
  }) =>
      CustomersState(
        isLoading: isLoading ?? this.isLoading,
        customers: customers ?? this.customers,
        error: error,
      );
}
