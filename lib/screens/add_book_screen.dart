import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalMasukController = TextEditingController();
  final _volumeController = TextEditingController();
  final _penulisController = TextEditingController();
  final _penerbitController = TextEditingController();
  final BookService _bookService = BookService();
  bool _isLoading = false;

  @override
  void dispose() {
    _judulController.dispose();
    _hargaController.dispose();
    _jumlahController.dispose();
    _tanggalMasukController.dispose();
    _volumeController.dispose();
    _penulisController.dispose();
    _penerbitController.dispose();
    super.dispose();
  }

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final book = Book(
        judul: _judulController.text,
        harga: int.parse(_hargaController.text),
        jumlah: int.parse(_jumlahController.text),
        tanggalMasuk: _tanggalMasukController.text,
        volume: int.parse(_volumeController.text),
        penulis: _penulisController.text,
        penerbit: _penerbitController.text,
      );

      final response = await _bookService.createBook(book);

      if (response.status == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book added successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add book')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add book')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Inventaris Buku Zaza'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title, color: Colors.brown),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter judul';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money, color: Colors.brown),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter harga';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter valid harga';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers, color: Colors.brown),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter jumlah';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Please enter valid jumlah';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalMasukController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Masuk (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.brown),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tanggal masuk';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _volumeController,
                decoration: const InputDecoration(
                  labelText: 'Volume',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.format_list_numbered, color: Colors.brown),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter volume';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter valid volume';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penulisController,
                decoration: const InputDecoration(
                  labelText: 'Penulis',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.brown),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter penulis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penerbitController,
                decoration: const InputDecoration(
                  labelText: 'Penerbit',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business, color: Colors.brown),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter penerbit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Book'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}