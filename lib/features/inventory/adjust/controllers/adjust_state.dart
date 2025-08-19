import '../../common/line_item.dart';

class AdjustState {
  const AdjustState({
    this.lines = const [],
    this.isSaving = false,
    this.error,
    this.fieldErrors = const {},
  });

  final List<LineItem> lines;
  final bool isSaving;
  final String? error;
  final Map<String, List<String>> fieldErrors;

  AdjustState copyWith({
    List<LineItem>? lines,
    bool? isSaving,
    String? error,
    Map<String, List<String>>? fieldErrors,
  }) => AdjustState(
        lines: lines ?? this.lines,
        isSaving: isSaving ?? this.isSaving,
        error: error,
        fieldErrors: fieldErrors ?? this.fieldErrors,
      );
}
