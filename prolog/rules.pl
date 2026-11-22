% Memuat file fakta secara otomatis saat rules.pl di-consult
:- consult('facts.pl').

% =========================================================================
% R1: valid_build/4
% Mengecek kompatibilitas teknis antara CPU, Motherboard, RAM, dan PSU
% =========================================================================
valid_build(Cpu, Mobo, Ram, Psu) :-
    cpu(Cpu, _, Socket, Tdp),
    motherboard(Mobo, _, Socket, RamType),
    cpu_supported_ram(Cpu, RamType),
    ram(Ram, _, RamType, _),
    psu(Psu, _, Watt),
    MinWatt is Tdp + 150,
    Watt >= MinWatt.

% =========================================================================
% R2: build_issue/5
% Mengembalikan alasan spesifik jika kombinasi komponen tidak kompatibel
% =========================================================================
build_issue(Cpu, Mobo, _, _, 'Socket CPU dan motherboard tidak cocok') :-
    cpu(Cpu, _, CpuSocket, _),
    motherboard(Mobo, _, MoboSocket, _),
    CpuSocket \= MoboSocket.

build_issue(Cpu, Mobo, _, _, 'Tipe RAM motherboard tidak didukung oleh CPU') :-
    cpu(Cpu, _, _, _),
    motherboard(Mobo, _, _, MoboRamType),
    \+ cpu_supported_ram(Cpu, MoboRamType).

build_issue(_, Mobo, Ram, _, 'Tipe RAM tidak cocok dengan slot motherboard') :-
    motherboard(Mobo, _, _, MoboRamType),
    ram(Ram, _, RamType, _),
    MoboRamType \= RamType.

build_issue(Cpu, _, _, Psu, 'Daya PSU kurang dari kebutuhan minimum (TDP CPU + 150W)') :-
    cpu(Cpu, _, _, Tdp),
    psu(Psu, _, Watt),
    MinWatt is Tdp + 150,
    Watt < MinWatt.

% =========================================================================
% R3: affordable_build/5
% Mencari kombinasi valid, stok tersedia (> 0), dan total harga + jasa <= Budget
% =========================================================================
affordable_build(Budget, Cpu, Mobo, Ram, Psu) :-
    valid_build(Cpu, Mobo, Ram, Psu),
    % Pastikan semua stok tersedia
    stock(Cpu, SCpu), SCpu > 0,
    stock(Mobo, SMobo), SMobo > 0,
    stock(Ram, SRam), SRam > 0,
    stock(Psu, SPsu), SPsu > 0,
    % Hitung total harga komponen + biaya jasa rakit
    price(Cpu, PCpu),
    price(Mobo, PMobo),
    price(Ram, PRam),
    price(Psu, PPsu),
    assembly_fee(Fee),
    Total is PCpu + PMobo + PRam + PPsu + Fee,
    Total =< Budget.

% =========================================================================
% R4: substitute/2 (Rekursif + Pencegahan Siklus dengan Visited List)
% Mencari pengganti langsung maupun pengganti bertingkat yang stoknya > 0
% =========================================================================
substitute(Awal, Pengganti) :-
    substitute_helper(Awal, Pengganti, [Awal]).

% Base Case: Ditemukan pengganti langsung yang stoknya tersedia
substitute_helper(Awal, Pengganti, Visited) :-
    direct_substitute(Awal, Pengganti),
    \+ member(Pengganti, Visited),
    stock(Pengganti, Qty),
    Qty > 0.

% Recursive Case: Telusuri pengganti dari pengganti (meski simpul perantara stoknya 0)
substitute_helper(Awal, Pengganti, Visited) :-
    direct_substitute(Awal, Sementara),
    \+ member(Sementara, Visited),
    substitute_helper(Sementara, Pengganti, [Sementara | Visited]).