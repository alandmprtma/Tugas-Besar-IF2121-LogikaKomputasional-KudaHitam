% fakta neighboring
neighboring(au1,au2).
neighboring(au2,au1).
neighboring(a6,au1).
neighboring(au1,a6).
neighboring(a6,a7).
neighboring(a7,a6).
neighboring(a6,a2).
neighboring(a2,a6).
neighboring(a6,a5).
neighboring(a5,a6).
neighboring(a6,a4).
neighboring(a4,a6).
neighboring(a4,a5).
neighboring(a5,a4).
neighboring(a4,a2).
neighboring(a2,a4).
neighboring(a2,a5).
neighboring(a5,a2).
neighboring(a5,a3).
neighboring(a3,a5).
neighboring(a1,a4).
neighboring(a4,a1).
neighboring(a3,na1).
neighboring(na1,a3).
neighboring(a3,na3).
neighboring(na3,a3).
neighboring(na1,na2).
neighboring(na2,na1).
neighboring(na1,na3).
neighboring(na3,na1).
neighboring(na3,na4).
neighboring(na4,na3).
neighboring(na4,na2).
neighboring(na2,na4).
neighboring(na2,na5).
neighboring(na5,na2).
neighboring(na4,na5).
neighboring(na5,na4).
neighboring(na5,e1).
neighboring(e1,na5).
neighboring(e1,e2).
neighboring(e2,e1).
neighboring(e1,e3).
neighboring(e3,e1).
neighboring(e3,e4).
neighboring(e4,e3).
neighboring(e4,e2).
neighboring(e2,e4).
neighboring(e2,a1).
neighboring(a1,e2).
neighboring(e4,e5).
neighboring(e5,e4).
neighboring(e4,af2).
neighboring(af2,e4).
neighboring(e5,af2).
neighboring(af2,e5).
neighboring(e5,a4).
neighboring(a4,e5).
neighboring(af2,af3).
neighboring(af3,af2).
neighboring(af2,af1).
neighboring(af1,af2).
neighboring(af3,af1).
neighboring(af1,af3).
neighboring(af1,e3).
neighboring(e3,af1).
neighboring(af1,sa2).
neighboring(sa2,af1).
neighboring(sa2,sa1).
neighboring(sa1,sa2).
neighboring(sa1,na3).
neighboring(na3,sa1).
neighboring(sa2,au2).
neighboring(au2,sa2).

:- dynamic(already_attack/1).

% Untuk melakukan enumerasi list Neighbor
enumerate(List, Start) :-
    enumerate(List, Start, _).

enumerate([], N, N).
enumerate([H|T], N, M) :-
    current_player(Current),
    format('~d. ~w', [N, H]), nl,
    N1 is N + 1,
    enumerate(T, N1, M).

% Predikat untuk melempar dadu
putarDaduAttack(NumRolls, Total, IDplayer) :-
    putarDaduAttack(NumRolls, 1, 0, Total, IDplayer).

putarDaduAttack(0, _, Total, Total, IDplayer) :-
    format('Total: ~d.\n', [Total]).

putarDaduAttack(NumRolls, RollNum, SubTotal, Total, IDplayer) :-
    \+ risk_card(IDplayer, 2),
    \+ risk_card(IDplayer, 5),
    random(1, 7, Roll),
    format('Dadu ~d: ~d.\n', [RollNum, Roll]),
    NewSubTotal is SubTotal + Roll,
    NewNumRolls is NumRolls - 1,
    NewRollNum is RollNum + 1,
    putarDaduAttack(NewNumRolls, NewRollNum, NewSubTotal, Total, IDplayer).

putarDaduAttack(NumRolls, RollNum, SubTotal, Total, IDplayer) :-
    risk_card(IDplayer, 5),
    Roll is 1,
    format('Dadu ~d: ~d.\n', [RollNum, Roll]),
    NewSubTotal is SubTotal + Roll,
    NewNumRolls is NumRolls - 1,
    NewRollNum is RollNum + 1,
    putarDaduAttack(NewNumRolls, NewRollNum, NewSubTotal, Total, IDplayer).

putarDaduAttack(NumRolls, RollNum, SubTotal, Total, IDplayer) :-
    risk_card(IDplayer, 2),
    Roll is 6,
    format('Dadu ~d: ~d.\n', [RollNum, Roll]),
    NewSubTotal is SubTotal + Roll,
    NewNumRolls is NumRolls - 1,
    NewRollNum is RollNum + 1,
    putarDaduAttack(NewNumRolls, NewRollNum, NewSubTotal, Total, IDplayer).

% Predikat untuk mendapatkan daerah attacker yang valid
getAttackerArea(PlayerName, Attacker) :-
    % Mencari semua area milik player dengan army lebih dari 1
    findall(Area, (locationOccupier(PlayerName, Area), armyCount(Area, ArmyCount), ArmyCount > 1), OwnedAreas),

    % DDisplay area-area yang valid
    write('Daerah yang valid untuk penyerangan: '), nl,
    enumerate(OwnedAreas, 1),
    write('\n'),
        
    % Menanyakan daerah mana yang mau attacking
    write('Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(TempAttacker),
    (   member(TempAttacker, OwnedAreas)
    ->  Attacker = TempAttacker
    ;   write('Daerah tidak valid. Silahkan input kembali.\n'),
        getAttackerArea(PlayerName, Attacker)
    ).

% Predikat untuk mendapatkan jumlah tentara yang valid
getValidNumTroops(AttackerArmies, PlayerName, NumTroops) :-
    write('Masukkan banyak tentara yang akan bertempur: '),
    read(TempNumTroops),
    (   TempNumTroops < AttackerArmies,
        TempNumTroops > 0
    ->  NumTroops = TempNumTroops
    ;   write('Banyak tentara tidak valid. Silahkan input kembali.\n'),
        getValidNumTroops(AttackerArmies, PlayerName, NumTroops)
    ).

% Predikat untuk exclude
exclude(_, [], []).
exclude(Pred, [H|T], R) :-
    (   call(Pred, H)
    ->  exclude(Pred, T, R)
    ;   exclude(Pred, T, RT),
        R = [H|RT]
    ).

% Predikat untuk mendapatkan daerah defender yang valid
getValidDefenderArea(PlayerName, Neighbors, Defender) :-
    write('Pilihlah daerah yang ingin Anda serang: '), nl,
    % Memfilter daerah yang tidak dimiliki oleh player attacker
    exclude(locationOccupier(PlayerName), Neighbors, ValidNeighbors),
    enumerate(ValidNeighbors, 1),
    write('\nPilih: '),
    read(Choice),nl,
    (   nth1(Choice, ValidNeighbors, TempDefender)
    ->  Defender = TempDefender
    ;   write('Input tidak valid. Silahkan input kembali.\n'),
        getValidDefenderArea(PlayerName, ValidNeighbors, Defender)
    ).
 
% Predikat Untuk melakukan penyerangan
attack :-
    already_attack(1) -> write('Player hanya bisa menyerang sekali dalam setiap turn.'), nl;
    % Mendapatkan nama dari pemain yang sedang bermain
    current_player(Current),
    player(Current, PlayerName, Army),

    write('\nSekarang giliran Player '), write(PlayerName), 
    write(' menyerang.\n'), nl,

    % Memanggil peta
    displayMap,
    nl,

    % Mendapatkan daerah attacker
    getAttackerArea(Current, Attacker),

    % Menampilkan pesan attacking
    format('\nPlayer ~w ingin memulai penyerangan dari daerah ~w. \n', [PlayerName, Attacker]),
     
    % Pengecheckan apakah daerah tersebut memiliki lebih dari 1 tentara
    armyCount(Attacker, AttackerArmies),
    AttackerArmies > 1,
    format('Dalam daerah ~w, Anda memiliki sebanyak ~d tentara. \n\n', [Attacker,AttackerArmies]),

    % Mendapatkan jumlah tentara yang akan digunakan untuk menyerang
    getValidNumTroops(AttackerArmies, Current, NumTroops),

    % Menampilkan pesan pasukan attacking
    format('Player ~w mengirim sebanyak ~d tentara untuk berperang.\n\n', [PlayerName, NumTroops]),

    % Memanggil peta
    displayMap,nl,

    % Mendapatkan list daerah yang bersebelahan dengan daerah attacker
    findall(Neighbor, neighboring(Attacker, Neighbor), Neighbors),

    % Mendapatkan daerah defender
    getValidDefenderArea(Current, Neighbors, Defender),
 
    locationOccupier(DefenderPlayer, Defender),
    (risk_card(DefenderPlayer, 1) -> write('Kamu tidak bisa menyerang wilayah itu karena pemilik wilayah itu memiliki risk card Ceasefire Order.'), nl;

    printrisk(Current,PlayerName),
    printrisk(DefenderPlayer, DefenderName),
    % Menampilkan pesan perang
    write('Perang telah dimulai.'),nl,
    % Menampilkan nama player attack
    format('Player ~w\n', [PlayerName]),
    % Putar dadu attacker
    putarDaduAttack(NumTroops,AttackerTotal, Current),

    % Dapatkan nama pemain defender
    locationOccupier(DefenderPlayer, Defender),

    player(DefenderPlayer, DefenderName, DefenderArmy),

    % Menampilkan nama player defender
    format('Player ~w\n', [DefenderName]),

    % Putar dadu defender
    armyCount(Defender, DefenderArmies),
    putarDaduAttack(DefenderArmies, DefenderTotal, DefenderPlayer),
    nl,

    retractall(already_attack(_)),
    asserta(already_attack(1)),

    % Mencari pemenang perang
    (   % Jika attacker menang
        AttackerTotal > DefenderTotal
    ->  % Eliminasi tentara defender
        retract(armyCount(Defender, _)),
        % Ganti kepemilikan
        retract(locationOccupier(_, Defender)),
        asserta(locationOccupier(Current, Defender)),
        format('\nPlayer ~w menang! Wilayah ~w sekarang dikuasai oleh Player ~w.\n', [PlayerName, Defender, PlayerName]),
        % Bertanya kepada player berapa tentara yang ingin dipindahkan
        write('Silahkan tentukan banyaknya tentara yang menetap di wilayah '), write(Defender), write(': '),
        read(NumTroopsToMove),nl,
        % memindahkan tentara
        NewAttackerArmies is AttackerArmies - NumTroopsToMove,
        retract(armyCount(Attacker, _)),
        asserta(armyCount(Attacker, NewAttackerArmies)),
        asserta(armyCount(Defender, NumTroopsToMove)),
        % menampilkan jumlah tentara di setiap wilayah
        format('Tentara di wilayah ~w: ~d.\n', [Attacker, NewAttackerArmies]),
        format('Tentara di wilayah ~w: ~d.\n', [Defender, NumTroopsToMove])
    ;   % Jika defender menang
        % Mengurangi jumlah tentara attacker
        AttackerArmiesAfterLoss is AttackerArmies - NumTroops,
        retract(armyCount(Attacker, _)),
        asserta(armyCount(Attacker, AttackerArmiesAfterLoss)),
        format('\nPlayer ~w menang! Sayang sekali penyerangan Anda gagal :(.\n\n', [DefenderName]),nl,
        % Menampilkan jumlah tentara di setiap wilayah
        armyCount(Defender, DefenderArmies),
        format('Tentara di wilayah ~w: ~d.\n', [Attacker, AttackerArmiesAfterLoss]),
        format('Tentara di wilayah ~w: ~d.\n', [Defender, DefenderArmies])
    )),
    checkWorldDomination.

printrisk(IDplayer, NamaPlayer) :-
    risk_card(IDplayer, 2),
    format('Tentara ~w dalam pengaruh SUPER SOLDIER SERUM.\n\n', [NamaPlayer]).

printrisk(IDplayer, NamaPlayer) :-
    risk_card(IDplayer, 5),
    format('Tentara ~w dalam pengaruh DISEASE OUTBREAK.\n\n', [NamaPlayer]).

%Case default apabila tidak ada risk card
printrisk(_, _).
