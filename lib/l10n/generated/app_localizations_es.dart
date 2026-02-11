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
  String get shop => 'Tienda';

  @override
  String get backgrounds => 'Fondos';

  @override
  String get cardBacks => 'Dorsos';

  @override
  String get bgDefaultGreen => 'Verde Clásico';

  @override
  String get bgDarkEmerald => 'Esmeralda Oscuro';

  @override
  String get bgImage1 => 'Textura Fieltro';

  @override
  String get bgImage2 => 'Fieltro Ornamentado';

  @override
  String get cbDefaultBlue => 'Azul Clásico';

  @override
  String get cbDarkRed => 'Rojo Oscuro';

  @override
  String get cbImage1 => 'Rojo Entrecruzado';

  @override
  String get cbImage2 => 'Pica Real';

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
}
