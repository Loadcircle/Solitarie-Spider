# 📄 Solitario Spider – UI / Estética  
**Documento técnico (v1.0)**

## Objetivo
Definir la estética visual base del app *Solitario Spider* asegurando:
- Consistencia visual
- Legibilidad
- Estilo clásico–moderno
- Facilidad de implementación

---

## 1. Paleta de colores (definitiva)

### Colores base
- Primary Background (Table): `#1E5E2A`
- Secondary Background: `#174D22`
- Surface / Card / Modal: `#1F2E22`
- Primary Button: `#2F7D3A`
- Primary Button Pressed: `#276A32`

### Texto
- Primary Text: `#EAF3EC`
- Secondary Text: `rgba(234,243,236,0.7)`
- Disabled Text: `rgba(234,243,236,0.4)`

### Palos (símbolos)
- Spades / Clubs: `#2A2F2C`
- Hearts / Diamonds: `#C62828`

---

## 2. Fondo general del app

- Fondo principal con **gradiente vertical**:
  - Top: `#1E5E2A`
  - Bottom: `#174D22`

- No usar:
  - Texturas
  - Patrones
  - Imágenes

---

## 3. Tipografía

### Fuente
- **Inter**

### Pesos utilizados
- Titles: SemiBold
- Buttons: Medium
- Body text: Regular
- Numbers / HUD: Medium

### Line-height
- Titles: `1.2`
- Body: `1.4`

---

## 4. Botones

### Dimensiones
- Border radius: `14`
- Altura mínima: `48`
- Padding horizontal: `16–20`

### Estilo
- Fondo sólido (Primary Button)
- Texto: `#EAF3EC`
- Iconos monocromáticos

### Variantes
- Primary Button: fondo verde
- Secondary Button: fondo Surface (`#1F2E22`)
- Text Button: texto sin fondo

---

## 5. Superficies (cards, modales, paneles)

### Estilo
- Background: `#1F2E22`
- Border radius: `16–18`

- Sin bordes visibles
- Separación mediante color (no outline)

---

## 6. HUD de la partida

### Contenedor
- Background: `rgba(0,0,0,0.15)`

### Elementos
- Score
- Moves
- Time
- Sequences

- Tipografía consistente
- Sin iconos innecesarios

---

## 7. Menú principal

### Estructura
- Título centrado
- Palos debajo del título
- Botones en columna

### Reglas
- Mismo ancho para todos los botones
- Iconos alineados a la izquierda
- Texto centrado verticalmente

---

## 8. Pantalla “Nueva Partida / Dificultad”

### Opciones
- Cada dificultad como superficie independiente
- Estado seleccionado claramente visible

### Estado seleccionado
- Background: Primary Button
- Icon opacity: 100%
- Text opacity: 100%

### Estado no seleccionado
- Background: Surface
- Icon opacity: 40–50%
- Text opacity: 70%

---

## 9. Modal de confirmación

### Contenedor
- Background: `#1F2E22`
- Border radius: `18`
- Padding interno amplio

### Botones
- Cancel: Text Button
- Confirm: Primary Button

---

## 10. Branding temporal

- Texto: **Solitario Spider**
- Tipografía: Inter SemiBold
- Palos debajo del título
- Sin logo gráfico por ahora

---

# 📦 Recursos necesarios para mejorar el app

## 1. Iconografía (SVG / Vector)

### Necesarios
- Play
- Plus (Nueva partida)
- History
- Ranking
- Settings
- Back arrow
- Confirm / Cancel

**Estilo**
- Monocromáticos
- Stroke consistente
- Sin sombras ni degradados

---

## 2. Palos (símbolos) en vector

- ♠ ♥ ♦ ♣ en SVG
- Versiones:
  - Activo
  - Inactivo (menor opacidad)

---

## 3. Fondos de superficie

- Color sólido (no imagen)
- Definidos como tokens reutilizables

---

## 4. Estados de botones

- Normal
- Pressed
- Disabled

*(visual, sin animaciones)*

---


## 6. Futuro (no ahora)

- Dorso de cartas
- Ilustraciones sutiles
- Temas alternativos
