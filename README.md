# Garmin MCP Server

Un servidor [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) que conecta Claude con Garmin Connect. Permite consultar datos de salud, crear entrenamientos, buscar ejercicios y mucho más directamente desde Claude Desktop o cualquier cliente MCP.

## ¿Qué hace?

Expone **50+ herramientas** que Claude puede invocar para interactuar con tu cuenta de Garmin Connect:

- **Salud diaria** — pasos, calorías, frecuencia cardíaca, estrés, Body Battery, SpO2
- **Sueño** — duración, fases (profundo/ligero/REM), puntuación
- **Métricas avanzadas** — HRV, Training Readiness, VO2 Max, Lactate Threshold, FTP
- **Actividades** — historial, detalles, zonas de FC, splits, series de fuerza
- **Entrenamientos** — crear, programar y eliminar workouts (running, cycling, swimming, strength, triatlón)
- **Composición corporal** — peso, IMC, % grasa, masa muscular
- **Dispositivos y equipo** — info de relojes, zapatillas, bicicletas
- **Metas y logros** — badges, challenges, progreso
- **Catálogo de ejercicios de fuerza** — búsqueda en español/inglés sobre 1.494 ejercicios en 39 categorías

## Requisitos

- Python 3.10+
- Una cuenta de Garmin Connect activa
- [Claude Desktop](https://claude.ai/download) u otro cliente MCP

## Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/garmin-mcp.git
cd garmin-mcp

# 2. Instalar dependencias
pip install -r requirements.txt
```

> **Recomendado:** usar un entorno virtual (`python -m venv .venv && source .venv/bin/activate` en Mac/Linux o `.venv\Scripts\activate` en Windows).

## Configuración en Claude Desktop

Edita el archivo de configuración de Claude Desktop:

- **Mac:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "garmin": {
      "command": "python",
      "args": ["/ruta/absoluta/a/garmin-mcp/server.py"],
      "env": {
        "GARMIN_EMAIL": "tu_email@ejemplo.com",
        "GARMIN_PASSWORD": "tu_contraseña"
      }
    }
  }
}
```

Reinicia Claude Desktop. Verás un ícono de herramientas en la barra de texto — ahí aparecerán las herramientas de Garmin disponibles.

> Los tokens de sesión se guardan automáticamente en `~/.garmin-mcp-python/garmin_tokens.json` para evitar logins repetidos.

## Uso

Una vez configurado, simplemente habla con Claude en lenguaje natural:

```
"¿Cuántos pasos hice esta semana?"
"Crea un entrenamiento de fuerza: press banca 4x8, sentadilla 4x6, peso muerto 3x5"
"¿Cómo estuvo mi sueño en los últimos 7 días?"
"¿Cuál es mi VO2 Max actual?"
"Programa el workout 'Upper A' para el próximo lunes"
```

Claude decide automáticamente qué herramientas invocar y combina los resultados.

## Herramientas disponibles

<details>
<summary><strong>Perfil y usuario (4)</strong></summary>

| Herramienta | Descripción |
|---|---|
| `get_user_profile` | Datos del perfil (nombre, ubicación, etc.) |
| `get_user_settings` | Zona horaria, unidades, horario de sueño |
| `get_user_summary` | Resumen diario completo |
| `get_personal_records` | Récords en carreras (5K, 10K, media maratón, maratón) |

</details>

<details>
<summary><strong>Salud diaria (8)</strong></summary>

| Herramienta | Descripción |
|---|---|
| `get_stats` | Pasos, calorías, distancia, pisos, minutos activos, FC |
| `get_steps` | Detalle de pasos del día |
| `get_heart_rates` | FC durante el día |
| `get_resting_heart_rate` | FC en reposo |
| `get_stress_data` | Niveles de estrés |
| `get_body_battery` | Energía Body Battery |
| `get_respiration_data` | Frecuencia respiratoria |
| `get_spo2_data` | Saturación de oxígeno |

</details>

<details>
<summary><strong>Sueño (1)</strong></summary>

| Herramienta | Descripción |
|---|---|
| `get_sleep_data` | Duración, fases (profundo/ligero/REM), puntuación de sueño |

</details>

<details>
<summary><strong>Métricas avanzadas (9)</strong></summary>

| Herramienta | Descripción |
|---|---|
| `get_hrv_data` | Variabilidad de frecuencia cardíaca (HRV) |
| `get_training_readiness` | Score de preparación 0-100 |
| `get_training_status` | Estado (productivo, manteniendo, sobrecargado, etc.) |
| `get_vo2max` | Consumo máximo de oxígeno estimado |
| `get_lactate_threshold` | Umbral de lactato |
| `get_race_predictions` | Predicciones de tiempos en carrera |
| `get_fitness_age` | Edad de fitness estimada |
| `get_endurance_score` | Puntuación de resistencia |
| `get_hill_score` | Puntuación en desnivel |

</details>

<details>
<summary><strong>Tendencias históricas (9)</strong></summary>

Todas aceptan `start_date` y `end_date` en formato `YYYY-MM-DD`.

`get_steps_trend`, `get_stress_trend`, `get_intensity_minutes_trend`, `get_hrv_trend`, `get_sleep_trend`, `get_body_battery_trend`, `get_resting_hr_trend`, `get_weight_trend`, `get_hydration_trend`

</details>

<details>
<summary><strong>Actividades (8)</strong></summary>

| Herramienta | Descripción |
|---|---|
| `get_activities` | Lista paginada de actividades |
| `get_activities_by_date` | Filtrable por tipo y rango de fechas |
| `get_last_activity` | Última actividad registrada |
| `get_activity_details` | Métricas completas de una actividad |
| `get_activity_hr_zones` | Tiempo en cada zona de FC |
| `get_activity_splits` | Splits (vueltas/km) |
| `get_activity_weather` | Condiciones climáticas durante la actividad |
| `get_activity_exercise_sets` | Series de fuerza (reps, peso, duración) |

</details>

<details>
<summary><strong>Entrenamientos (5)</strong></summary>

| Herramienta | Descripción |
|---|---|
| `add_workout` | Crear un workout estructurado |
| `schedule_workout` | Programar un workout en el calendario |
| `delete_workout` | Eliminar un workout |
| `get_workouts` | Listar workouts guardados |
| `get_workout` | Detalle de un workout específico |

`add_workout` soporta: running, cycling, swimming, strength_training, cardio, yoga, multi_sport (triatlón). Incluye warmup, cooldown, intervalos, repeticiones, targets de FC/pace/potencia y grupos de repetición.

</details>

<details>
<summary><strong>Composición corporal (5)</strong></summary>

`get_body_composition`, `get_latest_weight`, `get_weigh_ins`, `add_weigh_in`, `get_blood_pressure`

</details>

<details>
<summary><strong>Metas y logros (6)</strong></summary>

`get_goals`, `get_earned_badges`, `get_available_badges`, `get_badge_challenges`, `get_adhoc_challenges`, `get_inprogress_virtual_challenges`

</details>

<details>
<summary><strong>Dispositivos y equipo (6)</strong></summary>

`get_devices`, `get_device_last_used`, `get_primary_training_device`, `get_device_settings`, `get_gear`, `get_gear_stats`

</details>

<details>
<summary><strong>Catálogo de ejercicios de fuerza (4)</strong></summary>

| Herramienta | Descripción |
|---|---|
| `search_strength_exercises(query, limit=10, category=None)` | Busca ejercicios en español o inglés |
| `list_strength_categories()` | Las 39 categorías con cantidad de ejercicios |
| `list_strength_muscles()` | Los 17 grupos musculares con cantidad |
| `get_strength_exercises_by_muscle(muscle, primary_only=True, limit=20)` | Ejercicios por grupo muscular |

**Ejemplos de búsqueda:**

| Query | Resultado |
|---|---|
| `"press banca"` | BENCH_PRESS / BARBELL_BENCH_PRESS, DUMBBELL_BENCH_PRESS |
| `"dominadas lastradas"` | PULL_UP / WEIGHTED_PULL_UP, WEIGHTED_CHIN_UP |
| `"sentadilla con barra"` | SQUAT / BARBELL_BACK_SQUAT, BARBELL_BOX_SQUAT |
| `"peso muerto rumano"` | DEADLIFT / ROMANIAN_DEADLIFT |
| `"plancha lateral"` | PLANK / SIDE_PLANK, ROLLING_SIDE_PLANK |

</details>

## Catálogo de ejercicios — por qué existe

Garmin tiene 1.494 ejercicios de fuerza. El JSON completo pesa ~565 KB (≈ 140.000 tokens), lo que haría cada conversación de planificación de fuerza extremadamente costosa en tokens.

**Solución:** el catálogo vive en disco en formato compacto (370 KB) y se consulta localmente con 4 herramientas livianas que devuelven solo lo necesario (~300-1.000 tokens por búsqueda).

| Operación | Tokens estimados |
|---|---|
| Cargar catálogo completo | ~140.000 |
| `search_strength_exercises` (limit=10) | ~300-500 |
| `list_strength_categories` | ~600 |
| `get_strength_exercises_by_muscle` (limit=20) | ~700-1.000 |
| **Sesión típica de fuerza (6-8 ejercicios)** | **~3.000-4.000** |

**Ahorro: ~97% de reducción en tokens** por sesión de planificación.

### Actualizar el catálogo

Si Garmin añade ejercicios nuevos, descarga el JSON crudo y regenera el catálogo:

```bash
python build_catalog.py /ruta/al/nuevo/all-workout-list.json
```

## Convenciones importantes para entrenamientos de fuerza

### Categoría vs exercise_name

Garmin requiere **ambos** campos:
- `category` = familia del movimiento (`SQUAT`, `DEADLIFT`, `BENCH_PRESS`, `PULL_UP`...)
- `exercise_name` = variante específica (`BARBELL_BACK_SQUAT`, `ROMANIAN_DEADLIFT`...)

Usa siempre `search_strength_exercises` para obtener los valores exactos — adivinar nombres provoca que el ejercicio se guarde sin vincularse al historial, sin gif animado y sin estadísticas musculares.

### isBodyWeight y variantes con peso

Muchos ejercicios vienen en pares:
- `PULL_UP / PULL_UP` (peso corporal) ↔ `PULL_UP / WEIGHTED_PULL_UP` (con lastre)

Regla: si vas a registrar `weight_kg`, usa la variante `WEIGHTED_*`, `BARBELL_*` o `DUMBBELL_*`.

### Grupos musculares disponibles

```
ABDUCTORS, ABS, ADDUCTORS, BICEPS, CALVES, CHEST, FOREARM,
GLUTES, HAMSTRINGS, HIPS, LATS, LOWER_BACK, OBLIQUES,
QUADS, SHOULDERS, TRAPS, TRICEPS
```

## Seguridad

- Las credenciales se pasan como variables de entorno, nunca se escriben en código.
- Los tokens de sesión se guardan localmente en `~/.garmin-mcp-python/garmin_tokens.json`.
- Este proyecto es de uso personal. No expongas el servidor MCP en una red pública sin autenticación adicional.

## Dependencias

```
garminconnect>=0.2.38   # Librería no oficial para Garmin Connect (cyberjunky)
mcp>=1.0.0              # Model Context Protocol SDK
```

## Contribuir

Pull requests bienvenidos. Áreas de mejora posibles:
- Más aliases en español en `strength_catalog.py` (`_ALIASES_ES`)
- Soporte para más tipos de actividad en `add_workout`
- Integración con más endpoints de la API de Garmin

## Licencia

MIT
