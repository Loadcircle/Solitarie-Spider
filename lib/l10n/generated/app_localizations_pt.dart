// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Paciência Spider';

  @override
  String get home => 'Início';

  @override
  String get newGame => 'Novo Jogo';

  @override
  String get continueGame => 'Continuar';

  @override
  String get history => 'Histórico';

  @override
  String get ranking => 'Classificação';

  @override
  String get settings => 'Configurações';

  @override
  String get score => 'Pontuação';

  @override
  String get moves => 'Movimentos';

  @override
  String get time => 'Tempo';

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get oneSuit => '1 Naipe';

  @override
  String get twoSuits => '2 Naipes';

  @override
  String get fourSuits => '4 Naipes';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Médio';

  @override
  String get hard => 'Difícil';

  @override
  String get start => 'Iniciar';

  @override
  String get youWin => 'Você Venceu!';

  @override
  String get congratulations => 'Parabéns! Você completou o jogo.';

  @override
  String finalScore(int score) {
    return 'Pontuação Final: $score';
  }

  @override
  String totalMoves(int moves) {
    return 'Total de Movimentos: $moves';
  }

  @override
  String totalTime(String time) {
    return 'Tempo: $time';
  }

  @override
  String get playAgain => 'Jogar Novamente';

  @override
  String get backToHome => 'Voltar ao Início';

  @override
  String get noHistory => 'Nenhum jogo jogado ainda.';

  @override
  String get date => 'Data';

  @override
  String get result => 'Resultado';

  @override
  String get won => 'Vitória';

  @override
  String get lost => 'Derrota';

  @override
  String get confirmNewGame => 'Confirmar Novo Jogo';

  @override
  String get confirmNewGameMessage =>
      'Tem certeza de que deseja iniciar um novo jogo? O progresso atual será perdido.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get sound => 'Som';

  @override
  String get animations => 'Animações';

  @override
  String get defaultDifficulty => 'Dificuldade Padrão';

  @override
  String get confirmBeforeNewGame => 'Confirmar antes de novo jogo';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get stockEmpty => 'O baralho está vazio';

  @override
  String get allColumnsMustHaveCards =>
      'Todas as colunas devem ter pelo menos uma carta para distribuir.';

  @override
  String get sequences => 'Sequências';

  @override
  String get stock => 'Baralho';

  @override
  String get deals => 'distribuições';

  @override
  String get gamePaused => 'Jogo Pausado';

  @override
  String get allowDealWithEmptyColumns =>
      'Permitir distribuição com colunas vazias';

  @override
  String get allowDealWithEmptyColumnsDescription =>
      'Permitir distribuir mesmo quando há colunas vazias';

  @override
  String get highlightMovable => 'Destacar cartas móveis';

  @override
  String get highlightMovableDescription =>
      'Atenuar cartas que não podem ser movidas';

  @override
  String get tapToAutoMove => 'Tocar para mover automaticamente';

  @override
  String get tapToAutoMoveDescription =>
      'Tocar uma carta para movê-la para a melhor coluna';

  @override
  String get noValidMove => 'Nenhum movimento válido disponível';

  @override
  String get youLose => 'Fim de Jogo';

  @override
  String get noMovesLeft =>
      'Não há mais movimentos disponíveis. Mais sorte da próxima vez!';

  @override
  String get music => 'Música';

  @override
  String get portuguese => 'Português';

  @override
  String get chooseLanguage => 'Escolher Idioma';

  @override
  String get chooseLanguageMessage => 'Selecione seu idioma preferido';

  @override
  String get shop => 'Loja';

  @override
  String get backgrounds => 'Fundos';

  @override
  String get cardBacks => 'Dorsos';

  @override
  String get bgDefaultGreen => 'Verde Clássico';

  @override
  String get bgDarkEmerald => 'Esmeralda Escuro';

  @override
  String get bgImage1 => 'Textura Feltro';

  @override
  String get bgImage2 => 'Feltro Ornamentado';

  @override
  String get cbDefaultBlue => 'Azul Clássico';

  @override
  String get cbDarkRed => 'Vermelho Escuro';

  @override
  String get cbImage1 => 'Vermelho Cruzado';

  @override
  String get cbImage2 => 'Espada Real';

  @override
  String get selected => 'Selecionado';

  @override
  String get fastestTime => 'Tempo Mais Rápido';

  @override
  String get averageTime => 'Tempo Médio';

  @override
  String get longestWinStreak => 'Maior Sequência de Vitórias';

  @override
  String get bestScore => 'Melhor Pontuação';

  @override
  String get noStats => 'Sem estatísticas para este modo.';

  @override
  String get noGamesOnDay => 'Nenhum jogo neste dia.';
}
