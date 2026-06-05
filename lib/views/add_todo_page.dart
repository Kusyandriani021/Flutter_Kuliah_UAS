import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pengajuan_seminar.dart';
import '../controllers/todo_controller.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _nimCtrl = TextEditingController();
  final _judulCtrl = TextEditingController();
  final _dosenCtrl = TextEditingController();
  final _ruanganCtrl = TextEditingController();
  DateTime? _tanggalSeminar;
  bool _berkasLengkap = false;

  int? _editingIndex;

  bool get _isEditing => _editingIndex != null;


  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _judulCtrl.dispose();
    _dosenCtrl.dispose();
    _ruanganCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTanggalSeminar() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalSeminar ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _tanggalSeminar = picked;
      });
    }
  }

  Future<void> _showSummaryDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ringkasan Pengajuan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: \\${_namaCtrl.text}'),
            Text('NIM: \\${_nimCtrl.text}'),
            Text('Judul: \\${_judulCtrl.text}'),
            Text('Dosen Pembimbing: \\${_dosenCtrl.text}'),
            Text(
                'Tanggal Seminar: \\${_tanggalSeminar != null ? _tanggalSeminar!.toLocal().toString().split(' ')[0] : '-'}'),
            Text('Ruangan: \\${_ruanganCtrl.text}'),
            Text('Berkas Lengkap: \\${_berkasLengkap ? 'Ya' : 'Tidak'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      final idx = args;
      final list = context.read<TodoController>().pengajuanList;
      if (idx >= 0 && idx < list.length) {
        final p = list[idx];
        // Pastikan hanya set saat masuk mode edit untuk menghindari overwrite berkali-kali.
        if (!_isEditing || _editingIndex != idx) {
          setState(() {
            _editingIndex = idx;
            _namaCtrl.text = p.nama;
            _nimCtrl.text = p.nim;
            _judulCtrl.text = p.judul;
            _dosenCtrl.text = p.dosenPembimbing;
            _tanggalSeminar = p.tanggalSeminar;
            _ruanganCtrl.text = p.ruangan;
            _berkasLengkap = p.berkasLengkap;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Pengajuan Seminar TA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Formulir Pengajuan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _namaCtrl,
                        decoration: InputDecoration(
                          labelText: 'Nama Mahasiswa',
                          prefixIcon: const Icon(Icons.person,
                              color: Colors.deepPurple),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Nama wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nimCtrl,
                        decoration: InputDecoration(
                          labelText: 'NIM',
                          prefixIcon: const Icon(Icons.credit_card,
                              color: Colors.deepPurple),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'NIM wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _judulCtrl,
                        decoration: InputDecoration(
                          labelText: 'Judul Tugas Akhir',
                          prefixIcon: const Icon(Icons.assignment,
                              color: Colors.deepPurple),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Judul wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dosenCtrl,
                        decoration: InputDecoration(
                          labelText: 'Dosen Pembimbing',
                          prefixIcon: const Icon(Icons.school,
                              color: Colors.deepPurple),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Dosen wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _pickTanggalSeminar,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Tanggal Seminar',
                            prefixIcon: const Icon(Icons.date_range,
                                color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          child: Text(
                            _tanggalSeminar != null
                                ? _tanggalSeminar!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]
                                : 'Pilih tanggal',
                            style: TextStyle(
                              color: _tanggalSeminar != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ruanganCtrl,
                        decoration: InputDecoration(
                          labelText: 'Ruangan Seminar',
                          prefixIcon: const Icon(Icons.meeting_room,
                              color: Colors.deepPurple),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Ruangan wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text(
                          'Berkas Lengkap',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        activeColor: Colors.deepPurple,
                        value: _berkasLengkap,
                        onChanged: (value) {
                          setState(() {
                            _berkasLengkap = value;
                          });
                        },
                        secondary: Icon(
                          _berkasLengkap ? Icons.check_circle : Icons.cancel,
                          color: _berkasLengkap ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _tanggalSeminar != null) {
                      // Kirim ke controller
                      final pengajuan = PengajuanSeminar(
                        nama: _namaCtrl.text.trim(),
                        nim: _nimCtrl.text.trim(),
                        judul: _judulCtrl.text.trim(),
                        dosenPembimbing: _dosenCtrl.text.trim(),
                        tanggalSeminar: _tanggalSeminar!,
                        ruangan: _ruanganCtrl.text.trim(),
                        berkasLengkap: _berkasLengkap,
                      );

                      final ctrl = context.read<TodoController>();
                      if (_isEditing) {
                        ctrl.updatePengajuan(_editingIndex!, pengajuan);
                      } else {
                        ctrl.addPengajuan(pengajuan);
                      }

                      await _showSummaryDialog();
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/');
                    } else if (_tanggalSeminar == null) {
                      ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(
                            content: Text('Tanggal seminar wajib dipilih!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Simpan Pengajuan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
