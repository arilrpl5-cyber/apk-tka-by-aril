import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/dummy_data.dart';
import '../../../models/models.dart';

/// Section Materi Belajar: dropdown + search + grid 4x2 + tombol manager.
class MateriSection extends StatefulWidget {
  final void Function(MaterialModel material)? onTapMateri;
  final VoidCallback? onBookmark;
  final VoidCallback? onDownload;

  const MateriSection(
      {super.key, this.onTapMateri, this.onBookmark, this.onDownload});

  @override
  State<MateriSection> createState() => _MateriSectionState();
}

class _MateriSectionState extends State<MateriSection> {
  String selectedKelas = 'Kelas 12 - IPA - K13';
  String query = '';

  final kelasOptions = const [
    'Kelas 12 - IPA - K13',
    'Kelas 12 - IPS - K13',
    'Kelas 11 - SMK',
    'Kelas 10 - Merdeka',
  ];

  @override
  Widget build(BuildContext context) {
    final all = DummyData.materiBelajar;
    final filtered = query.isEmpty
        ? all
        : all
            .where((m) =>
                m.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Materi Belajar'),
          const SizedBox(height: 12),

          // --- Dropdown kelas ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.dropdownBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedKelas,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.primaryBlue),
                style: AppTextStyles.body
                    .copyWith(fontWeight: FontWeight.w700),
                items: kelasOptions
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => selectedKelas = v);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // --- Search bar ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.searchBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: 'Cari materi...',
                hintStyle: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
                border: InputBorder.none,
                icon: const Icon(Icons.search,
                    color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // --- Grid materi 4 kolom ---
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text('Materi tidak ditemukan',
                    style: AppTextStyles.body),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return MaterialGridItem(
                  material: filtered[index],
                  onTap: () =>
                      widget.onTapMateri?.call(filtered[index]),
                );
              },
            ),
          const SizedBox(height: 12),

          // --- Bookmark & Download Manager ---
          Row(
            children: [
              Expanded(
                child: _managerButton(
                  icon: Icons.bookmark_border,
                  label: 'Bookmark',
                  onTap: widget.onBookmark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _managerButton(
                  icon: Icons.download_outlined,
                  label: 'Download Manager',
                  onTap: widget.onDownload,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _managerButton(
      {required IconData icon,
      required String label,
      VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primaryBlue),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu item grid materi (icon box 80x80 + label).
class MaterialGridItem extends StatelessWidget {
  final MaterialModel material;
  final VoidCallback? onTap;

  const MaterialGridItem({super.key, required this.material, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 62,
            decoration: BoxDecoration(
              color: material.backgroundColor.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: material.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(material.icon,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            material.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
