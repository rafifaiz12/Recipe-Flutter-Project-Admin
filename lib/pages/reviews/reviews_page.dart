import 'package:flutter/material.dart';
import 'package:siresep_admin/core/constants/app_colors.dart';
import 'package:siresep_admin/core/constants/app_sizes.dart';
import 'package:siresep_admin/core/constants/app_text_styles.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  String _selectedRating = 'Semua Rating';
  String _selectedStatus = 'Semua Status';
  String _selectedRecipe = 'Semua Resep';

  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, dynamic>> _reviews = [
    {
      'userName': 'Ahmad Fauzi',
      'recipeName': 'Nasi Goreng Spesial',
      'rating': 5,
      'comment': 'Enak banget! Resepnya mudah diikuti dan hasilnya memuaskan.',
      'date': DateTime(2026, 4, 11),
      'status': 'Aktif',
    },
    {
      'userName': 'Siti Nurhaliza',
      'recipeName': 'Rendang Daging Sapi',
      'rating': 4,
      'comment': 'Lumayan enak, tapi agak terlalu pedas untuk saya.',
      'date': DateTime(2026, 4, 10),
      'status': 'Aktif',
    },
    {
      'userName': 'Budi Santoso',
      'recipeName': 'Spaghetti Carbonara',
      'rating': 1,
      'comment': 'Resep sampah! Tidak jelas sama sekali.',
      'date': DateTime(2026, 4, 9),
      'status': 'Aktif',
    },
    {
      'userName': 'Dewi Lestari',
      'recipeName': 'Soto Ayam',
      'rating': 5,
      'comment': 'Perfect! Keluarga saya sangat suka. Terima kasih resepnya.',
      'date': DateTime(2026, 4, 8),
      'status': 'Aktif',
    },
    {
      'userName': 'Eko Prasetyo',
      'recipeName': 'Gado-Gado',
      'rating': 3,
      'comment': 'Biasa saja, tidak ada yang spesial.',
      'date': DateTime(2026, 4, 7),
      'status': 'Dihapus',
    },
  ];

  List<String> get _recipeOptions {
    final recipes = _reviews
        .map((review) => review['recipeName'] as String)
        .toSet()
        .toList();

    return ['Semua Resep', ...recipes];
  }

  List<Map<String, dynamic>> get _filteredReviews {
    return _reviews.where((review) {
      final rating = review['rating'] as int;
      final status = review['status'] as String;
      final recipeName = review['recipeName'] as String;
      final date = review['date'] as DateTime;

      final matchesRating =
          _selectedRating == 'Semua Rating' ||
          rating == int.parse(_selectedRating.split(' ').first);

      final matchesStatus =
          _selectedStatus == 'Semua Status' || status == _selectedStatus;

      final matchesRecipe =
          _selectedRecipe == 'Semua Resep' || recipeName == _selectedRecipe;

      final matchesStartDate =
          _startDate == null || !date.isBefore(_startDate!);

      final matchesEndDate = _endDate == null || !date.isAfter(_endDate!);

      return matchesRating &&
          matchesStatus &&
          matchesRecipe &&
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

  void _deleteReview(Map<String, dynamic> review) {
    setState(() {
      review['status'] = 'Dihapus';
    });
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
    final reviews = _filteredReviews;

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
            _buildFilters(),
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
                  'Menampilkan ${reviews.length} dari ${_reviews.length} review',
                  style: AppTextStyles.bodySecondary,
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Sebelumnya'),
                ),
                const SizedBox(width: AppSizes.spaceS),
                ElevatedButton(onPressed: () {}, child: const Text('1')),
                const SizedBox(width: AppSizes.spaceS),
                OutlinedButton(onPressed: () {}, child: const Text('2')),
                const SizedBox(width: AppSizes.spaceS),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Selanjutnya'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
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
                  setState(() => _selectedRating = value);
                },
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: _FilterDropdown(
                value: _selectedStatus,
                items: const ['Semua Status', 'Aktif', 'Dihapus'],
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                },
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: _FilterDropdown(
                value: _selectedRecipe,
                items: _recipeOptions,
                onChanged: (value) {
                  setState(() => _selectedRecipe = value);
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
  final List<Map<String, dynamic>> reviews;
  final String Function(DateTime date) formatDate;
  final ValueChanged<Map<String, dynamic>> onDeleteTap;

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
                  _TableText('Status', flex: 2, isHeader: true),
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
                  onDeleteTap: () => onDeleteTap(review),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final Map<String, dynamic> review;
  final String Function(DateTime date) formatDate;
  final VoidCallback onDeleteTap;

  const _ReviewRow({
    required this.review,
    required this.formatDate,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = review['status'] as String;

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
          _TableText(review['userName'] as String, flex: 2),
          _TableText(review['recipeName'] as String, flex: 3),
          Expanded(
            flex: 2,
            child: _RatingStars(rating: review['rating'] as int),
          ),
          _TableText(review['comment'] as String, flex: 5, maxLines: 2),
          _TableText(formatDate(review['date'] as DateTime), flex: 2),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: _StatusBadge(status: status),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              tooltip: 'Hapus review',
              onPressed: status == 'Dihapus' ? null : onDeleteTap,
              icon: Icon(
                Icons.delete_outline,
                color: status == 'Dihapus'
                    ? AppColors.textSecondary
                    : AppColors.error,
              ),
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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  bool get _isActive => status == 'Aktif';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: _isActive
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: _isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.w700,
        ),
      ),
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
