# Punto Venta Frontend

Fase 0 del frontend en Flutter con arquitectura base, theming dinámico y guardado seguro de sesión.

## Frontend / Pantalla: Login

Pantalla responsive (móvil y web) que permite iniciar sesión con email y contraseña.

### Flujo

1. El usuario ingresa sus credenciales y envía el formulario.
2. `POST /v1/auth/login` devuelve `token`, expiración (`exp` o `expires_in`), `user` y `locales`.
3. Se guarda el JWT en `flutter_secure_storage` junto con su TTL.
4. Se verifica la suscripción con `GET /v1/estado-suscripcion`.
5. Navegación:
   - Múltiples locales → `/selector-local`.
   - Único local → `/dashboard`.
6. Errores 401 muestran mensaje *"Credenciales inválidas"*.

### Configuración

El `BASE_URL` se configura con `--dart-define`:

```bash
flutter run --dart-define=BASE_URL=https://api.staging.tuapp.com -d chrome
```

El JWT se almacena en `flutter_secure_storage` y su expiración se calcula a partir de `exp`, `expires_in` o del claim dentro del propio JWT.

### Pruebas

```bash
flutter test
```

### Endpoints usados

| Método | Ruta | Descripción |
| ------ | ---- | ----------- |
| POST | `/v1/auth/login` | Inicio de sesión |
| GET | `/v1/estado-suscripcion` | Verificación de suscripción |
| GET | `/v1/tenancy/context` | Contexto de locales (opcional) |


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

1. **Sin JWT o expirado** → `/login`.
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
- Controlador y UI de login.
- Render de páginas placeholder.

Ejecutar:

```bash
flutter test
```
