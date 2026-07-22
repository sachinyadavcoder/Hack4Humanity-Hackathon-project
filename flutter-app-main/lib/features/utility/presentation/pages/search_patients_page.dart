import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/app/theme/app_theme.dart';
import 'package:new_app/app/constants/dummy_data.dart';
import 'package:new_app/core/widgets/common_widgets.dart';

class SearchPatientsPage extends StatefulWidget {
  const SearchPatientsPage({super.key});

  @override
  State<SearchPatientsPage> createState() => _SearchPatientsPageState();
}

class _SearchPatientsPageState extends State<SearchPatientsPage> {
  final _searchController = TextEditingController();
  String _query = '';

  List<Map<String, dynamic>> get _results {
    if (_query.isEmpty) return [];
    return DummyData.patients
        .where((p) => p['name']
            .toString()
            .toLowerCase()
            .contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search patients by name...',
            border: InputBorder.none,
            filled: false,
            hintStyle: GoogleFonts.beVietnamPro(
              color: AppTheme.outline,
            ),
          ),
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            color: AppTheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_rounded,
                      size: 64, color: AppTheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    'Search by patient name',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : _results.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.person_search_rounded,
                  title: 'No Results',
                  subtitle: 'No patients found for "$_query".',
                )
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final patient = _results[index];
                    return PatientCard(
                      patient: patient,
                      onTap: () =>
                          context.push('/patients/${patient['id']}'),
                    );
                  },
                ),
    );
  }
}
