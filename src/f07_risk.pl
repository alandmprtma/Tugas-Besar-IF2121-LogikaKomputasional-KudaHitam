% Risk
% Rule
%risk.
% Memberikan risk card kepada player yang sedang bermain.

%:- dynamic risk/1.
:- dynamic(risk_card/2).
:- dynamic(risk_taken/1).

risk :-
    risk_taken(1) -> write('Player hanya bisa mengambil sekali risk setiap turn.'), nl;
    current_player(P),
    random(1, 7, Roll),
    retractall(risk_taken(_)),
    asserta(risk_taken(1)),
    generate_risk_card(P, Roll). 

% Risk card
generate_risk_card(P, 1) :-
    asserta(risk_card(P, 1)),
    player(P, Nama, _),
    write('Player '), write(Nama), write(' mendapatkan risk card CEASEFIRE ORDER.'), nl,
    write('Hingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.'), nl.

generate_risk_card(P, 2) :-
    asserta(risk_card(P, 2)),
    player(P, Nama, _),
    write('Player '), write(Nama), write(' mendapatkan risk card SUPER SOLDIER SERUM.'), nl,
    write('Hingga giliran berikutnya, semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.'), nl.

generate_risk_card(P, 3) :-
    asserta(risk_card(P, 3)),
    player(P, Nama, _),
    write('Player '), write(Nama), write(' mendapatkan risk card AUXILIARY TROOPS.'), nl,
    write('Pada giliran berikutnya, Tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.'), nl.

generate_risk_card(P, 4) :-
    asserta(risk_card(P, 4)),
    player(P, Nama, _),
    write('Player '), write(Nama), write(' mendapatkan risk card REBELLION.'), nl,
    write('Salah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.'),nl, nl,
    % randomize territory
    random_territory(P, Territory),
    random_player(P, Enemy),
    change_ownership(Territory, P, Enemy).

generate_risk_card(P, 5) :-
    asserta(risk_card(P, 5)),
    player(P, Nama, _),
    write('Player '), write(Nama), write(' mendapatkan risk card DISEASE OUTBREAK.'), nl,
    write('Hingga giliran berikutnya, semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1.'), nl.

generate_risk_card(P, 6) :-
    asserta(risk_card(P, 6)),
    player(P, Nama, _),
    write('Player '), write(Nama), write(' mendapatkan risk card SUPPLY CHAIN ISSUE.'), nl,
    write('Pada giliran berikutnya, pemain tidak mendapatkan tentara tambahan.'), nl.
    
random_territory(P, Territory) :-
    findall(T, locationOccupier(P, T), Territories),
    random_member(Territory, Territories).

random_player(CurrentPlayer, OtherPlayer) :-
    findall(P, (locationOccupier(P, _), P \= CurrentPlayer), Players),
    random_member(OtherPlayer, Players).

change_ownership(Territory, P, Enemy) :-
    retract(locationOccupier(P, Territory)),
    asserta(locationOccupier(Enemy, Territory)),
    player(Enemy, NamaE, _),
    write('Wilayah '), write(Territory), write(' sekarang dikuasai oleh Player '), write(NamaE), write('.'), nl.

