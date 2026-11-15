import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class GameSelectPage extends StatefulWidget {
  const GameSelectPage({super.key});

  @override
  State<GameSelectPage> createState() => _ArcadeMenuScreenState();
}

class _ArcadeMenuScreenState extends State<GameSelectPage> {
  late FixedExtentScrollController _scrollController;
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: _selectedIndex);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _moverCarrossel(1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _moverCarrossel(-1);
      }
    }
  }

  void _moverCarrossel(int direcao) {
    final int proximoIndice = _selectedIndex + direcao;
    if (proximoIndice >= 0 && proximoIndice < _games.length) {
      _scrollController.animateToItem(
        proximoIndice,
        duration: const Duration(milliseconds: 250), // Velocidade do giro
        curve: Curves.easeOutQuad,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 180, // Altura de cada capa de jogo
                    diameterRatio: 1.8, // Quão curvado é o cilindro
                    perspective: 0.004, // Profundidade 3D
                    useMagnifier: true,
                    magnification: 1.1, // Aumenta levemente o item central
                    physics: const FixedExtentScrollPhysics(), // Trava sempre num item
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _games.length,
                      builder: (context, index) {
                        return _buildGameCard(index);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // LADO DIREITO: Preview, Mascote e Infos (Mockup)
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SELECIONADO: ${_games[_selectedIndex]}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Aqui entra a tela CRT com vídeo\ne a mascote do Calestro Bar",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(int index) {
    final bool isSelected = index == _selectedIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        vertical: isSelected ? 5.0 : 15.0,
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // Borda brilhante se estiver selecionado
          color: isSelected ? Colors.amberAccent : Colors.white12,
          width: isSelected ? 3.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                // Simula o efeito de "fogo/raios" com brilho
                BoxShadow(
                  color: Colors.orangeAccent.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]
            : [],
      ),
      child: Center(
        child: Text(
          _games[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSelected ? 24 : 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.white54,
          ),
        ),
      ),
    );
  }
}