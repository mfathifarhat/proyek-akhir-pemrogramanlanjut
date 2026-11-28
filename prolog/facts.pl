% --- DIRECTIVES ---
% Mencegah warning/error jika suatu saat ada fakta yang kosong atau terpisah
:- discontiguous cpu/4, cpu_supported_ram/2, motherboard/4, ram/4, psu/3, stock/2, price/2, direct_substitute/2.

% --- BIAYA JASA RAKIT ---
assembly_fee(250000).

% --- CPU: cpu(ID, Nama, Socket, TDP) ---
cpu('c001', 'Intel Core i5-12400', 'LGA1700', 65).
cpu('c004', 'AMD Ryzen 5 5600', 'AM4', 65).
cpu('c006', 'Intel Core i5-13400F', 'LGA1700', 65).
cpu('c007', 'Intel Core i3-12100F', 'LGA1700', 58).

% --- CPU SUPPORTED RAM: cpu_supported_ram(CpuID, TipeRAM) ---
cpu_supported_ram('c001', 'DDR4').
cpu_supported_ram('c004', 'DDR4').
cpu_supported_ram('c006', 'DDR4').
cpu_supported_ram('c006', 'DDR5').
cpu_supported_ram('c007', 'DDR4').

% --- MOTHERBOARD: motherboard(ID, Nama, Socket, TipeRAM) ---
motherboard('c101', 'MSI PRO B660M-A', 'LGA1700', 'DDR4').
motherboard('c102', 'ASRock H610M-HVS', 'LGA1700', 'DDR4').
motherboard('c103', 'ASUS Prime B550M-K', 'AM4', 'DDR4').

% --- RAM: ram(ID, Nama, Tipe, KecepatanMHz) ---
ram('c201', 'Corsair Vengeance 16GB', 'DDR4', 3200).
ram('c202', 'Kingston Fury 8GB', 'DDR4', 3200).
ram('c203', 'Team Elite 16GB', 'DDR5', 4800).

% --- PSU: psu(ID, Nama, DayaWatt) ---
psu('c301', 'Generic 200W', 200).          % Sengaja kecil untuk tes gagal daya
psu('c302', 'Corsair CV550', 550).
psu('c303', 'FSP HV PRO 450W', 450).

% --- STOK GUDANG: stock(ID, QtyAvailable) ---
stock('c001', 5).
stock('c004', 0).    % Habis -> memicu pencarian substitute
stock('c006', 3).
stock('c007', 4).
stock('c101', 2).
stock('c102', 5).
stock('c103', 3).
stock('c201', 6).
stock('c202', 8).
stock('c203', 4).
stock('c301', 10).
stock('c302', 4).
stock('c303', 5).

% --- HARGA JUAL: price(ID, HargaJual) ---
price('c001', 2200000).
price('c004', 1850000).
price('c006', 2800000).
price('c007', 1450000).
price('c101', 1750000).
price('c102', 1150000).
price('c103', 1400000).
price('c201', 650000).
price('c202', 350000).
price('c203', 950000).
price('c301', 250000).
price('c302', 750000).
price('c303', 550000).

% --- RELASI PENGGANTI: direct_substitute(ID_Asal, ID_Pengganti) ---
% Rantai: c004 -> c006 -> c001, plus siklus balik c001 -> c004 untuk menguji Visited list
direct_substitute('c004', 'c006').
direct_substitute('c006', 'c001').
direct_substitute('c001', 'c004').