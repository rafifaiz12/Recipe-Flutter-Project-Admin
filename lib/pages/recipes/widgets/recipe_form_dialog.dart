import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:siresep_admin/models/recipe_model.dart';
import 'package:siresep_admin/providers/recipe_provider.dart';

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
  late final TextEditingController _imageUrlController;
  late final TextEditingController _cookTimeController;

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
  String _difficulty = 'Easy';
  bool _isSubmitting = false;
  String _imageUrlPreview = '';

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.recipe?['title']?.toString() ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.recipe?['description']?.toString() ?? '',
    );

    _imageUrlController = TextEditingController(
      text: widget.recipe?['imageUrl']?.toString() ?? '',
    );

    _cookTimeController = TextEditingController(
      text: widget.recipe?['cookTimeMinutes']?.toString() ?? '',
    );

    _imageUrlPreview = _imageUrlController.text.trim();

    if (widget.recipe != null) {
      _status = widget.recipe?['status']?.toString() ?? 'Draft';
      _difficulty = widget.recipe?['difficulty']?.toString() ?? 'Easy';

      _selectedCategories.addAll(
        List<String>.from(widget.recipe?['categories'] as List? ?? []),
      );

      final rawIngredients = widget.recipe?['ingredients'];
      final ingredients = <Map<String, dynamic>>[];

      if (rawIngredients is List) {
        for (final item in rawIngredients) {
          if (item is Map) {
            ingredients.add(Map<String, dynamic>.from(item));
          } else {
            ingredients.add({
              'name': item.toString(),
              'quantity': '',
              'unit': '',
            });
          }
        }
      }

      final rawSteps = widget.recipe?['steps'];
      final steps = <String>[];

      if (rawSteps is List) {
        for (final item in rawSteps) {
          steps.add(item.toString());
        }
      }

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
    _imageUrlController.dispose();
    _cookTimeController.dispose();

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

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty || _selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul, deskripsi, dan kategori wajib diisi.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final ingredients = <RecipeIngredient>[];

      for (int index = 0; index < _ingredientNameControllers.length; index++) {
        final name = _ingredientNameControllers[index].text.trim();
        final quantity = _ingredientQuantityControllers[index].text.trim();
        final unit = _ingredientUnitControllers[index].text.trim();

        if (name.isEmpty) continue;

        ingredients.add(
          RecipeIngredient(name: name, quantity: quantity, unit: unit),
        );
      }

      final steps = _stepControllers
          .map((controller) => controller.text.trim())
          .where((step) => step.isNotEmpty)
          .toList();

      final recipe = RecipeModel(
        id: widget.recipe?['id']?.toString() ?? '',
        title: title,
        description: description,
        categories: List<String>.from(_selectedCategories),
        ingredients: ingredients,
        steps: steps,
        status: _status,

        cookTimeMinutes: int.tryParse(_cookTimeController.text.trim()) ?? 0,

        difficulty: _difficulty,

        ratingAverage:
            (widget.recipe?['ratingAverage'] as num?)?.toDouble() ?? 0.0,

        reviewCount: (widget.recipe?['reviewCount'] as num?)?.toInt() ?? 0,

        imageUrl: _imageUrlController.text.trim(),
        createdAt: widget.recipe?['createdAt'],
      );

      final provider = context.read<RecipeProvider>();

      if (widget.isEdit) {
        await provider.updateRecipe(recipe);
      } else {
        await provider.createRecipe(recipe);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan resep: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
                Text('Durasi Memasak (menit)', style: AppTextStyles.smallBold),
                const SizedBox(height: AppSizes.spaceS),

                TextField(
                  controller: _cookTimeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Contoh: 30'),
                ),

                const SizedBox(height: AppSizes.spaceL),
                Text('Tingkat Kesulitan', style: AppTextStyles.smallBold),

                const SizedBox(height: AppSizes.spaceS),

                DropdownButtonFormField<String>(
                  value: _difficulty,
                  decoration: const InputDecoration(),
                  items: const [
                    DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _difficulty = value ?? 'Easy';
                    });
                  },
                ),

                const SizedBox(height: AppSizes.spaceL),
                Text('URL Gambar Utama', style: AppTextStyles.smallBold),
                const SizedBox(height: AppSizes.spaceS),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    hintText: 'https://contoh.com/gambar-resep.jpg',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _imageUrlPreview = value.trim();
                    });
                  },
                ),
                const SizedBox(height: AppSizes.spaceM),
                if (_imageUrlPreview.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    child: Image.network(
                      _imageUrlPreview,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Text('Preview gambar gagal dimuat'),
                        );
                      },
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
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Text(
                        _isSubmitting
                            ? 'Menyimpan...'
                            : widget.isEdit
                            ? 'Simpan Perubahan'
                            : 'Tambah Resep',
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
