import 'package:flutter/material.dart';
import '../models/counter_item.dart';
import '../services/local_storage.dart';
import '../widgets/counter_widgets_v3.dart';

enum ViewMode { list, grid }

class CounterPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const CounterPage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  List<CounterItem> counters = [];
  ViewMode viewMode = ViewMode.list;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await LocalStorage.loadCounters();
    final modeStr = await LocalStorage.loadViewMode();
    setState(() {
      counters = data;
      viewMode = (modeStr == 'circle' || modeStr == 'grid') ? ViewMode.grid : ViewMode.list;
    });
  }

  void _save() {
    LocalStorage.saveCounters(counters);
    LocalStorage.saveViewMode(viewMode.name);
    setState(() {}); 
  }

  void _updateValue(int index, int delta) {
    setState(() => counters[index].value += delta);
    _save();
  }
  
  void _resetValue(int index) {
    setState(() => counters[index].value = 0);
    _save();
  }

  void _handleMenu(int index, String action) {
    if (action == 'edit') _dialogEdit(index);
    if (action == 'delete') _dialogDelete(index);
  }

  // --- DIALOGS ---
  void _dialogEdit(int? index) {
    final isNew = index == null;
    final ctrl = TextEditingController(text: isNew ? '' : counters[index].name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? 'New Counter' : 'Rename Counter'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Dzikir, Water Intake',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                if (isNew) {
                  counters.add(CounterItem(name: ctrl.text.trim()));
                } else {
                  counters[index].name = ctrl.text.trim();
                }
                _save();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _dialogDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Counter'),
        content: Text('Are you sure you want to delete "${counters[index].name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() {
                counters.removeAt(index);
                if (selectedIndex == index) selectedIndex = null;
              });
              _save();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. DETAIL VIEW
    if (selectedIndex != null && selectedIndex! < counters.length) {
      final item = counters[selectedIndex!];
      return Scaffold(
        body: SafeArea(
          child: CounterDetailViewV3(
            title: item.name,
            value: item.value,
            onAdd: () => _updateValue(selectedIndex!, 1),
            onSub: () => _updateValue(selectedIndex!, -1),
            onReset: () => _resetValue(selectedIndex!),
            onBack: () => setState(() => selectedIndex = null),
          ),
        ),
      );
    }

    // 2. MAIN VIEW (LIST / GRID)
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Counter One',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Switch View',
            icon: Icon(viewMode == ViewMode.list ? Icons.grid_view_rounded : Icons.view_list_rounded),
            onPressed: () {
              setState(() {
                viewMode = viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
              });
              _save();
            },
          ),
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: widget.toggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _dialogEdit(null),
        icon: const Icon(Icons.add),
        label: const Text('New Count'),
      ),
      body: counters.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.format_list_bulleted_add, size: 80, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  Text('No counters yet.\nTap "+ New Count" to start.', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  ),
                ],
              ),
            )
          : viewMode == ViewMode.list
              // --- TAMPILAN LIST ---
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100, top: 8),
                  itemCount: counters.length,
                  itemBuilder: (_, i) => CounterListCardV3(
                    title: counters[i].name,
                    value: counters[i].value,
                    onTap: () => setState(() => selectedIndex = i),
                    onAdd: () => _updateValue(i, 1),
                    onSub: () => _updateValue(i, -1),
                    onReset: () => _resetValue(i),
                    onMenuSelected: (action) => _handleMenu(i, action),
                  ),
                )
              // --- TAMPILAN GRID ---
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    // KUNCI: Ubah ini jadi 0.72 agar kartu lebih tinggi (vertikal)
                    childAspectRatio: 0.72, 
                  ),
                  itemCount: counters.length,
                  itemBuilder: (_, i) => CounterGridCardV3(
                    title: counters[i].name,
                    value: counters[i].value,
                    onTap: () => setState(() => selectedIndex = i),
                    onAdd: () => _updateValue(i, 1),
                    onSub: () => _updateValue(i, -1),
                    onReset: () => _resetValue(i),
                  ),
                ),
    );
  }
}