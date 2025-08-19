import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/models/recipe_line.dart';
import '../data/recipe_repository.dart';
import 'recipe_state.dart';

final recipeControllerProvider =
    StateNotifierProvider<RecipeController, RecipeState>((ref) {
  return RecipeController(ref);
});

class RecipeController extends StateNotifier<RecipeState> {
  RecipeController(this._ref) : super(const RecipeState());

  final Ref _ref;

  Future<void> load(int productId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = _ref.read(recipeRepositoryProvider);
      final lines = await repo.getRecipe(productId);
      state = state.copyWith(lines: lines);
    } catch (_) {
      state = state.copyWith(error: 'No se pudo cargar');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<String?> addLine(RecipeLine line) async {
    if (state.lines.any((l) => l.insumoId == line.insumoId)) {
      return 'Este insumo ya está en la receta';
    }
    state = state.copyWith(lines: [...state.lines, line], dirty: true);
    return null;
  }

  void updateLine(RecipeLine line) {
    final idx = state.lines.indexWhere((l) => l.insumoId == line.insumoId);
    if (idx == -1) return;
    final list = [...state.lines];
    list[idx] = line;
    state = state.copyWith(lines: list, dirty: true);
  }

  Future<void> removeLine(int insumoId) async {
    state = state.copyWith(
      lines: state.lines.where((l) => l.insumoId != insumoId).toList(),
      dirty: true,
    );
  }

  Future<void> saveAll(int productId) async {
    final repo = _ref.read(recipeRepositoryProvider);
    final lines = await repo.saveRecipe(productId, state.lines);
    state = state.copyWith(lines: lines, dirty: false);
  }

  Future<void> deleteLine(int productId, int insumoId) async {
    final repo = _ref.read(recipeRepositoryProvider);
    await repo.deleteLine(productId, insumoId);
    state = state.copyWith(
        lines: state.lines.where((l) => l.insumoId != insumoId).toList());
  }
}
