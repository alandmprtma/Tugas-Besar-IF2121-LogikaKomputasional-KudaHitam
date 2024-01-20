 continent(na1, 'NorthAmerica').
  continent(na2, 'NorthAmerica').
  continent(na3, 'NorthAmerica').
  continent(na4, 'NorthAmerica').
  continent(na5, 'NorthAmerica').

  continent(e1,'Eropa').
  continent(e2,'Eropa').
  continent(e3,'Eropa').
  continent(e4,'Eropa').
  continent(e5,'Eropa').

  continent(a1,'Asia').
  continent(a2,'Asia').
  continent(a3,'Asia').
  continent(a4,'Asia').
  continent(a5,'Asia').
  continent(a6,'Asia').
  continent(a7,'Asia').

  continent(sa1,'SouthAmerica').
  continent(sa2,'SouthAmerica').

  continent(af1,'Africa').
  continent(af2,'Africa').
  continent(af3,'Africa').

  continent(au1,'Australia').
  continent(au2,'Australia').


% Fungsi untuk memeriksa detail pemain
checkPlayerDetail(PlayerID) :-
    player(PlayerID, PlayerName, AdditionalTroops),
    countActiveTroops(PlayerID, TotalTroops),
    countTotalLocations(PlayerID, TotalLocations),
    getPlayerContinents(PlayerID, Continents),
    unique_elements(Continents, UniqueContinents),
    write('PLAYER '), write(PlayerID), nl,
    write('Nama                  : '), write(PlayerName), nl,
    write('Benua                 : '), printContinents(UniqueContinents),
    write('Total Wilayah         : '), write(TotalLocations), nl,
    write('Total Tentara Aktif   : '), write(TotalTroops), nl,
    write('Total Tentara Tambahan: '), write(AdditionalTroops), nl,
    nl.

% Predikat untuk menghasilkan elemen-elemen unik dari suatu list
unique_elements([], []). % Basis: list kosong memiliki elemen unik yang juga kosong
unique_elements([H | T], Unique) :-
    member(H, T),         % Jika elemen H terdapat dalam sisa list (T),
    unique_elements(T, Unique). % lewati H dan lanjutkan ke sisa list
unique_elements([H | T], [H | Unique]) :-
    \+ member(H, T),      % Jika elemen H tidak terdapat dalam sisa list (T),
    unique_elements(T, Unique). % tambahkan H ke dalam daftar elemen unik dan lanjutkan ke sisa list

% Fungsi untuk mencetak daftar benua yang dikuasai
printContinents([]) :- nl.
printContinents([Continent]) :-
    write(Continent), nl.
printContinents([Continent|Rest]) :-
    write(Continent), write(', '),
    printContinents(Rest).

% Fungsi untuk menghitung total tentara aktif pemain
countActiveTroops(PlayerID, TotalTroops) :-
    findall(Army, (locationOccupier(PlayerID, Location), armyCount(Location, Army)), Armies),
    sum_list(Armies, TotalTroops).

% Fungsi untuk menghitung total tentara tambahan pemain
countAdditionalTroops(PlayerID, AdditionalTroops) :-
    findall(X, locationOccupier(PlayerID, X), OccupiedList),
    length(OccupiedList, OccupiedLocation),
    (risk_card(PlayerID, 3) -> AdditionalTroops is OccupiedLocation//2 + OccupiedLocation//2
    ;AdditionalTroops is OccupiedLocation//2).

% Fungsi untuk menghitung total wilayah yang dikuasai pemain
countTotalLocations(PlayerID, TotalLocations) :-
    findall(_, locationOccupier(PlayerID, _), Locations),
    length(Locations, TotalLocations).

% Fungsi untuk mengecek apakah seorang pemain menguasai suatu benua
playerOwnsContinent(PlayerID, Continent) :-
    findall(Location, continent(Location, Continent), Locations),
    playerOwnsLocations(PlayerID, Locations).

% Fungsi untuk mengecek apakah seorang pemain menguasai semua lokasi dalam suatu daftar lokasi
playerOwnsLocations(_, []).
playerOwnsLocations(PlayerID, [Location|Rest]) :-
    locationOccupier(PlayerID, Location),
    playerOwnsLocations(PlayerID, Rest).

% Fungsi untuk mendapatkan daftar benua yang dimiliki oleh seorang pemain
getPlayerContinents(PlayerID, OwnedContinents) :-
    findall(Continent, (continent(_, Continent), playerOwnsContinent(PlayerID, Continent)), OwnedContinents).

% Fungsi untuk mencetak daftar benua yang dimiliki oleh seorang pemain
printPlayerContinents(PlayerID) :-
    getPlayerContinents(PlayerID, OwnedContinents),
    write('Benua yang Dimiliki oleh Player '), write(PlayerID), write(': '), nl,
    printList(OwnedContinents).

% Fungsi untuk mencetak elemen-elemen dalam sebuah list
printList([]) :- nl.
printList([X|Xs]) :-
    write(X), write(', '),
    printList(Xs).
    
% Fungsi untuk mendapatkan wilayah-wilayah berdasarkan benua
player_territories(PlayerID, TerritoriesByContinent) :-
    findall(Continent-Territories, (
        locationOccupier(PlayerID, Location),
        continent(Location, Continent),
        [Location] = Territories
    ), TerritoriesByContinent).

% Fungsi untuk menghitung jumlah wilayah yang dimiliki pemain di suatu benua
countOwnedLocations(PlayerID, Continent, Count) :-
    findall(Location, (locationOccupier(PlayerID, Location), continent(Location, Continent)), Locations),
    length(Locations, Count).

% Fungsi untuk memperbarui wilayah-wilayah berdasarkan benua
update_territories([]).
update_territories([Continent-Territories|Rest]) :-
    asserta(select_continent_territories(Continent, Territories)),
    update_territories(Rest).

% Fungsi untuk memilih wilayah-wilayah berdasarkan benua
select_continent_territories(Continent, Territories, UpdatedTerritories) :-
    select_continent_territories(Continent, Territories, UpdatedTerritories, []).

% Fungsi untuk memilih wilayah-wilayah berdasarkan benua
select_continent_territories(Continent, Territories, UpdatedTerritories, Acc) :-
    select_continent_territories_aux(Continent, Territories, UpdatedTerritories, Acc),
    clear_select_continent_territories.

% Fungsi bantu untuk memilih wilayah-wilayah berdasarkan benua
select_continent_territories_aux(_, [], UpdatedTerritories, Acc) :-
    reverse(Acc, UpdatedTerritories).
select_continent_territories_aux(Continent, [Location|Rest], UpdatedTerritories, Acc) :-
    retract(select_continent_territories(Continent, Territories)),
    append(Territories, [Location], UpdatedTerritories),
    select_continent_territories_aux(Continent, Rest, UpdatedTerritories, Acc).

% Fakta untuk menyimpan wilayah-wilayah yang sudah diproses
:- dynamic(select_continent_territories/2).

% Menghapus semua fakta terkait wilayah-wilayah yang sudah diproses
clear_select_continent_territories :-
    retractall(select_continent_territories(_,_)).

% Fungsi untuk menyoroti teritori yang dikuasai oleh seorang pemain
checkPlayerTerritories(PlayerID) :-
    player(PlayerID, PlayerName, _),
    player_territories(PlayerID, OwnedLocations),
    sort(OwnedLocations, SortedLocations),
    write('Nama              : '), write(PlayerName), nl,
    printContinentTerritories(PlayerID, SortedLocations),
    nl.

% Fungsi untuk mencetak wilayah-wilayah yang dimiliki pemain di setiap benua
printContinentTerritories(_, []).
printContinentTerritories(PlayerID, [Continent-Territories|Rest]) :-
    findall(Location, continent(Location, Continent), AllLocations),
    length(AllLocations, TotalContinentLocations),
    findall(Location, (locationOccupier(PlayerID, Location), continent(Location, Continent)), OwnedLocations),
    length(OwnedLocations, OwnedContinentLocations),
    write('Benua '), write(Continent), write(' ('), write(OwnedContinentLocations), write('/'), write(TotalContinentLocations), write(')'), nl,
    printAreaDetails(PlayerID, Territories),
    nl,
    printContinentTerritories(PlayerID, Rest).

% Fungsi untuk mencetak detail setiap wilayah
printAreaDetails(_, []).
printAreaDetails(PlayerID, [Area|Rest]) :-
    armyCount(Area, ArmyCount),
    findNameLocation(Area, AreaName),
    write(Area), nl,
    write('Nama              : '), write(AreaName), nl,
    write('Jumlah tentara    : '), write(ArmyCount), nl,
    printAreaDetails(PlayerID, Rest).


% Fungsi untuk menentukan pemain menang
checkWinner :-
    findall(PlayerID, player(PlayerID, _, 0), Losers),
    length(Losers, NumLosers),
    player_count(PlayerCount),
    NumLosers == PlayerCount - 1,
    write('******************************'), nl,
    write('*Player '), winner(PlayerID), write(' telah menguasai dunia*'), nl,
    write('******************************'), nl,
    halt.

% Fungsi untuk menentukan pemain kalah
checkLoser :-
    findall(PlayerID, player(PlayerID, _, 0), Losers),
    member(Loser, Losers),
    retract(player(Loser, LoserName, _)),
    write('Jumlah wilayah Player '), write(LoserName), write(' 0.'), nl,
    write('Player '), write(LoserName), write(' keluar dari permainan!'), nl,
    retract(player_count(PlayerCount)),
    NewPlayerCount is PlayerCount - 1,
    asserta(player_count(NewPlayerCount)),
    checkWinner.

% Fungsi untuk menang dalam serangan
attackResult(Winner, Loser, Location, NumTroops) :-
    retract(locationOccupier(Loser, Location)),
    asserta(locationOccupier(Winner, Location)),
    retract(armyCount(Location, _)),
    asserta(armyCount(Location, NumTroops)),
    write('Player '), write(Winner), write(' menang! Wilayah '), write(Location),
    write(' sekarang dikuasai oleh Player '), write(Winner), write('.'), nl,
    write('Silahkan tentukan banyaknya tentara yang menetap di wilayah '), write(Location), write(': '),
    read(NewTroops),
    asserta(armyCount(Location, NewTroops)),
    writeTroopDistribution(Winner, Location),
    writeTroopDistribution(Loser, Location),
    checkLoser.

% Fungsi untuk menuliskan distribusi tentara di wilayah
writeTroopDistribution(PlayerID, Location) :-
    armyCount(Location, Troops),
    write('Tentara di wilayah '), write(Location), write(' ('), write(PlayerID), write('): '), write(Troops), write('.'), nl.

% Fungsi untuk menentukan pemenang dan kalah dalam serangan
resolveAttack(Winner, Loser, Location, NumTroops) :-
    attackResult(Winner, Loser, Location, NumTroops),
    checkLoser,
    checkWinner.

% Fungsi untuk menentukan pemenang dan kalah saat menyerang wilayah terakhir
resolveLastAttack(Winner, Loser, Location, NumTroops) :-
    attackResult(Winner, Loser, Location, NumTroops),
    checkLoser,
    write('******************************'), nl,
    write('*Player '), write(Winner), write(' telah menguasai dunia*'), nl,
    write('******************************'), nl,
    halt.

% Fungsi untuk menampilkan jumlah tentara yang akan masuk pada giliran selanjutnya
checkIncomingTroops(PlayerID) :-
    player(PlayerID, PlayerName, _),
    countTotalLocations(PlayerID, TotalLocations),
    countAdditionalTroops(PlayerID, AdditionalTroops),
    calculateNABonus(NABonus, PlayerID),
    calculateEBonus(EBonus, PlayerID),
    calculateABonus(ABonus, PlayerID),
    calculateSABonus(SABonus, PlayerID),
    calculateAFBonus(AFBonus, PlayerID),
    calculateAUBonus(AUBonus, PlayerID),
    TotalIncomingTroops is AdditionalTroops + NABonus + EBonus + ABonus + SABonus + AFBonus + AUBonus,
    write('Nama                                    : '), write(PlayerName), nl,
    write('Total wilayah                           : '), write(TotalLocations), nl,
    write('Jumlah tentara tambahan dari wilayah    : '), write(AdditionalTroops), nl,
    writeContinentBonus(PlayerID),
    write('Total tentara tambahan                  : '), write(TotalIncomingTroops), nl,
    nl.

writeContinentBonus(PlayerID) :-
    calculateNABonus(NABonus, PlayerID),
    calculateEBonus(EBonus, PlayerID),
    calculateABonus(ABonus, PlayerID),
    calculateSABonus(SABonus, PlayerID),
    calculateAFBonus(AFBonus, PlayerID),
    calculateAUBonus(AUBonus, PlayerID),
    
    (NABonus \= 0 -> write('Bonus benua North America               : '), write(NABonus), nl ; true),
    (EBonus \= 0 ->  write('Bonus benua Europe                      : '), write(EBonus), nl ; true),
    (ABonus \= 0 ->  write('Bonus benua Asia                        : '), write(ABonus), nl ; true),
    (SABonus \= 0 -> write('Bonus benua South America               : '), write(SABonus), nl ; true),
    (AFBonus \= 0 -> write('Bonus benua Africa                      : '), write(AFBonus), nl ; true),
    (AUBonus \= 0 -> write('Bonus benua Australia                   : '), write(AUBonus), nl ; true).

% Fungsi untuk mengecek apakah semua wilayah sudah dikuasai oleh satu pemain
checkWorldDomination :-
    findall(PlayerID, player(PlayerID, _, _), Players),
    checkDomination(Players).

% Fungsi rekursif untuk mengecek domniasi pemain pada setiap wilayah
checkDomination([]) :-
    write('Belum ada pemain yang menguasai dunia.'), nl.
checkDomination([PlayerID|Rest]) :-
    (dominated(PlayerID) -> 
        player(PlayerID, PlayerName, _),
        write('******************************'), nl,
        write('*'), 
        write(PlayerName), 
        write(' telah menguasai dunia*'), nl,
        write('******************************'), nl,
        true;
    checkDomination(Rest)).

% Fungsi untuk mengecek apakah seorang pemain telah menguasai dunia
dominated(PlayerID) :-
    findall(Location, locationOccupier(PlayerID, Location), OwnedLocations),
    countLocations(TotalLocations),
    length(OwnedLocations, TotalOwnedLocations),
    (TotalOwnedLocations == TotalLocations -> true; fail).

% Fungsi untuk menghitung total wilayah yang dikuasai oleh pemain
countLocations(Count) :-
    findall(Location, locationOccupier(_, Location), Locations),
    length(Locations, Count).
