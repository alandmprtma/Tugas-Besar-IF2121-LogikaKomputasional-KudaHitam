draft(Location, N) :-
	current_player(Current),
	player(Current, Name, Army),
	(\+ locationOccupier(Current, Location) -> write('Player '), write(Name), write(' tidak memiliki wilayah '), write(Location), write('.'), nl);
	(current_player(Current), player(Current, Name, Army), armyCount(Location, S),
	Army < N -> write('Pasukan tidak mencukupi.'), nl,
	write('Jumlah pasukan tambahan player '), write(Name), write(': '), write(Army), nl,
	write('Draft dibatalkan.'), nl
	;current_player(Current), player(Current, Name, Army), armyCount(Location, S),
	write('Player '), write(Name), write(' meletakkan '), write(N), write(' tentara tambahan di '), write(Location), write('.'), nl,
	AddedArmy is S + N, Sisa is Army - N,
	write('Tentara total di '), write(Location), write(': '), write(AddedArmy), nl,
	write('Jumlah pasukan tambahan player '), write(Name), write(': '), write(Sisa),
	retract(player(Current, Name, Army)),
	retract(armyCount(Location, S)),
	asserta(player(Current, Name, Sisa)),
	asserta(armyCount(Location, AddedArmy))).
