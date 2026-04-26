import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class RecipeFormDialog extends StatefulWidget {
  final Map<String, dynamic>? recipe;

  const RecipeFormDialog({super.key, this.recipe});

  bool get isEdit => recipe != null;

  @override
  State<RecipeFormDialog> createState() => _RecipeFormDialogState();
}

class _RecipeFormDialogState extends State<RecipeFormDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  final List<TextEditingController> _ingredientNameControllers = [];
  final List<TextEditingController> _ingredientQuantityControllers = [];
  final List<TextEditingController> _ingredientUnitControllers = [];
  final List<TextEditingController> _stepControllers = [];

  final List<String> _categories = [
    'Makanan Utama',
    'Nusantara',
    'Western',
    'Dessert',
    'Minuman',
  ];

  final List<String> _selectedCategories = [];
  String _status = 'Draft';

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.recipe?['title'] as String? ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.recipe?['description'] as String? ?? '',
    );

    if (widget.recipe != null) {
      _status = widget.recipe?['status'] as String? ?? 'Draft';

      _selectedCategories.addAll(
        List<String>.from(widget.recipe?['categories'] as List? ?? []),
      );

      final ingredients = List<Map<String, dynamic>>.from(
        widget.recipe?['ingredients'] ?? [],
      );
      final steps = List<String>.from(widget.recipe?['steps'] ?? []);

      if (ingredients.isEmpty) {
        _addIngredient();
      } else {
        for (final ingredient in ingredients) {
          _addIngredient(
            name: ingredient['name']?.toString() ?? '',
            quantity: ingredient['quantity']?.toString() ?? '',
            unit: ingredient['unit']?.toString() ?? '',
          );
        }
      }

      if (steps.isEmpty) {
        _addStep();
      } else {
        for (final step in steps) {
          _addStep(value: step);
        }
      }
    } else {
      _addIngredient();
      _addStep();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    for (final controller in _ingredientNameControllers) {
      controller.dispose();
    }
    for (final controller in _ingredientQuantityControllers) {
      controller.dispose();
    }
    for (final controller in _ingredientUnitControllers) {
      controller.dispose();
    }
    for (final controller in _stepControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _addIngredient({
    String name = '',
    String quantity = '',
    String unit = '',
  }) {
    setState(() {
      _ingredientNameControllers.add(TextEditingController(text: name));
      _ingredientQuantityControllers.add(TextEditingController(text: quantity));
      _ingredientUnitControllers.add(TextEditingController(text: unit));
    });
  }

  void _removeIngredient(int index) {
    if (_ingredientNameControllers.length == 1) return;

    setState(() {
      _ingredientNameControllers[index].dispose();
      _ingredientQuantityControllers[index].dispose();
      _ingredientUnitControllers[index].dispose();

      _ingredientNameControllers.removeAt(index);
      _ingredientQuantityControllers.removeAt(index);
      _ingredientUnitControllers.removeAt(index);
    });
  }

  void _addStep({String value = ''}) {
    setState(() {
      _stepControllers.add(TextEditingController(text: value));
    });
  }

  void _removeStep(int index) {
    if (_stepControllers.length == 1) return;

    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty || _selectedCategories.isEmpty) {
      return;
    }

    final ingredients = <Map<String, dynamic>>[];

    for (int index = 0; index < _ingredientNameControllers.length; index++) {
      final name = _ingredientNameControllers[index].text.trim();
      final quantity = _ingredientQuantityControllers[index].text.trim();
      final unit = _ingredientUnitControllers[index].text.trim();

      if (name.isEmpty) continue;

      ingredients.add({'name': name, 'quantity': quantity, 'unit': unit});
    }

    final steps = _stepControllers
        .map((controller) => controller.text.trim())
        .where((step) => step.isNotEmpty)
        .toList();

    final result = {
      'title': title,
      'description': description,
      'categories': List<String>.from(_selectedCategories),
      'ingredients': ingredients,
      'steps': steps,
      'status': _status,
      'rating': widget.recipe?['rating'] ?? '—',
      'createdAt': widget.recipe?['createdAt'] ?? '2026-04-12',
    };

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.isEdit ? 'Edit Resep' : 'Tambah Resep Baru',
                      style: AppTextStyles.h2,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceL),
                Text('Judul Resep *', style: AppTextStyles.smallBold),
                const SizedBox(height: AppSizes.spaceS),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Nasi Goreng Spesial',
                  ),
                ),
                const SizedBox(height: AppSizes.spaceL),
                Text('Deskripsi *', style: AppTextStyles.smallBold),
                const SizedBox(height: AppSizes.spaceS),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Jelaskan tentang resep ini...',
                  ),
                ),
                const SizedBox(height: AppSizes.spaceL),
                Text('Kategori *', style: AppTextStyles.smallBold),
                const SizedBox(height: AppSizes.spaceS),
                Wrap(
                  spacing: AppSizes.spaceS,
                  runSpacing: AppSizes.spaceS,
                  children: _categories.map((category) {
                    final selected = _selectedCategories.contains(category);

                    return ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.inputBg,
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: selected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => _toggleCategory(category),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSizes.spaceL),
                Text('Bahan-bahan *', style: AppTextStyles.smallBold),
                const SizedBox(height: AppSizes.spaceS),
                Column(
                  children: List.generate(_ingredientNameControllers.length, (
                      index,
                      ) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ingredientNameControllers[index],
                              decoration: const InputDecoration(
                                hintText: 'Nama bahan',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceS),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _ingredientQuantityControllers[index],
                              decoration: const InputDecoration(
                                hintText: 'Jumlah',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceS),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _ingredientUnitControllers[index],
                              decoration: const InputDecoration(
                                hintText: 'Satuan',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeIngredient(index),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                OutlinedButton.icon(
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Bahan'),
                ),
                const SizedBox(height: AppSizes.spaceL),
                Text('Langkah Memasak *', style: AppTextStyles.smallBold),
                const SizedBox(height: AppSizes.spaceS),
                Column(
                  children: List.generate(_stepControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                      child: Row(
                        children: [
                          Text('${index + 1}'),
                          const SizedBox(width: AppSizes.spaceM),
                          Expanded(
                            child: TextField(
                              controller: _stepControllers[index],
                              decoration: InputDecoration(
                                hintText: 'Langkah ${index + 1}',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeStep(index),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                OutlinedButton.icon(
                  onPressed: _addStep,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Langkah'),
                ),
                const SizedBox(height: AppSizes.spaceL),
                Text('Gambar Utama *', style: AppTextStyles.smallBold),
                const SizedBox(height: AppSizes.spaceS),
                Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text('Upload gambar (JPG/PNG, maks 5MB)'),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceL),
                Text('Status', style: AppTextStyles.smallBold),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Draft',
                      groupValue: _status,
                      onChanged: (value) {
                        setState(() => _status = value ?? 'Draft');
                      },
                    ),
                    const Text('Draft'),
                    Radio<String>(
                      value: 'Published',
                      groupValue: _status,
                      onChanged: (value) {
                        setState(() => _status = value ?? 'Published');
                      },
                    ),
                    const Text('Published'),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceXL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        widget.isEdit ? 'Simpan Perubahan' : 'Tambah Resep',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
