import 'package:flutter/material.dart';

import '../model/developer.dart';



class DevelopersPage extends StatelessWidget {
  final List<Developer> developers = [
    Developer(name: 'Davison Luis Soares Lopes', group: 'Coordenador', image: 'assets/davison.jpg'),
    Developer(name: 'Tiago Bezerra', group: 'Professor', image: 'assets/tiago.png'),
    Developer(name: 'Elisama Cardoso Rosendo', group: 'Aluno', serie: "3° Série", image: 'assets/elisama.jpg'),
    Developer(name: 'Alerhandro De O. Gomes', group: 'Aluno', serie: "2° Série", image: 'assets/aleh.jpg'),
    Developer(name: 'José Marcos Silva de Jesus', group: 'Aluno', serie: "2° Série", image: 'assets/marcos.jpg'),
    Developer(name: 'Matheus Souza de Pontes ', group: 'Aluno', serie: "2° Série", image: 'assets/mateus.jpg'),
    Developer(name: 'Jonathas Gomes B. da silva', group: 'Aluno', serie: "2° Série", image: 'assets/jonata.jpg'),
    Developer(name: 'Pedro Henrique De O. Porfirio', group: 'Aluno',  serie: "1° Ano", image: 'assets/pedro.png'),
    Developer(name: 'yara maryrlla f. de oliveira', group: 'Aluno', serie: "1° Ano", image: 'assets/yara.jpg'),
    Developer(name: 'Maria Nayara S. do Nascimento', group: 'Aluno', serie: "1° Ano", image: 'assets/maria.jpg'),
    Developer(name: 'Leticia Silva dos Santos', group: 'Aluno', serie: "1° Ano", image: 'assets/leticia.jpg'),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text(
          'Desenvolvedores',
          style: TextStyle(color: Colors.white),
        ),

        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: developers.length,
        itemBuilder: (context, index) {
          final developer = developers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(developer.image),
            ),
            title: Text(developer.name),
            subtitle: Text(developer.group),
          );
        },
      ),
    );
  }
}
