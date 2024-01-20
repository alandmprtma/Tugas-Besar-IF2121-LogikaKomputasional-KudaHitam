% Fungsi untuk memeriksa detail wilayah
checkLocationDetail(Location) :-
    locationOccupier(PlayerID, Location),
    armyCount(Location, ArmyCount),
    player(PlayerID, PlayerName, _),
    findNameLocation(Location, NamaLokasi),
    write('Kode                  : '), write(Location), nl,
    write('Nama                  : '), write(NamaLokasi), nl, % Gantilah ini dengan nama sesuai kebutuhan
    write('Pemilik               : '), write(PlayerName), nl,
    write('Total Tentara         : '), write(ArmyCount), nl,
    write('Tetangga              : '),
    findall(Neighbor, neighboring(Location, Neighbor), Neighbors),
    printNeighbors(Neighbors).

% Fungsi untuk mencetak daftar tetangga
printNeighbors([]) :- nl.
printNeighbors([Neighbor]) :-
    write(Neighbor), nl.
printNeighbors([Neighbor|Rest]) :-
    write(Neighbor), write(', '),
    printNeighbors(Rest).


%fakta
findNameLocation(na1, 'Canada').
findNameLocation(na2, 'America').
findNameLocation(na3, 'Mexico').
findNameLocation(na4, 'Cuba').
findNameLocation(na5, 'Dominican Republic').
findNameLocation(sa1, 'Brazil').
findNameLocation(sa2, 'Argentina').
findNameLocation(e1, 'United Kingdom').
findNameLocation(e2, 'Germany').
findNameLocation(e3, 'Portugal').
findNameLocation(e4, 'Italy').
findNameLocation(e5, 'Bulgaria').
findNameLocation(af1, 'Guinea').
findNameLocation(af2, 'Chad').
findNameLocation(af3, 'Congo').
findNameLocation(a1, 'Kazakhstan').
findNameLocation(a2, 'Russia').
findNameLocation(a3, 'Japan').
findNameLocation(a4, 'Afghanistan').
findNameLocation(a5, 'China').
findNameLocation(a6, 'Indonesia').
findNameLocation(a7, 'Papua New Guinea').
findNameLocation(au1, 'Port Hedland').
findNameLocation(au2, 'Sydney').

%trollololololol
rick :-
    write('Never gonna give you up~'),nl,
    write('Never gonna let you down~'),nl,
    write('Never gonna run around and dessert you~'),nl,nl,
    write('lain kali jangan typo ya :)'),
    nl.