import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:siresep_admin/models/review_model.dart';
import 'package:siresep_admin/providers/review_provider.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  String _selectedRating = 'Semua Rating';
  String _commentKeyword = '';
  String _selectedRecipe = '';

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().fetchReviews();
    });
  }

  List<ReviewModel> _filteredReviews(List<ReviewModel> reviews) {
    return reviews.where((review) {
      final matchesRating =
          _selectedRating == 'Semua Rating' ||
          review.rating == int.parse(_selectedRating.split(' ').first);

      final matchesComment =
          _commentKeyword.isEmpty ||
          review.comment.toLowerCase().contains(_commentKeyword.toLowerCase());

      final matchesRecipe =
          _selectedRecipe.isEmpty ||
          review.recipeName.toLowerCase().contains(
            _selectedRecipe.toLowerCase(),
          );

      final reviewDate = review.createdAt?.toDate();

      final matchesStartDate =
          _startDate == null ||
          reviewDate == null ||
          !reviewDate.isBefore(_startDate!);

      final matchesEndDate =
          _endDate == null ||
          reviewDate == null ||
          !reviewDate.isAfter(_endDate!);

      return matchesRating &&
          matchesRecipe &&
          matchesComment &&
          matchesStartDate &&
          matchesEndDate;
    }).toList();
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final initialDate = isStartDate
        ? (_startDate ?? DateTime(2026, 4, 1))
        : (_endDate ?? DateTime(2026, 4, 12));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    setState(() {
      if (isStartDate) {
        _startDate = pickedDate;

        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = pickedDate;
        }
      } else {
        _endDate = pickedDate;

        if (_startDate != null && _startDate!.isAfter(_endDate!)) {
          _startDate = pickedDate;
        }
      }
    });
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _deleteReview(ReviewModel review) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Review'),
          content: Text(
            'Apakah Anda yakin ingin menghapus review dari "${review.userName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await context.read<ReviewProvider>().deleteReview(
        recipeId: review.recipeId,
        reviewId: review.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Review berhasil dihapus')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus review: $e')));
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String _formatInputDate(DateTime? date) {
    if (date == null) return 'dd/mm/yyyy';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        final reviews = _filteredReviews(provider.reviews);

        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Moderasi Review', style: AppTextStyles.h1),
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  'Pantau dan kelola review dari pengguna',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSizes.spaceXL),
                _buildFilters(provider.reviews),
                const SizedBox(height: AppSizes.spaceXL),
                _ReviewsTable(
                  reviews: reviews,
                  formatDate: _formatDate,
                  onDeleteTap: _deleteReview,
                ),
                const SizedBox(height: AppSizes.spaceL),
                Row(
                  children: [
                    Text(
                      'Menampilkan ${reviews.length} dari ${provider.reviews.length} review',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilters(List<ReviewModel> reviews) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _FilterDropdown(
                value: _selectedRating,
                items: const [
                  'Semua Rating',
                  '5 Bintang',
                  '4 Bintang',
                  '3 Bintang',
                  '2 Bintang',
                  '1 Bintang',
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRating = value;
                  });
                },
              ),
            ),

            const SizedBox(width: AppSizes.spaceM),

            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Cari komentar...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _commentKeyword = value;
                  });
                },
              ),
            ),

            const SizedBox(width: AppSizes.spaceM),

            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Cari resep...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedRecipe = value;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.spaceM),

        Row(
          children: [
            Expanded(
              child: _DateInput(
                label: _formatInputDate(_startDate),
                onTap: () => _pickDate(isStartDate: true),
              ),
            ),

            const SizedBox(width: AppSizes.spaceM),

            Expanded(
              child: _DateInput(
                label: _formatInputDate(_endDate),
                onTap: () => _pickDate(isStartDate: false),
              ),
            ),

            const SizedBox(width: AppSizes.spaceM),

            OutlinedButton.icon(
              onPressed: _clearDateFilter,
              icon: const Icon(Icons.close),
              label: const Text('Reset Tanggal'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewsTable extends StatelessWidget {
  final List<ReviewModel> reviews;
  final String Function(DateTime date) formatDate;
  final Future<void> Function(ReviewModel review) onDeleteTap;

  const _ReviewsTable({
    required this.reviews,
    required this.formatDate,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Column(
          children: [
            Container(
              color: AppColors.inputBg,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TableText('Nama User', flex: 2, isHeader: true),
                  _TableText('Resep', flex: 3, isHeader: true),
                  _TableText('Rating', flex: 2, isHeader: true),
                  _TableText('Komentar', flex: 5, isHeader: true),
                  _TableText('Tanggal', flex: 2, isHeader: true),
                  _TableText('Aksi', flex: 1, isHeader: true),
                ],
              ),
            ),
            if (reviews.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                child: Text(
                  'Tidak ada review yang sesuai.',
                  style: AppTextStyles.bodySecondary,
                ),
              )
            else
              ...reviews.map(
                (review) => _ReviewRow(
                  review: review,
                  formatDate: formatDate,
                  onDeleteTap: () async {
                    await onDeleteTap(review);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final ReviewModel review;
  final String Function(DateTime date) formatDate;
  final VoidCallback onDeleteTap;

  const _ReviewRow({
    required this.review,
    required this.formatDate,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final reviewDate = review.createdAt?.toDate() ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingL,
        vertical: AppSizes.paddingM,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TableText(review.userName, flex: 2),
          _TableText(review.recipeName, flex: 3),
          Expanded(flex: 2, child: _RatingStars(rating: review.rating)),
          _TableText(review.comment, flex: 5, maxLines: 2),
          _TableText(formatDate(reviewDate), flex: 2),
          Expanded(
            flex: 1,
            child: IconButton(
              tooltip: 'Hapus review',
              onPressed: onDeleteTap,
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  final int rating;

  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final isFilled = index < rating;

        return Icon(
          isFilled ? Icons.star : Icons.star_border,
          size: AppSizes.iconS,
          color: isFilled ? AppColors.warning : AppColors.textSecondary,
        );
      }),
    );
  }
}

class _TableText extends StatelessWidget {
  final String text;
  final int flex;
  final bool isHeader;
  final int maxLines;

  const _TableText(
    this.text, {
    required this.flex,
    this.isHeader = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSizes.paddingM),
        child: Text(
          text,
          maxLines: isHeader ? 1 : maxLines,
          overflow: TextOverflow.ellipsis,
          style: isHeader
              ? AppTextStyles.smallBold.copyWith(color: AppColors.textSecondary)
              : AppTextStyles.body,
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: const InputDecoration(),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateInput({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasValue = label != 'dd/mm/yyyy';

    return Material(
      color: AppColors.inputBg,
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: Container(
          height: AppSizes.buttonHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: hasValue
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.textSecondary,
                size: AppSizes.iconS,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
