// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Solitario Spider';

  @override
  String get home => 'Inicio';

  @override
  String get newGame => 'Nueva Partida';

  @override
  String get continueGame => 'Continuar';

  @override
  String get history => 'Historial';

  @override
  String get ranking => 'Clasificación';

  @override
  String get settings => 'Ajustes';

  @override
  String get score => 'Puntuación';

  @override
  String get moves => 'Movimientos';

  @override
  String get time => 'Tiempo';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get oneSuit => '1 Palo';

  @override
  String get twoSuits => '2 Palos';

  @override
  String get fourSuits => '4 Palos';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difícil';

  @override
  String get start => 'Iniciar';

  @override
  String get youWin => '¡Ganaste!';

  @override
  String get congratulations => '¡Felicidades! Completaste el juego.';

  @override
  String finalScore(int score) {
    return 'Puntuación Final: $score';
  }

  @override
  String totalMoves(int moves) {
    return 'Movimientos Totales: $moves';
  }

  @override
  String totalTime(String time) {
    return 'Tiempo: $time';
  }

  @override
  String get playAgain => 'Jugar de Nuevo';

  @override
  String get backToHome => 'Volver al Inicio';

  @override
  String get noHistory => 'No hay partidas jugadas aún.';

  @override
  String get date => 'Fecha';

  @override
  String get result => 'Resultado';

  @override
  String get won => 'Ganada';

  @override
  String get lost => 'Perdida';

  @override
  String get confirmNewGame => 'Confirmar Nueva Partida';

  @override
  String get confirmNewGameMessage =>
      '¿Estás seguro de que quieres iniciar una nueva partida? El progreso actual se perderá.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get sound => 'Sonido';

  @override
  String get defaultDifficulty => 'Dificultad Predeterminada';

  @override
  String get confirmBeforeNewGame => 'Confirmar antes de nueva partida';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get stockEmpty => 'El mazo está vacío';

  @override
  String get allColumnsMustHaveCards =>
      'Todas las columnas deben tener al menos una carta para repartir.';

  @override
  String get sequences => 'Secuencias';

  @override
  String get stock => 'Mazo';

  @override
  String get deals => 'repartos';

  @override
  String get gamePaused => 'Juego Pausado';

  @override
  String get allowDealWithEmptyColumns =>
      'Permitir reparto con columnas vacías';

  @override
  String get allowDealWithEmptyColumnsDescription =>
      'Permitir repartir incluso cuando hay columnas vacías';

  @override
  String get highlightMovable => 'Resaltar cartas movibles';

  @override
  String get highlightMovableDescription =>
      'Atenuar cartas que no se pueden mover';

  @override
  String get tapToAutoMove => 'Tocar para mover automáticamente';

  @override
  String get tapToAutoMoveDescription =>
      'Tocar una carta para moverla a la mejor columna';

  @override
  String get noValidMove => 'No hay movimiento válido disponible';

  @override
  String get youLose => 'Fin del Juego';

  @override
  String get noMovesLeft =>
      'No quedan movimientos disponibles. ¡Mejor suerte la próxima vez!';

  @override
  String get music => 'Música';

  @override
  String get portuguese => 'Portugués';

  @override
  String get chooseLanguage => 'Elegir Idioma';

  @override
  String get chooseLanguageMessage => 'Selecciona tu idioma preferido';

  @override
  String get shop => 'Apariencia';

  @override
  String get backgrounds => 'Tableros';

  @override
  String get cardBacks => 'Dorsos';

  @override
  String get selected => 'Seleccionado';

  @override
  String get fastestTime => 'Tiempo Más Rápido';

  @override
  String get averageTime => 'Tiempo Promedio';

  @override
  String get longestWinStreak => 'Racha Más Larga';

  @override
  String get bestScore => 'Mejor Puntuación';

  @override
  String get noStats => 'Sin estadísticas para este modo.';

  @override
  String get noGamesOnDay => 'No hay partidas en este día.';

  @override
  String get level => 'Nivel';

  @override
  String xpEarned(int xp) {
    return '+$xp XP';
  }

  @override
  String get levelUp => '¡Subiste de nivel!';

  @override
  String unlocksAtLevel(int level) {
    return 'Se desbloquea en nivel $level';
  }

  @override
  String get maxLevel => 'Nivel máximo';

  @override
  String get newUnlocks => 'Nuevos desbloqueos!';

  @override
  String get newUnlocksMessage => 'Has desbloqueado nuevos items:';

  @override
  String get goToShop => 'Ir a Apariencia';

  @override
  String get close => 'Cerrar';

  @override
  String nextRewardAtLevel(int level) {
    return 'Próxima recompensa en nivel $level';
  }

  @override
  String get figures => 'Figuras';

  @override
  String get undo => 'Deshacer';

  @override
  String get undoEnabled => 'Botón deshacer';

  @override
  String get undoEnabledDescription =>
      'Mostrar botón para deshacer el último movimiento';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get streakReminder => 'Recordatorio diario';

  @override
  String get streakReminderDescription =>
      'Recordarme jugar si no lo he hecho hoy';

  @override
  String get rewardAlert => 'Alertas de recompensa';

  @override
  String get rewardAlertDescription =>
      'Notificar cuando esté cerca de desbloquear';

  @override
  String get streakReminderTitle => '¡No pierdas tu racha!';

  @override
  String get streakReminderBody => 'Juega una partida hoy y mantén tu progreso';

  @override
  String get rewardProximityTitle => '¡Ya casi!';

  @override
  String get rewardProximityBody =>
      'Te falta solo una victoria para desbloquear';

  @override
  String get winRate => 'Tasa de victoria';

  @override
  String playStreak(int days) {
    return 'Racha de $days días';
  }

  @override
  String get watchAdDoubleXp => '2× XP — Ver anuncio';

  @override
  String get watchAdSaveResult => 'Ver anuncio — No contar derrota';
}
