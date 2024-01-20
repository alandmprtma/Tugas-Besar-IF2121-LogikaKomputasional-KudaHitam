:- include('sortorder_initiating.pl').

% Fakta dinamis untuk menyimpan status pemain
:- dynamic(player/3). % parameter 1: id pemain. parameter 2: nama pemain. parameter 3: jlh tentara
:- dynamic(turn_order/1).
:- dynamic(current_player/1).
:- dynamic(player_count/1).
:- dynamic(diceResult/2). % parameter 1: id pemain. parameter 2: hasil putaran dadunya
:- dynamic(locationOccupier/2). % parameter 1: id pemain. parameter 2: wilayah yg dikuasainya
:- dynamic(armyCount/2). % parameter 1: nama wilayah. parameter 2: jumlah tentara

% list wilayah
locationOccupier(0, na1).
locationOccupier(0, na2).
locationOccupier(0, na3).
locationOccupier(0, na4).
locationOccupier(0, na5).
locationOccupier(0, e1).
locationOccupier(0, e2).
locationOccupier(0, e3).
locationOccupier(0, e4).
locationOccupier(0, e5).
locationOccupier(0, a1).
locationOccupier(0, a2).
locationOccupier(0, a3).
locationOccupier(0, a4).
locationOccupier(0, a5).
locationOccupier(0, a6).
locationOccupier(0, a7).
locationOccupier(0, sa1).
locationOccupier(0, sa2).
locationOccupier(0, af1).
locationOccupier(0, af2).
locationOccupier(0, af3).
locationOccupier(0, au1).
locationOccupier(0, au2).

% Predikat untuk memulai permainan
startGame :-
    asserta(risk_taken(0)),
    asserta(move_counter(0)),
    asserta(already_attack(0)),
    write('Masukkan jumlah pemain (antara 2 - 4): '),
    read(PlayerCount),
    PlayerCount > 1, PlayerCount < 5, !, initializePlayers(PlayerCount), asserta(player_count(PlayerCount)), playGame;
    write('Mohon masukkan angka antara 2 - 4.'), nl,
    startGame.

% Predikat untuk menginisialisasi pemain
initializePlayers(PlayerCount) :-
    retractall(player(_, _, _)),
    retractall(turn_order(_)),
    retractall(current_player(_)),
    assertz(turn_order([])),
    assertz(current_player(1)),
    initializePlayersLoop(1, PlayerCount).

initializePlayersLoop(Current, PlayerCount) :-
    Current =< PlayerCount,
    PlayerCount == 4,
    write('Masukkan nama pemain '), write(Current), write(': '),
    read(PlayerName),
    assertz(player(Current, PlayerName, 12)),
    assertz(turn_order([])),
    Next is Current + 1,
    initializePlayersLoop(Next, PlayerCount).
initializePlayersLoop(Current, PlayerCount) :-
    Current =< PlayerCount,
    PlayerCount == 3,
    write('Masukkan nama pemain '), write(Current), write(': '),
    read(PlayerName),
    assertz(player(Current, PlayerName, 16)),
    assertz(turn_order([])),
    Next is Current + 1,
    initializePlayersLoop(Next, PlayerCount).
initializePlayersLoop(Current, PlayerCount) :-
    Current =< PlayerCount,
    PlayerCount == 2,
    write('Masukkan nama pemain '), write(Current), write(': '),
    read(PlayerName),
    assertz(player(Current, PlayerName, 24)),
    assertz(turn_order([])),
    Next is Current + 1,
    initializePlayersLoop(Next, PlayerCount).

initializePlayersLoop(_, _).

createOrder(N, [N]) :- player_count(PlayerCount), N == PlayerCount.
createOrder(N, [N | Rest]) :-
    player_count(PlayerCount),
    N < PlayerCount,
    Next is N + 1,
    createOrder(Next, Rest).

% Aturan untuk memastikan hasil roll unik untuk setiap pemain
unique_roll(N, Roll) :-
    \+ (diceResult(_, Roll)), % Pastikan tidak ada hasil roll yang sama
    asserta(diceResult(N, Roll)). % Simpan hasil roll
% ini utk membuat fakta hasil rolling dadu
rollOrder(N, [N]) :- % basis ketika isi order tinggal 1
    player_count(PlayerCount),
    N == PlayerCount,
    random(1, 13, Roll),
    unique_roll(N, Roll).
rollOrder(N, [N | Rest]) :- 
    player_count(PlayerCount),
    N < PlayerCount,
    random(1, 13, Roll),
    unique_roll(N, Roll),
    Next is N + 1,
    rollOrder(Next, Rest).

% Fungsi utk mencetak hasil putaran dadu masing2 player
printRoll(N, [N]) :- % ini basis
    player_count(PlayerCount),
    N == PlayerCount,
    player(N, PlayerName, Soldier),
    diceResult(N, DiceValue),
    write(PlayerName), write(' melempar dadu dan mendapatkan '), write(DiceValue), write('.'), nl.
printRoll(N, [N | Rest]) :- 
    player_count(PlayerCount),
    N < PlayerCount,
    player(N, PlayerName, Soldier),
    diceResult(N, DiceValue),
    write(PlayerName), write(' melempar dadu dan mendapatkan '), write(DiceValue), write('.'), nl,
    Next is N + 1,
    printRoll(Next, Rest).

% Predikat untuk memulai permainan
playGame :-
    player_count(PlayerCount),
    createOrder(1, Order),
    rollOrder(1, Order),
    printRoll(1, Order),
    retractall(turn_order(_)),
    sortOrder,
    turn_order(SortedOrder), !,
    write('Urutan pemain: '),
    printTurnOrder(SortedOrder),
    nl,
    playTurn.

% Predikat untuk menampilkan urutan pemain
printTurnOrder([Player]) :-
    player(Player, Name, _),
    write(Name).
printTurnOrder([Player|Rest]) :-
    player(Player, Name, _),
    write(Name), write(' - '),
    printTurnOrder(Rest).

% Predikat untuk memulai giliran permainan
playTurn :-
    turn_order([Current|Rest]),
    retractall(current_player(_)),
    assertz(current_player(Current)),
    player(Current, Name, Tentara),
    write(Name), write(' dapat mulai terlebih dahulu.'), nl,
    nl,
    write('Setiap pemain mendapatkan '),
    write(Tentara),
    write(' tentara.'), nl,
    nl, !,
    chooseTerritory.

% Predikat untuk memilih wilayah
chooseTerritory :-
    current_player(Current),
    player(Current, Name, Armies),
    write('Giliran '), write(Name), write(' untuk memilih wilayahnya.'), nl.

rotate_list([], []). % fungsi rotasi itu untuk mutar giliran
rotate_list([X | Xs], RotatedList) :-
    append(Xs, [X], RotatedList).

takeLocation(Location) :-
    \+ locationOccupier(_, Location),
    write('Wilayah itu tidak ada.'), nl,
    chooseTerritory.
takeLocation(Location) :-
    \+ locationOccupier(0, Location),
    write('Wilayah tidak bisa diambil karena sudah dikuasai.'), nl,
    chooseTerritory.
takeLocation(Location) :-
    locationOccupier(0, Location),
    current_player(Current),
    player(Current, Name, Army),
    retract(locationOccupier(0, Location)),
    asserta(locationOccupier(Current, Location)),
    write(Name), write(' mengambil wilayah '), write(Location), nl,
    asserta(armyCount(Location, 1)),
    Sisa is Army-1,
    retract(player(Current, Name, Army)),
    asserta(player(Current, Name, Sisa)),
    takeLocationHandler.

takeLocationHandler :-
    \+ locationOccupier(0, _),
    nextPlayer,
    write('Seluruh wilayah telah diambil pemain.'), nl,
    write('Masing-masing pemain otomatis meletakkan satu tentara pada wilayah mereka.'), nl,
    write('Memulai pembagian sisa tentara.'), nl,
    placeTroopsPrint.
takeLocationHandler :-
    locationOccupier(0, _),
    nextPlayer, chooseTerritory.

% Predikat untuk beralih ke pemain berikutnya
nextPlayer :-
    turn_order(Order),
    rotate_list(Order, [Head|Tail]),
    retractall(current_player(_)),
    retractall(turn_order(_)),
    asserta(current_player(Head)),
    asserta(turn_order([Head|Tail])).

placeTroopsHandler :-
    player_count(PlayerCount),
    PlayerCount == 2,
    player(1, _, 0),
    player(2, _, 0),
    nextPlayer,
    write('Seluruh pemain telah meletakkan sisa tentara.'), nl, write('Memulai permainan.'), nl.
placeTroopsHandler :-
    player_count(PlayerCount),
    PlayerCount == 3,
    player(1, _, 0),
    player(2, _, 0),
    player(3, _, 0),
    nextPlayer,
    write('Seluruh pemain telah meletakkan sisa tentara.'), nl, write('Memulai permainan.'), nl.
placeTroopsHandler :-
    player_count(PlayerCount),
    PlayerCount == 4,
    player(1, _, 0),
    player(2, _, 0),
    player(3, _, 0),
    player(4, _, 0),
    nextPlayer,
    write('Seluruh pemain telah meletakkan sisa tentara.'), nl, write('Memulai permainan.'), nl.

placeTroopsPrint :-
    current_player(Current),
    player(Current, Name, Armies),
    write('Giliran '), write(Name), write(' untuk meletakkan tentaranya.'), nl.

placeTroopsInputZero :-
    current_player(Current),
    player(Current, Name, Army).

placeTroops(Location, N) :-
    current_player(Current),
    player(Current, Name, Army),
    locationOccupier(Occupier, Location),
    (Current \= Occupier -> write('Kamu tidak bisa meletakkan tentara di wilayah yang tidak kamu kuasai.'), nl;
    N =< 0 -> write('Jumlah tentara yang dimasukkan harus lebih besar dari nol.'), nl;
    Army > 0, Army < N,
    write('Jumlah tentara tidak cukup.'), nl,
    write('Sisa tentara dari '), write(Name), write(' adalah '), write(Army), nl,
    placeTroopsPrint).
placeTroops(Location, N) :-
    current_player(Current),
    player(Current, Name, Army),
    Army > 0, Army > N,
    locationOccupier(Current, Location),
    retract(armyCount(Location, _)),
    asserta(armyCount(Location, N)),
    write(Name), write(' meletakkan '), write(N), write(' tentara di wilayah '), write(Location), write('.'), nl,
    Sisa is Army-N,
    write('Terdapat '), write(Sisa), write(' tentara yang tersisa.'), nl,
    placeTroopsPrint,
    retract(player(Current, Name, Army)), 
    asserta(player(Current, Name, Sisa)).
placeTroops(Location, N) :-
    current_player(Current),
    player(Current, Name, Army),
    Army == N,
    locationOccupier(Current, Location),
    retract(armyCount(Location, _)),
    asserta(armyCount(Location, N)),
    write(Name), write(' meletakkan '), write(N), write(' tentara di wilayah '), write(Location), write('.'), nl,
    Sisa is Army-N,
    write('Seluruh tentara '), write(Name), write(' sudah diletakkan.'), nl,
    retract(player(Current, Name, Army)), 
    asserta(player(Current, Name, Sisa)),
    nextPlayer, 
    placeTroopsHandler;
    placeTroopsPrint.

randomLocation(X) :-
    current_player(Current),
    findall(Y, locationOccupier(Current, Y), Locations),
    random_member(X, Locations).

random_member(X, List) :-
    length(List, Length),
    Length > 0,
    random(0, Length, Index),
    nth0(Index, List, X).

placeAutomatic :-
    current_player(Current),
    player(Current, Name, Army), 
    ArmyTemp is Army+1,
    random(1, ArmyTemp, N),
    randomLocation(Location),
    armyCount(Location, BeforeArmy),
    AfterArmy is N + BeforeArmy,
    retract(armyCount(Location, BeforeArmy)),
    asserta(armyCount(Location, AfterArmy)),
    write(Name), write(' meletakkan '), write(N), write(' tentara di wilayah '), write(Location), write('.'), nl,
    Sisa is Army-N,
    retract(player(Current, Name, Army)), 
    asserta(player(Current, Name, Sisa)),
    (Sisa > 0 -> placeAutomatic;
    write('Seluruh tentara '), write(Name), write(' sudah diletakkan.'), nl,
    placeTroopsHandler;
    nextPlayer, placeTroopsPrint).
