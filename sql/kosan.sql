-- Hapus database jika sudah ada untuk memastikan instalasi bersih.
-- BERHATI-HATILAH: Perintah ini akan menghapus semua data jika database 'kos_db' sudah ada.
-- Jalankan ini hanya jika Anda ingin memulai dari awal.
-- DROP DATABASE IF EXISTS kos_db;

-- Buat database baru jika belum ada
CREATE DATABASE IF NOT EXISTS kos_db;

-- Gunakan database yang baru dibuat
USE kos_db;

-- Tabel untuk menyimpan informasi kamar
CREATE TABLE IF NOT EXISTS kamar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kamar VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('kosong', 'terisi') NOT NULL DEFAULT 'kosong',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan informasi penyewa
CREATE TABLE IF NOT EXISTS penyewa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kamar_id INT NOT NULL,
    nama VARCHAR(100) NOT NULL,
    ktp VARCHAR(20) NULL,
    no_telepon VARCHAR(20) NULL,
    tanggal_masuk DATE NOT NULL,
    harga_sewa DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (kamar_id) REFERENCES kamar(id) ON DELETE CASCADE
);

-- Tabel untuk menyimpan informasi pembayaran
CREATE TABLE IF NOT EXISTS pembayaran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    penyewa_id INT NOT NULL,
    bulan_tahun VARCHAR(7) NOT NULL, -- Format YYYY-MM (e.g., 2024-07)
    jumlah_bayar DECIMAL(10, 2) NOT NULL,
    tanggal_bayar DATE NULL, -- Tanggal pembayaran bisa null jika belum lunas
    tanggal_tenggat DATE NULL, -- Tanggal tenggat pembayaran
    status ENUM('lunas', 'belum_lunas', 'tenggat') NOT NULL DEFAULT 'belum_lunas',
    keterangan TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (penyewa_id) REFERENCES penyewa(id) ON DELETE CASCADE,
    UNIQUE(penyewa_id, bulan_tahun) -- Memastikan satu pembayaran per bulan per penyewa
);


-- --- Reset Data Dummy (Penting: Urutan TRUNCATE harus dari anak ke induk) ---
-- Ini akan mengosongkan semua data dari tabel dan mereset auto-increment ID.
-- Hapus baris-baris TRUNCATE di bawah ini jika Anda ingin mempertahankan data yang sudah ada
-- dan hanya menambahkan data baru atau memperbarui skema tabel.
TRUNCATE TABLE pembayaran; -- 1. Hapus data pembayaran terlebih dahulu (anak dari penyewa)
TRUNCATE TABLE penyewa;    -- 2. Hapus data penyewa kedua (anak dari kamar)
TRUNCATE TABLE kamar;      -- 3. Hapus data kamar terakhir (induk)


-- --- Memasukkan Data Awal (Dummy Data) ---

-- Data dummy untuk tabel 'kamar'
INSERT INTO kamar (nama_kamar, status) VALUES
('Kamar A1', 'kosong'),
('Kamar A2', 'terisi'),
('Kamar B1', 'terisi'),
('Kamar B2', 'kosong'),
('Kamar C1', 'kosong'),
('Kamar C2', 'terisi');

-- Data dummy untuk tabel 'penyewa'
-- ID penyewa akan otomatis ter-generate (misal: 1, 2, 3)
INSERT INTO penyewa (kamar_id, nama, ktp, no_telepon, tanggal_masuk, harga_sewa) VALUES
(2, 'Budi Santoso', '3578011234567890', '081234567890', '2024-03-20', 500000.00),
(3, 'Siti Aminah', '3578020987654321', '085678901234', '2024-01-10', 550000.00),
(6, 'Joko Susanto', '3578034567890123', '087765432109', '2024-06-01', 600000.00);

-- Data dummy untuk tabel 'pembayaran'
-- Pastikan penyewa_id sesuai dengan ID yang dihasilkan dari INSERT penyewa di atas.
-- Jika TRUNCATE penyewa dijalankan, ID penyewa akan dimulai dari 1 lagi.
-- Misal: Budi Santoso -> penyewa_id 1, Siti Aminah -> penyewa_id 2, Joko Susanto -> penyewa_id 3

-- Pembayaran untuk Budi Santoso (penyewa_id: 1, jika baru di-TRUNCATE)
INSERT INTO pembayaran (penyewa_id, bulan_tahun, jumlah_bayar, tanggal_bayar, tanggal_tenggat, status) VALUES
(1, '2024-03', 500000.00, '2024-03-18', '2024-03-20', 'lunas'),
(1, '2024-04', 500000.00, '2024-04-19', '2024-04-20', 'lunas'),
(1, '2024-05', 500000.00, '2024-05-17', '2024-05-20', 'lunas'),
(1, '2024-06', 500000.00, NULL, '2024-06-20', 'belum_lunas'),
(1, '2024-07', 500000.00, NULL, '2024-07-20', 'belum_lunas');

-- Pembayaran untuk Siti Aminah (penyewa_id: 2, jika baru di-TRUNCATE)
INSERT INTO pembayaran (penyewa_id, bulan_tahun, jumlah_bayar, tanggal_bayar, tanggal_tenggat, status) VALUES
(2, '2024-01', 550000.00, '2024-01-05', '2024-01-20', 'lunas'),
(2, '2024-02', 550000.00, '2024-02-03', '2024-02-20', 'lunas'),
(2, '2024-03', 550000.00, '2024-03-01', '2024-03-20', 'lunas'),
(2, '2024-04', 550000.00, '2024-04-04', '2024-04-20', 'lunas'),
(2, '2024-05', 550000.00, '2024-05-02', '2024-05-20', 'lunas'),
(2, '2024-06', 550000.00, '2024-06-05', '2024-06-20', 'lunas'),
(2, '2024-07', 550000.00, NULL, '2024-07-20', 'belum_lunas');

-- Pembayaran untuk Joko Susanto (penyewa_id: 3, jika baru di-TRUNCATE)
INSERT INTO pembayaran (penyewa_id, bulan_tahun, jumlah_bayar, tanggal_bayar, tanggal_tenggat, status) VALUES
(3, '2024-06', 600000.00, '2024-06-03', '2024-06-20', 'lunas'),
(3, '2024-07', 600000.00, NULL, '2024-07-20', 'belum_lunas');