import 'package:flutter/material.dart';

import '../model/developer.dart';



class DevelopersPage extends StatelessWidget {
  final List<Developer> developers = [
    Developer(name: 'Davison Luis Soares Lopes', group: 'Coordenador', image: 'assets/davison.jpg'),
    Developer(name: 'Maria', group: 'Professor', image: 'assets/aleh.jpg'),
    Developer(name: 'Alerhandro De Ol. Gomes', group: 'Aluno', image: 'assets/aleh.jpg'),
    Developer(name: 'Pedro Henrique De Ol. Porfirio', group: 'Aluno', image: 'assets/pedro.png'),
    Developer(name: 'Pedro Henrique De Ol. Porfirio', group: 'Aluno', image: 'assets/pedro.png'),
    Developer(name: 'yara maryrlla f. de oliveira', group: 'Aluno', image: 'assets/pedro.png'),
    Developer(name: 'Pedro Henrique De Ol. Porfirio', group: 'Aluno', image: 'assets/pedro.png'),
    Developer(name: 'Pedro Henrique De Ol. Porfirio', group: 'Aluno', image: 'assets/pedro.png'),
    Developer(name: 'Pedro Henrique De Ol. Porfirio', group: 'Aluno', image: 'assets/pedro.png'),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desenvolvedores'),
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
