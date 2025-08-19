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

## Frontend / Selector de Empresa/Local

Pantalla responsive para elegir el local de trabajo.

### Flujo de datos

1. Se consulta `GET /v1/tenancy/context` para obtener empresa, locales y estado de suscripción.
2. Si no se reciben locales se usa `GET /v1/locales?mine=1`.
3. Al seleccionar un local se valida su suscripción con `GET /v1/estado-suscripcion?local_id=<id>`
   (o sin parámetro si el backend no lo soporta).
4. Cuando la suscripción está vigente se guarda `local_id` y `empresa_id` en el `ContextController`,
   se persiste el `local_id` opcionalmente y se configura el header `X-Local-Id` para todas las
   peticiones posteriores.
5. Navegación a `/dashboard`. Si la suscripción no está activa se redirige a `/subscription/blocked`.

### Responsive

El listado usa un `GridView` adaptable (`SliverGridDelegateWithMaxCrossAxisExtent`) que muestra una columna en móviles y varias
columnas en pantallas anchas.

### Endpoints usados

| Método | Ruta | Descripción |
| ------ | ---- | ----------- |
| GET | `/v1/tenancy/context` | Obtiene empresa y locales del usuario |
| GET | `/v1/locales?mine=1` | Fallback de locales del usuario |
| GET | `/v1/estado-suscripcion?local_id=…` | Valida suscripción para el local |


## Frontend / Dashboard

Pantalla principal post-login que muestra KPIs y alertas del día.

### KPIs

- **Ventas del día** y **ticket promedio** calculados desde `GET /v1/reportes/ventas-dia`.
- **Top 5 productos** del día a partir de `GET /v1/reportes/productos-mas-vendidos`.

### Alertas

- **Caja no abierta** cuando `GET /v1/caja/estado` (o fallback de aperturas) indica que no hay caja activa.
- **Suscripción por vencer** si `trial_ends_at` o `next_renewal_at` ocurre en ≤ 7 días.

Todas las fechas se calculan con zona horaria `America/Guayaquil` para cortes diarios.

### Endpoints usados

| Método | Ruta | Descripción |
| ------ | ---- | ----------- |
| GET | `/v1/reportes/ventas-dia` | Ventas del día por hora |
| GET | `/v1/reportes/productos-mas-vendidos` | Top de productos del día |
| GET | `/v1/estado-suscripcion` | Estado de suscripción para alertas |
| GET | `/v1/caja/estado` | Estado de la caja del local actual |

La interfaz es responsive y utiliza los mismos componentes en móvil y web.

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
