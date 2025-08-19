import '../../common/line_item.dart';

class TransferState {
  const TransferState({
    this.lines = const [],
    this.isSaving = false,
    this.error,
    this.fieldErrors = const {},
  });

  final List<LineItem> lines;
  final bool isSaving;
  final String? error;
  final Map<String, List<String>> fieldErrors;

  TransferState copyWith({
    List<LineItem>? lines,
    bool? isSaving,
    String? error,
    Map<String, List<String>>? fieldErrors,
  }) => TransferState(
        lines: lines ?? this.lines,
        isSaving: isSaving ?? this.isSaving,
        error: error,
        fieldErrors: fieldErrors ?? this.fieldErrors,
      );
}
