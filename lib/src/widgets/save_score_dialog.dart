import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class SaveScoreDialog extends StatefulWidget {
  const SaveScoreDialog({super.key, required this.score});

  final int score;

  @override
  State<SaveScoreDialog> createState() => _SaveScoreDialogState();
}

class _SaveScoreDialogState extends State<SaveScoreDialog> {
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveScore() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu nombre')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await SupabaseService.saveScore(
        playerName: name,
        score: widget.score,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Puntuación guardada exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error guardando puntuación: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _skipAndSaveAnonymous() async {
    setState(() => _isSaving = true);

    try {
      print('💾 Guardando puntuación anónima: ${widget.score}');
      await SupabaseService.saveScore(
        playerName: 'Jugador',
        score: widget.score,
      );
      print('✅ Puntuación guardada anónimamente');

      if (mounted) {
        Navigator.of(context).pop(false);
      }
    } catch (e) {
      print('❌ Error guardando anónimamente: $e');
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Guardar Puntuación',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Puntos: ${widget.score}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Tu Nombre',
              hintText: 'Ingresa tu nombre',
              border: OutlineInputBorder(),
            ),
            maxLength: 20,
            textCapitalization: TextCapitalization.words,
            enabled: !_isSaving,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : _skipAndSaveAnonymous,
          child: const Text('SALTAR'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveScore,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('GUARDAR'),
        ),
      ],
    );
  }
}
