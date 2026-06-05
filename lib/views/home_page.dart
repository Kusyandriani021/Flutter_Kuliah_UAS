import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/todo_controller.dart';
import '../models/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TodoController>();
    final theme = Theme.of(context);
    final gojekGreen = const Color(0xFF00AA13);
    final gojekGreen2 = const Color(0xFF5AF27F);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00AA13), Color(0xFF5AF27F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Image.asset(
                    'assets/gojek_logo.png',
                    height: 36,
                    width: 36,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.school, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Pengajuan Seminar TA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.school, color: gojekGreen, size: 28),
                const SizedBox(width: 8),
                Text(
                  'Daftar Pengajuan Seminar',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: gojekGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ctrl.pengajuanList.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada pengajuan seminar',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: ctrl.pengajuanList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final p = ctrl.pengajuanList[i];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + i * 80),
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        ),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: gojekGreen.withOpacity(0.15),
                                  radius: 28,
                                  child: Icon(
                                    p.berkasLengkap
                                        ? Icons.check_circle
                                        : Icons.assignment,
                                    color: p.berkasLengkap
                                        ? gojekGreen
                                        : Colors.grey,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              p.nama,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Chip(
                                            label: Text(
                                              p.berkasLengkap
                                                  ? 'Berkas Lengkap'
                                                  : 'Belum Lengkap',
                                              style: TextStyle(
                                                color: p.berkasLengkap
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            backgroundColor: p.berkasLengkap
                                                ? gojekGreen
                                                : Colors.grey.shade300,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              color: Colors.blue,
                                            ),
                                            tooltip: 'Edit',
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/add',
                                                arguments: i,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red),
                                            tooltip: 'Hapus',
                                            onPressed: () async {
                                              final confirm =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                      'Konfirmasi Hapus'),
                                                  content: const Text(
                                                      'Yakin ingin menghapus pengajuan ini?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              ctx, false),
                                                      child:
                                                          const Text('Batal'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              ctx, true),
                                                      child: const Text('Hapus',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirm == true) {
                                                context
                                                    .read<TodoController>()
                                                    .removePengajuan(i);
                                              }
                                            },
                                          ),

                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        p.nim,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        p.judul,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.person,
                                              size: 16, color: gojekGreen),
                                          const SizedBox(width: 4),
                                          Text(
                                            p.dosenPembimbing,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(Icons.meeting_room,
                                              size: 16, color: gojekGreen),
                                          const SizedBox(width: 4),
                                          Text(
                                            p.ruangan,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.date_range,
                                              size: 16, color: gojekGreen),
                                          const SizedBox(width: 4),
                                          Text(
                                            p.tanggalSeminar
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 62,
        child: FloatingActionButton.extended(
          backgroundColor: gojekGreen,
          onPressed: () => Navigator.pushNamed(context, '/add'),
          icon: const Icon(Icons.add, color: Colors.white, size: 28),
          label: const Text(
            'Tambah Pengajuan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              letterSpacing: 0.2,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
