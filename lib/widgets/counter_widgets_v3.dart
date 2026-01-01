import 'package:flutter/material.dart';

// --- 1. LIST ITEM DESIGN ---
class CounterListCardV3 extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onSub;
  final VoidCallback onReset;
  final Function(String) onMenuSelected;

  const CounterListCardV3({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    required this.onAdd,
    required this.onSub,
    required this.onReset,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Kolom Nama & Angka
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: scheme.primary,
                        fontFamily: 'Monospace',
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),

              // 3 TOMBOL: MINUS - RESET - PLUS
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.filledTonal(
                    onPressed: onSub,
                    icon: const Icon(Icons.remove),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.surfaceContainerHigh,
                      foregroundColor: scheme.onSurfaceVariant,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  IconButton.filledTonal(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.surfaceContainerHigh,
                      foregroundColor: scheme.onSurfaceVariant,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),

                  IconButton.filled(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 4),
              // Menu (Edit & Delete)
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: scheme.onSurfaceVariant),
                onSelected: onMenuSelected,
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Rename')),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: scheme.error)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. GRID/CIRCLE ITEM DESIGN (SUDAH DIPERBAIKI PADDINGNYA) ---
class CounterGridCardV3 extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onSub;
  final VoidCallback onReset;

  const CounterGridCardV3({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    required this.onAdd,
    required this.onSub,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.hardEdge, // Agar animasi klik tidak keluar border
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            // PADDING DIPERLUAS AGAR TIDAK MEPET
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                // 1. Judul
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16, // Ukuran font pas
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                
                // 2. Lingkaran Angka
                Expanded(
                  child: Center(
                    child: Container(
                      width: 80, 
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.surface,
                        border: Border.all(color: scheme.primary.withOpacity(0.3), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // 3. Tombol Mini di Bawah
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MiniButton(icon: Icons.remove, onTap: onSub, scheme: scheme),
                    _MiniButton(icon: Icons.refresh, onTap: onReset, scheme: scheme),
                    _MiniButton(icon: Icons.add, onTap: onAdd, scheme: scheme, isPrimary: true),
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

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme scheme;
  final bool isPrimary;

  const _MiniButton({required this.icon, required this.onTap, required this.scheme, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isPrimary ? scheme.primary : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isPrimary ? scheme.onPrimary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ... kode bagian atas (CounterListCardV3 & CounterGridCardV3) BIARKAN SAJA ...

// --- 3. BIG DETAIL VIEW (UPDATED: BISA TAP DI LINGKARAN) ---
class CounterDetailViewV3 extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onAdd;
  final VoidCallback onSub;
  final VoidCallback onReset;
  final VoidCallback onBack;

  const CounterDetailViewV3({
    super.key,
    required this.title,
    required this.value,
    required this.onAdd,
    required this.onSub,
    required this.onReset,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton.filledTonal(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          
          const SizedBox(height: 40),

          // --- LINGKARAN BESAR (SEKARANG BISA DI-TAP) ---
          Container(
            width: 260,
            height: 260,
            // Clip agar efek ripple InkWell tidak keluar dari lingkaran
            clipBehavior: Clip.hardEdge, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primaryContainer.withOpacity(0.5),
                  scheme.surface,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 2,
                )
              ],
              border: Border.all(color: scheme.primary.withOpacity(0.2), width: 8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAdd, // <--- INI KUNCINYA: Tap lingkaran = Tambah
                splashColor: scheme.primary.withOpacity(0.2), // Efek air saat ditekan
                highlightColor: scheme.primary.withOpacity(0.1),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        '$value',
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 50),

          // Tombol Kontrol
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.large(
                heroTag: 'sub',
                onPressed: onSub,
                backgroundColor: scheme.surfaceContainerHigh,
                foregroundColor: scheme.onSurface,
                elevation: 2,
                child: const Icon(Icons.remove, size: 32),
              ),
              
              const SizedBox(width: 24), 
              
              FloatingActionButton.large(
                heroTag: 'reset',
                onPressed: onReset,
                backgroundColor: scheme.surfaceContainerHigh,
                foregroundColor: scheme.onSurface,
                elevation: 2,
                child: const Icon(Icons.refresh, size: 32),
              ),
              
              const SizedBox(width: 24),

              FloatingActionButton.large(
                heroTag: 'add',
                onPressed: onAdd,
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                elevation: 6,
                child: const Icon(Icons.add, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}