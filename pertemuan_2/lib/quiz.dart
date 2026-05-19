import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  // --- STATE UNTUK PROFILE ---
  String profileImagePath = '';
  String tentang = 'Mahasiswa IT yang berfokus pada pengembangan sistem, web, dan UI/UX Design.';
  String pendidikan = 'S1 Teknik Informatika';
  String lokasi = 'Bandung, Indonesia';
  String kontak = 'email@mahasiswa.ac.id';

  // --- STATE UNTUK PENGALAMAN (BONUS) ---
  String expImagePath = '';
  String expJudul = 'Sistem Peminjaman Alat Laboratorium Pangan';
  String expDeskripsi = 'Mengembangkan fitur pelaporan, dokumentasi, dan sistem peminjaman berbasis web.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu Navigasi', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Edit Pengalaman'),
              onTap: () async {
                Navigator.pop(context); // Tutup drawer
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPengalamanPage(
                      imagePath: expImagePath,
                      judul: expJudul,
                      deskripsi: expDeskripsi,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    expImagePath = result['image'];
                    expJudul = result['judul'];
                    expDeskripsi = result['deskripsi'];
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: profileImagePath.isNotEmpty
                    ? FileImage(File(profileImagePath))
                    : null,
                child: profileImagePath.isEmpty ? const Icon(Icons.person, size: 60) : null,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        imagePath: profileImagePath,
                        tentang: tentang,
                        pendidikan: pendidikan,
                        lokasi: lokasi,
                        kontak: kontak,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      profileImagePath = result['image'];
                      tentang = result['tentang'];
                      pendidikan = result['pendidikan'];
                      lokasi = result['lokasi'];
                      kontak = result['kontak'];
                    });
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
            const Divider(height: 40),

            const Text('Tentang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(tentang),
            const SizedBox(height: 10),

            const Text('Pendidikan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(pendidikan),
            const SizedBox(height: 10),

            const Text('Lokasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(lokasi),
            const SizedBox(height: 10),

            const Text('Kontak', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(kontak),
            const Divider(height: 40),

            const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('• Flutter & Dart\n• UI/UX Design (Figma)\n• Java & Laravel\n• Git & GitHub'),
            const Divider(height: 40),

            const Text('Pengalaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  expImagePath.isNotEmpty
                      ? Image.file(File(expImagePath), height: 150, width: double.infinity, fit: BoxFit.cover)
                      : Container(height: 150, color: Colors.grey[300], child: const Center(child: Icon(Icons.image, size: 50))),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(expJudul, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(expDeskripsi),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HALAMAN EDIT PROFILE
// ============================================================================
class EditProfilePage extends StatefulWidget {
  final String imagePath, tentang, pendidikan, lokasi, kontak;

  const EditProfilePage({super.key, required this.imagePath, required this.tentang, required this.pendidikan, required this.lokasi, required this.kontak});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _tentangController;
  late TextEditingController _pendidikanController;
  late TextEditingController _lokasiController;
  late TextEditingController _kontakController;
  String _currentImagePath = '';

  @override
  void initState() {
    super.initState();
    _tentangController = TextEditingController(text: widget.tentang);
    _pendidikanController = TextEditingController(text: widget.pendidikan);
    _lokasiController = TextEditingController(text: widget.lokasi);
    _kontakController = TextEditingController(text: widget.kontak);
    _currentImagePath = widget.imagePath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _currentImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: InkWell(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _currentImagePath.isNotEmpty ? FileImage(File(_currentImagePath)) : null,
                child: _currentImagePath.isEmpty ? const Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(controller: _tentangController, decoration: const InputDecoration(labelText: 'Tentang', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _pendidikanController, decoration: const InputDecoration(labelText: 'Pendidikan', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _lokasiController, decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _kontakController, decoration: const InputDecoration(labelText: 'Kontak', border: OutlineInputBorder())),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'image': _currentImagePath,
                'tentang': _tentangController.text,
                'pendidikan': _pendidikanController.text,
                'lokasi': _lokasiController.text,
                'kontak': _kontakController.text,
              });
            },
            child: const Text('Simpan'),
          )
        ],
      ),
    );
  }
}

// ============================================================================
// HALAMAN EDIT PENGALAMAN
// ============================================================================
class EditPengalamanPage extends StatefulWidget {
  final String imagePath, judul, deskripsi;

  const EditPengalamanPage({super.key, required this.imagePath, required this.judul, required this.deskripsi});

  @override
  State<EditPengalamanPage> createState() => _EditPengalamanPageState();
}

class _EditPengalamanPageState extends State<EditPengalamanPage> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  String _currentImagePath = '';

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.judul);
    _deskripsiController = TextEditingController(text: widget.deskripsi);
    _currentImagePath = widget.imagePath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _currentImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengalaman')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InkWell(
            onTap: _pickImage,
            child: Container(
              height: 150,
              color: Colors.grey[300],
              child: _currentImagePath.isNotEmpty
                  ? Image.file(File(_currentImagePath), fit: BoxFit.cover)
                  : const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.add_a_photo, size: 40), Text('Pilih Gambar Pengalaman')],
              )),
            ),
          ),
          const SizedBox(height: 20),
          TextField(controller: _judulController, decoration: const InputDecoration(labelText: 'Judul Pengalaman', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _deskripsiController, maxLines: 3, decoration: const InputDecoration(labelText: 'Deskripsi Singkat', border: OutlineInputBorder())),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'image': _currentImagePath,
                'judul': _judulController.text,
                'deskripsi': _deskripsiController.text,
              });
            },
            child: const Text('Simpan Pengalaman'),
          )
        ],
      ),
    );
  }
}