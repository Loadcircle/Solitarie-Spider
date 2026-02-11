# 📋 Backlog de Tareas – Game Board

## 🎯 UX / UI – Prioridad Alta

### 1. Aumentar tamaño de fuente en el Board (Header)
**Pantalla:** `game_board_screen`

- Incrementar el tamaño de fuente del header:
  - Tiempo
  - Puntuación
  - Movimientos / contadores visibles
- Asegurar buena legibilidad en:
  - Pantallas pequeñas
  - Tablets
- Mantener jerarquía visual clara entre valores principales y secundarios.

**Criterio de aceptación:**
- El tiempo y la puntuación deben leerse claramente sin esfuerzo.
- No debe romper el layout ni generar overflow.

---

### 2. Aumentar espacio horizontal del mazo de reparto
**Zona:** Stack / mazo donde se reparten las cartas

- Incrementar el espacio horizontal entre cartas del mazo.
- Mejorar la percepción visual de “pila” y distribución.
- Evitar que las cartas se vean demasiado comprimidas.

**Criterio de aceptación:**
- Las cartas se distinguen claramente.
- No se superponen de forma confusa.

---

### 3. Racha en Rankings – Solo contar victorias
**Sección:** Rankings / Estadísticas

- La **racha** debe incrementarse **solo con victorias**.
- No contar:
  - Partidas abandonadas
  - Derrotas
- Ajustar cualquier otro valor relacionado que dependa de la racha.

**Criterio de aceptación:**
- Perder una partida rompe la racha.
- Ganar incrementa correctamente la racha.

---

### 4. Eliminar opción de desactivar animaciones
**Sección:** Settings

- Eliminar completamente la opción de “Animaciones ON/OFF”.
- Las animaciones deben estar **siempre activas**.
- Ajustar el código para que no dependa de este flag.

**Criterio de aceptación:**
- No existe opción visible ni lógica para desactivar animaciones.
- El juego siempre usa animaciones.

---

### 5. Persistencia del idioma (Bug crítico)
**Problema actual:**
- El app pregunta el idioma cada vez que se abre.

**Solución esperada:**
- Preguntar el idioma **solo la primera vez**.
- Guardar la preferencia de idioma localmente (persistente en el dispositivo).
- Si el usuario cambia el idioma manualmente desde settings:
  - Actualizar el valor persistido.
  - Aplicarlo inmediatamente.

**Criterio de aceptación:**
- El idioma no se vuelve a preguntar al reiniciar el app.
- El idioma seleccionado se mantiene siempre.

---

## 🎨 UI / Diseño – Prioridad Media

### 6. Diseño por defecto del tablero y cartas
**Assets por defecto:**
- Cartas: `card_1.png` (`cbImage1`)
- Fondo del tablero: `background_n1.png` (`bgImage1`)

**Cambios requeridos:**
- Establecer estos assets como **diseño por defecto**.
- Ajustar el orden en la tienda:
  - Estos deben aparecer como **primera opción**.
  - Marcados como seleccionados por defecto.

**Criterio de aceptación:**
- Al instalar el app, ese diseño está activo.
- En la tienda aparecen primero.

---

### 7. Tamaño de carta en stacks completados
**Contexto:**
- Al recoger una stack, se muestra una carta arriba indicando stacks completados.

**Cambio:**
- La carta mostrada debe tener **el mismo tamaño** que las cartas del tablero.
---

## 🧪 Diseño (Pendiente / Iteración futura)

> Estas tareas **NO son bloqueantes** y quedan para una fase posterior.

### 8. Aumentar tamaño del número en las cartas
- Incrementar tamaño del número de la carta.
- Ajustar layout:
  - Número grande alineado a la izquierda.
  - Icono del tipo de carta alineado a la derecha.

---

### 9. Evaluar mover stack recogido a la parte inferior
- Analizar si visualmente funciona mejor:
  - Stacks completados abajo en lugar de arriba.

---
