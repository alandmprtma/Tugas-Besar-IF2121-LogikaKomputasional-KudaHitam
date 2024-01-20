% keterangan : Player itu id , PlayerName itu nama

:- dynamic(move_counter/1).

% Predikat untuk memindahkan tentara
% Predikat untuk memindahkan tentara
move(WilayahAsal, WilayahTujuan, JumlahPindah) :-
    move_counter(3) -> write('Player hanya bisa melakukan move sebanyak 3 kali dalam setiap turn.'), nl;
    current_player(Current),
    player(Current, PlayerName, Army),
    (   locationOccupier(Current, WilayahAsal),
        locationOccupier(Current, WilayahTujuan)
    -> % Mengecheck apakah jumlah pindah valid
        (   number(JumlahPindah),
            JumlahPindah > 0,
            armyCount(WilayahAsal, JumlahTentaraAwal),
            JumlahPindah < JumlahTentaraAwal,
            JumlahTentaraAwal - JumlahPindah >= 1
        -> % Pindahkan tentara
            retract(armyCount(WilayahAsal, JumlahTentaraAwal)),
            JumlahTentaraAkhirAwal is JumlahTentaraAwal - JumlahPindah,
            asserta(armyCount(WilayahAsal, JumlahTentaraAkhirAwal)),
            
            % Tambahkan tentara ke wilayah tujuan
            retract(armyCount(WilayahTujuan, JumlahTentaraTujuan)),
            JumlahTentaraAkhirTujuan is JumlahTentaraTujuan + JumlahPindah,
            asserta(armyCount(WilayahTujuan, JumlahTentaraAkhirTujuan)),
            format('\nPlayer ~w memindahkan ~d tentara dari ~w ke ~w.\n\n', [PlayerName, JumlahPindah, WilayahAsal, WilayahTujuan]),

            % Print jumlah tentara di wilayah asal dan tujuan
            armyCount(WilayahAsal, JumlahTentaraAkhirAwal),
            armyCount(WilayahTujuan, JumlahTentaraAkhirTujuan),
            format('Jumlah tentara di ~w: ~d\n', [WilayahAsal, JumlahTentaraAkhirAwal]),
            format('Jumlah tentara di ~w: ~d\n', [WilayahTujuan, JumlahTentaraAkhirTujuan]),

            move_counter(Counter),
            retractall(move_counter(_)),
            NewCounter is Counter + 1,
            asserta(move_counter(NewCounter))
        ;   % Invalid number of armies
            write('\nTentara tidak mencukupi.\npemindahan dibatalkan.\n'),
            fail
        )
    ;   % Area tidak valid
        format('\n~w tidak memiliki wilayah ~w.\npemindahan dibatalkan.\n', [PlayerName, WilayahAsal]),
        fail
    ).