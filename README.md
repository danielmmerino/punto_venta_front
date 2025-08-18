# Punto Venta Frontend

Fase 0 del frontend en Flutter con arquitectura base, theming dinámico y guardado seguro de sesión.

## Arquitectura Frontend

- **Estado**: Riverpod (`hooks_riverpod`).
- **Routing**: `go_router` con `redirect` global para autenticación y suscripción.
- **HTTP**: `Dio` con interceptores para JWT, refresco y control de suscripción.
- **Almacenamiento seguro**: `flutter_secure_storage` para JWT y vencimiento.

## Theming

Los estilos provienen de tokens definidos en `assets/theme/theme.json`.
Se exponen como `ThemeExtension`:

- `AppColors`: paleta completa (brand, neutrales, semantic y surfaces).
- `AppSpacing`: espaciados `xs`..`xxl`.
- `AppRadius`: radios `sm`, `md`, `lg`, `pill`.

El `ThemeController` carga este archivo y genera el `ColorScheme` mediante `ColorScheme.fromSeed`. Los valores pueden modificarse en tiempo de ejecución recargando el controlador.

## Configuración

`BASE_URL` se lee desde `--dart-define` y, opcionalmente, desde un archivo `.env` en la raíz del proyecto.

Ejemplo:

```bash
flutter run --dart-define=BASE_URL=https://api.staging.tuapp.com -d chrome
```

## Guard Global

El router redirige las rutas protegidas según el estado:

1. **Sin JWT o expirado** → `/auth/blocked`.
2. **JWT válido pero suscripción inválida** → `/subscription/blocked`.
3. **JWT válido y suscripción activa** → acceso permitido.

Las respuestas `401` provocan un `refresh()` automático; `403` consulta el estado de suscripción.

## APIs usadas

| Método | Ruta | Descripción |
| ------ | ---- | ----------- |
| POST | `/v1/auth/login` | Inicio de sesión |
| POST | `/v1/auth/refresh` | Renovación de token |
| GET | `/v1/auth/me` | Perfil actual |
| GET | `/v1/estado-suscripcion` | Verificación de suscripción |

## Cómo correr

```bash
flutter pub get
flutter run --dart-define=BASE_URL=https://api.staging.tuapp.com -d chrome
```

## Pruebas

Los tests cubren:

- Manejo de token y expiración en `AuthRepository`.
- Render básico de páginas placeholder.

Ejecutar:

```bash
flutter test
```
