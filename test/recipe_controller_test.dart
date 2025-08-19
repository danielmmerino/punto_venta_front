import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/recipe/controllers/recipe_controller.dart';
import 'package:punto_venta_front/features/recipe/data/models/recipe_line.dart';
import 'package:punto_venta_front/features/recipe/data/recipe_repository.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      RecipeLine(
        insumoId: 1,
        insumoCodigo: 'A',
        insumoNombre: 'A',
        cantidad: 1,
        mermaPorcentaje: 0,
      ),
    );
    registerFallbackValue(<RecipeLine>[]);
  });

  group('RecipeController', () {
    test('addLine rejects duplicates', () async {
      final repo = MockRecipeRepository();
      final container = ProviderContainer(overrides: [
        recipeRepositoryProvider.overrideWithValue(repo),
      ]);
      final controller = container.read(recipeControllerProvider.notifier);
      final line = RecipeLine(
        insumoId: 1,
        insumoCodigo: 'A',
        insumoNombre: 'A',
        cantidad: 1,
        mermaPorcentaje: 0,
      );
      await controller.addLine(line);
      final err = await controller.addLine(line);
      expect(err, isNotNull);
    });

    test('saveAll sends full list', () async {
      final repo = MockRecipeRepository();
      when(() => repo.saveRecipe(any(), any())).thenAnswer((invocation) async {
        final lines = invocation.positionalArguments[1] as List<RecipeLine>;
        return lines;
      });
      final container = ProviderContainer(overrides: [
        recipeRepositoryProvider.overrideWithValue(repo),
      ]);
      final controller = container.read(recipeControllerProvider.notifier);
      await controller.addLine(
        RecipeLine(
          insumoId: 1,
          insumoCodigo: 'A',
          insumoNombre: 'A',
          cantidad: 1,
          mermaPorcentaje: 0,
        ),
      );
      await controller.addLine(
        RecipeLine(
          insumoId: 2,
          insumoCodigo: 'B',
          insumoNombre: 'B',
          cantidad: 2,
          mermaPorcentaje: 10,
        ),
      );
      await controller.saveAll(1);
      verify(() => repo.saveRecipe(1, any())).called(1);
    });
  });
}
