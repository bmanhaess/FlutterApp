import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<int> numeros;

  setUp(() {
    numeros = [1, 2, 3];
  });

  test('Adicionar elemento', () {
    numeros.add(4);
    expect(numeros, [1, 2, 3, 4]);
  });

  test('Adicionar outra lista', () {
    numeros.addAll([4, 5]);
    expect(numeros, [1, 2, 3, 4, 5]);
  });

  test('Adicionar na posição', () {
    numeros.insert(0, 0);
    expect(numeros, [0, 1, 2, 3]);
  });

  test('Remover elemento', () {
    numeros.remove(2);
    expect(numeros, [1, 3]);
  });

  test('Remover na posição', () {
    numeros.removeAt(0);
    expect(numeros, [2, 3]);
  });

  test('Testar tamanho', () {
    expect(numeros.length, 3);
  });

  test('Testar vazio e não vazio', () {
    expect(numeros.isEmpty, isFalse);
    expect(numeros.isNotEmpty, isTrue);
    List<int> vazia = [];
    expect(vazia.isEmpty, isTrue);
    expect(vazia.isNotEmpty, isFalse);
  });

  test('Testar ordenação', () {
    List<int> desordenada = [3, 1, 2];
    desordenada.sort();
    expect(desordenada, [1, 2, 3]);
  });

  test('Testar percorrer lista', () {
    int soma = numeros.reduce((a, b) => a + b);
    expect(soma, 6);

    List<int> dobrada = numeros.map((n) => n * 2).toList();
    expect(dobrada, [2, 4, 6]);

    List<int> pares = numeros.where((n) => n % 2 == 0).toList();
    expect(pares, [2]);
  });
}
