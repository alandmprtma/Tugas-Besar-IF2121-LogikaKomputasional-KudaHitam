% End Turn
% Fakta
:- dynamic(hasilDadu/1).

putarDadu :-
    random(1, 13, N),
    asserta(hasilDadu(N)).

endTurn :-
    retractall(risk_taken(_)),
    asserta(risk_taken(0)),
    retractall(already_attack(_)),
    asserta(already_attack(0)),
    retractall(move_counter(_)),
    asserta(move_counter(0)),
    current_player(Current),
    player(Current, Name, Army),
    write('Player '), write(Name), write(' mengakhiri giliran.'), nl,
    nextPlayer,
    current_player(Next),
    player(Next, NextName, NextArmy),
    write('Sekarang giliran player '), write(NextName), write('!.'), nl,
    calculateNABonus(NABonus),
    calculateEBonus(EBonus),
    calculateABonus(ABonus),
    calculateSABonus(SABonus),
    calculateAFBonus(AFBonus),
    calculateAUBonus(AUBonus),
    findall(X, locationOccupier(Next, X), OccupiedList),
    length(OccupiedList, OccupiedLocation),
    ConBonus is NABonus + EBonus + ABonus + SABonus + AFBonus + AUBonus,
    (risk_card(Next, 3) -> Bonus is OccupiedLocation//2 + ConBonus + OccupiedLocation//2 + ConBonus, write('Jumlah tentara tambahan bernilai 2 kali lipat karena memiliki risk card Auxiliary Troops!'), nl, retract(risk_card(Next, 3))
    ;risk_card(Next, 6) -> Bonus is 0, write('Pemain tidak mendapatkan tentara tambahan karena memiliki risk card Supply Chain Issue!'), nl, retract(risk_card(Next, 6))
    ;Bonus is OccupiedLocation//2 + ConBonus),
    BonusArmy is NextArmy + Bonus,
    retract(player(Next, NextName, NextArmy)),
    asserta(player(Next, NextName, BonusArmy)),
    write('Player '), write(NextName), write(' mendapatkan '), write(Bonus), write(' tentara tambahan.'), nl.

calculateNABonus(Result) :- % bonus jika menguasai amerika utara
    (current_player(Current),
    player(Current, Name, Army),
    locationOccupier(Current, na1),
    locationOccupier(Current, na2),
    locationOccupier(Current, na3),
    locationOccupier(Current, na4),
    locationOccupier(Current, na5) -> Result is 3; Result is 0).

calculateEBonus(Result) :- % bonus jika menguasai eropa
    (current_player(Current),
    player(Current, Name, Army),
    locationOccupier(Current, e1),
    locationOccupier(Current, e2),
    locationOccupier(Current, e3),
    locationOccupier(Current, e4),
    locationOccupier(Current, e5) -> Result is 3; Result is 0).

calculateABonus(Result) :- % bonus jika menguasai asia
    (current_player(Current),
    player(Current, Name, Army),
    locationOccupier(Current, a1),
    locationOccupier(Current, a2),
    locationOccupier(Current, a3),
    locationOccupier(Current, a4),
    locationOccupier(Current, a5),
    locationOccupier(Current, a6),
    locationOccupier(Current, a7) -> Result is 5; Result is 0).

calculateSABonus(Result) :- % bonus jika menguasai amerika selatan
    (current_player(Current),
    player(Current, Name, Army),
    locationOccupier(Current, sa1),
    locationOccupier(Current, sa2) -> Result is 2; Result is 0).

calculateAFBonus(Result) :- % bonus jika menguasai afrika
    (current_player(Current),
    player(Current, Name, Army),
    locationOccupier(Current, af1),
    locationOccupier(Current, af2),
    locationOccupier(Current, af3) -> Result is 2; Result is 0).

calculateAUBonus(Result) :- % bonus jika menguasai australia
    (current_player(Current),
    player(Current, Name, Army),
    locationOccupier(Current, au1),
    locationOccupier(Current, au2) -> Result is 1; Result is 0).

calculateAUBonus(Result, Current) :- % bonus jika menguasai australia
    (current_player(Current),
    player(Current, Name, Army),
    locationOccupier(Current, au1),
    locationOccupier(Current, au2) -> Result is 1; Result is 0).

calculateNABonus(Result, Current) :- % bonus jika menguasai amerika utara
    (player(Current, Name, Army),
    locationOccupier(Current, na1),
    locationOccupier(Current, na2),
    locationOccupier(Current, na3),
    locationOccupier(Current, na4),
    locationOccupier(Current, na5) -> Result is 3; Result is 0).

calculateEBonus(Result, Current) :- % bonus jika menguasai eropa
    (player(Current, Name, Army),
    locationOccupier(Current, e1),
    locationOccupier(Current, e2),
    locationOccupier(Current, e3),
    locationOccupier(Current, e4),
    locationOccupier(Current, e5) -> Result is 3; Result is 0).

calculateABonus(Result, Current) :- % bonus jika menguasai asia
    (player(Current, Name, Army),
    locationOccupier(Current, a1),
    locationOccupier(Current, a2),
    locationOccupier(Current, a3),
    locationOccupier(Current, a4),
    locationOccupier(Current, a5),
    locationOccupier(Current, a6),
    locationOccupier(Current, a7) -> Result is 5; Result is 0).

calculateSABonus(Result, Current) :- % bonus jika menguasai amerika selatan
    (player(Current, Name, Army),
    locationOccupier(Current, sa1),
    locationOccupier(Current, sa2) -> Result is 2; Result is 0).

calculateAFBonus(Result, Current) :- % bonus jika menguasai afrika
    (player(Current, Name, Army),
    locationOccupier(Current, af1),
    locationOccupier(Current, af2),
    locationOccupier(Current, af3) -> Result is 2; Result is 0).

calculateAUBonus(Result, Current) :- % bonus jika menguasai australia
    (player(Current, Name, Army),
    locationOccupier(Current, au1),
    locationOccupier(Current, au2) -> Result is 1; Result is 0).
