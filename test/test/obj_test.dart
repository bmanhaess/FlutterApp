import 'package:flutter_test/flutter_test.dart';

abstract class Pessoa {
  late int _id;
  String nome;

  Pessoa(this.nome);

  int get id => _id;

  set id(int id) {
    if (id > 0) {
      _id = id;
    } else {
      throw ArgumentError('Identificador deve ser não negativo.');
    }
  }
}

mixin Ano {
  late int _ano;

  int get ano => _ano;

  set ano(int ano) {
    if (ano > 0) {
      _ano = ano;
    } else {
      throw ArgumentError('Ano deve ser não negativo.');
    }
  }
}

class Professor extends Pessoa {
  Professor(super.nome);
}

class Aluno extends Pessoa with Ano {
  Aluno(super.nome, int ano) {
    this.ano = ano;
  }
}

class Disciplina {
  String nome;
  Disciplina(this.nome);
}

class Turma with Ano {
  Disciplina disciplina;
  Professor professor;
  final List<Aluno> _alunos = [];

  Turma(this.disciplina, this.professor, int ano) {
    this.ano = ano;
  }

  void matricular(Aluno aluno) {
    if (aluno.ano == ano) {
      _alunos.add(aluno);
    } else {
      throw ArgumentError('Ano deve ser mesmo.');
    }
  }

  List<Aluno> get alunos => _alunos;
}

class Historico extends Turma {
  Map<Aluno, List<double>> notas = {};

  Historico(super.disciplina, super.professor, super.ano);

  @override
  void matricular(Aluno aluno) {
    super.matricular(aluno);
    notas[aluno] = [];
  }

  void adicionarNota(Aluno aluno, double nota) {
    if (notas.containsKey(aluno)) {
      notas[aluno]!.add(nota);
    } else {
      throw ArgumentError('Aluno não matriculado.');
    }
  }

  double media(Aluno aluno) {
    if (!notas.containsKey(aluno) || notas[aluno]!.isEmpty) {
      return 0.0;
    }
    double soma = notas[aluno]!.reduce((a, b) => a + b);
    return soma / notas[aluno]!.length;
  }

  bool isAprovado(Aluno aluno) {
    return media(aluno) >= 6.0;
  }
}

void main() {
  test('Testar matrícula de alunos e professor', () {
    // Setup
    var disciplina1 = Disciplina('Flutter');
    var professor1 = Professor('Prof. Mário');
    professor1.id = 1;

    var historico1 = Historico(disciplina1, professor1, 2023);
    expect(historico1.professor.nome, 'Prof. Mário');

    var aluno1 = Aluno('Maria', 2023);
    aluno1.id = 1;

    // Action
    historico1.matricular(aluno1);

    // Assert
    expect(historico1.alunos.contains(aluno1), isTrue);
    expect(historico1.media(aluno1), 0.0);
  });

  test('Testar erros de matrícula', () {
    // Setup
    var disciplina1 = Disciplina('Flutter');
    var professor1 = Professor('Prof. Mário');
    professor1.id = 1;
    var historico1 = Historico(disciplina1, professor1, 2023);

    var aluno2 = Aluno('Paula', 2022); // Different year

    // Action & Assert
    // Test invalid student ID
    try {
      aluno2.id = 0;
    } catch (error) {
      expect(error, isA<ArgumentError>());
    }
    // Test enrollment with mismatching year
    try {
      historico1.matricular(aluno2);
    } catch (error) {
      expect(error, isA<ArgumentError>());
    }
  });

  test('Testar cálculo de média', () {
    // Setup
    var disciplina1 = Disciplina('Flutter');
    var professor1 = Professor('Prof. Mário');
    professor1.id = 1;
    var historico1 = Historico(disciplina1, professor1, 2023);
    var aluno1 = Aluno('Maria', 2023);
    aluno1.id = 1;
    historico1.matricular(aluno1);

    // Action
    historico1.adicionarNota(aluno1, 8.0);
    historico1.adicionarNota(aluno1, 9.0);

    // Assert
    expect(historico1.media(aluno1), 8.5);
  });

  test('Testar aprovação do aluno', () {
    // Setup
    var disciplina1 = Disciplina('Flutter');
    var professor1 = Professor('Prof. Mário');
    var historico1 = Historico(disciplina1, professor1, 2023);
    var aluno1 = Aluno('Maria', 2023);
    historico1.matricular(aluno1);

    // Action
    historico1.adicionarNota(aluno1, 5.0);
    expect(historico1.isAprovado(aluno1), isFalse);

    historico1.adicionarNota(aluno1, 7.0);
    expect(historico1.isAprovado(aluno1), isTrue);
  });
}
