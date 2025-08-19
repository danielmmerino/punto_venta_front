import '../data/models/recipe_line.dart';

class RecipeState {
  const RecipeState({
    this.lines = const [],
    this.isLoading = false,
    this.error,
    this.dirty = false,
  });

  final List<RecipeLine> lines;
  final bool isLoading;
  final String? error;
  final bool dirty;

  RecipeState copyWith({
    List<RecipeLine>? lines,
    bool? isLoading,
    String? error,
    bool? dirty,
  }) => RecipeState(
        lines: lines ?? this.lines,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        dirty: dirty ?? this.dirty,
      );
}
