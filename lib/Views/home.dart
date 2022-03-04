import 'package:flutter/material.dart';
import 'package:pdcase_ideia_extra/Views/Especialidades/especialidadesList.dart';
import 'package:pdcase_ideia_extra/Views/FichasPacientes/fichasPacientesList.dart';
import 'package:pdcase_ideia_extra/Views/PlanosDeSaude/planosDeSaudeList.dart';
import 'package:pdcase_ideia_extra/Views/usuarioForm.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indexDaTelaSelecionada = 1;

  List<BottomNavigationBarItem> retornaItensNavBar() {
    return [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.medical_services_outlined,
            color: Colors.black,
          ),
          label: "Especialidades"),
      BottomNavigationBarItem(
          icon: Icon(Icons.file_copy_outlined, color: Colors.black),
          label: "Fichas de Pacientes"),
      BottomNavigationBarItem(
          icon: Icon(Icons.business_outlined, color: Colors.black),
          label: "Planos de Saúde"),
      BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, color: Colors.black),
          label: "Usuário"),
    ];
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        mudaTela(index);
      },
      children: <Widget>[
        EspecialidadesList(),
        FichaPacientesList(),
        PlanosDeSaudeList(),
        UsuarioForm()
      ],
    );
  }

  void mudaTela(int index) {
    setState(() {
      indexDaTelaSelecionada = index;
    });
  }

  void telaClicada(int index) {
    setState(() {
      indexDaTelaSelecionada = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text("Gerenciador de Cadastros"),
        actions: [
          Padding(
            padding:
                EdgeInsets.only(top: 15.0, bottom: 8.0, left: 8.0, right: 15),
            child: Row(
              children: [
                Text(
                  "PD | ",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  "Case",
                  style: TextStyle(color: Colors.yellow, fontSize: 15),
                ),
              ],
            ),
          )
        ],
      ),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        backgroundColor: Colors.black,
        items: retornaItensNavBar(),
        currentIndex: indexDaTelaSelecionada,
        onTap: (index) {
          telaClicada(index);
        },
      ),
    );
  }
}
