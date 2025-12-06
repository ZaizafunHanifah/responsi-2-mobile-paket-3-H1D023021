import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class UpdateBookScreen extends StatefulWidget {
  final Book book;

  const UpdateBookScreen({super.key, required this.book});

  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulController;
  late final TextEditingController _hargaController;
  late final TextEditingController _jumlahController;
  late final TextEditingController _tanggalMasukController;
  late final TextEditingController _volumeController;
  late final TextEditingController _penulisController;
  late final TextEditingController _penerbitController;
  final BookService _bookService = BookService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.book.judul);
    _hargaController = TextEditingController(text: widget.book.harga.toString());
    _jumlahController = TextEditingController(text: widget.book.jumlah.toString());
    _tanggalMasukController = TextEditingController(text: widget.book.tanggalMasuk);
    _volumeController = TextEditingController(text: widget.book.volume.toString());
    _penulisController = TextEditingController(text: widget.book.penulis);
    _penerbitController = TextEditingController(text: widget.book.penerbit);
  }

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

  Future<void> _updateBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedBook = Book(
        id: widget.book.id,
        judul: _judulController.text,
        harga: int.parse(_hargaController.text),
        jumlah: int.parse(_jumlahController.text),
        tanggalMasuk: _tanggalMasukController.text,
        volume: int.parse(_volumeController.text),
        penulis: _penulisController.text,
        penerbit: _penerbitController.text,
      );

      final response = await _bookService.updateBook(widget.book.id!, updatedBook);

      if (response.status == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book updated successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update book')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update book')),
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
        title: const Text('Update Inventaris Buku Zaza'),
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
                  onPressed: _isLoading ? null : _updateBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Update Book'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}