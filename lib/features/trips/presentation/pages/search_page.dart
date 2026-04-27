import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../bloc/trip_search_bloc.dart';
import '../bloc/trip_search_event.dart';
import '../bloc/trip_search_state.dart';
import '../widgets/trip_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedSeats = 1;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث عن رحلة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<TripSearchBloc, TripSearchState>(
        builder: (context, state) {
          return Column(
            children: [
              // Search form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // From/To fields with swap
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildLocationField(
                                controller: _fromController,
                                hint: 'من أين؟',
                                icon: Icons.circle,
                                iconColor: AppColors.primary,
                                onChanged: (v) => context
                                    .read<TripSearchBloc>()
                                    .add(UpdateFromEvent(v)),
                              ),
                              const SizedBox(height: 12),
                              _buildLocationField(
                                controller: _toController,
                                hint: 'إلى أين؟',
                                icon: Icons.circle,
                                iconColor: AppColors.accent,
                                onChanged: (v) => context
                                    .read<TripSearchBloc>()
                                    .add(UpdateToEvent(v)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Swap button
                        GestureDetector(
                          onTap: () {
                            final temp = _fromController.text;
                            _fromController.text = _toController.text;
                            _toController.text = temp;
                            context
                                .read<TripSearchBloc>()
                                .add(SwapLocationsEvent());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.swap_vert_rounded,
                                color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Date and seats row
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_rounded,
                                      size: 18,
                                      color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Seats selector
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_rounded,
                                    size: 18),
                                onPressed: _selectedSeats > 1
                                    ? () {
                                        setState(
                                            () => _selectedSeats--);
                                        context
                                            .read<TripSearchBloc>()
                                            .add(UpdateSeatsEvent(
                                                _selectedSeats));
                                      }
                                    : null,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4),
                                child: Text('$_selectedSeats',
                                    style: AppTextStyles.bodyLarge),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_rounded,
                                    size: 18),
                                onPressed: _selectedSeats < 4
                                    ? () {
                                        setState(
                                            () => _selectedSeats++);
                                        context
                                            .read<TripSearchBloc>()
                                            .add(UpdateSeatsEvent(
                                                _selectedSeats));
                                      }
                                    : null,
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                              ),
                              const Icon(Icons.event_seat_rounded,
                                  size: 18,
                                  color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'بحث',
                      icon: Icons.search_rounded,
                      isLoading: state is TripSearchLoading,
                      onPressed: () {
                        if (_fromController.text.isNotEmpty &&
                            _toController.text.isNotEmpty) {
                          context
                              .read<TripSearchBloc>()
                              .add(SearchTripsTriggeredEvent());
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Results
              Expanded(
                child: _buildResults(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResults(TripSearchState state) {
    if (state is TripSearchLoading) {
      return const LoadingIndicator();
    }

    if (state is TripSearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.danger),
            const SizedBox(height: 12),
            Text(state.message, style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }

    if (state is TripSearchEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 64, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text(
                'لا توجد رحلات من ${state.from} إلى ${state.to}',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'جرّب تغيير التاريخ أو عدد المقاعد',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state is TripSearchLoaded) {
      return Column(
        children: [
          // Sort bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text('${state.trips.length} رحلة',
                    style: AppTextStyles.bodySmall),
                const Spacer(),
                _buildSortChip('الأرخص', TripSortOption.cheapest),
                const SizedBox(width: 8),
                _buildSortChip('الأقرب', TripSortOption.earliest),
                const SizedBox(width: 8),
                _buildSortChip('الأعلى تقييماً', TripSortOption.topRated),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.trips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return TripCard(
                  trip: state.trips[index],
                  onTap: () => context
                      .push('/trips/${state.trips[index].id}'),
                );
              },
            ),
          ),
        ],
      );
    }

    // Initial state — show recent searches placeholder
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.travel_explore_rounded,
                size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('ابحث عن رحلتك القادمة',
                style: AppTextStyles.bodyLarge
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, TripSortOption sort) {
    return GestureDetector(
      onTap: () =>
          context.read<TripSearchBloc>().add(ApplySortEvent(sort)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(label, style: AppTextStyles.caption),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 12, color: iconColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      if (context.mounted) {
        context.read<TripSearchBloc>().add(UpdateDateEvent(picked));
      }
    }
  }
}
