/*
Tampilan Peta Dunia
#################################################################################################
#         North America         #        Europe         #                 Asia                  #
#                               #                       #                                       #
#       [NA1(4)]-[NA2(1)]       #                       #                                       #
-----------|       |----[NA5(2)]----[E1(11)]-[E2(4)]----------[A1(1)] [A2(13)] [A3(3)]-----------
#       [NA3(3)]-[NA4(1)]       #       |       |       #        |       |       |              #
#          |                    #    [E3(3)]-[E4(2)]    ####     |       |       |              #
###########|#####################       |       |-[E5(2)]-----[A4(3)]----+----[A5(4)]           #
#          |                    ########|#######|###########             |                      #
#       [SA1(11)]               #       |       |          #             |                      #
#          |                    #       |    [AF2(14)]     #          [A6(1)]---[A7(2)]         #
#   |---[SA2(2)]---------------------[AF1(3)]---|          #             |                      #
#   |                           #               |          ##############|#######################
#   |                           #            [AF3(2)]      #             |                      #
----|                           #                          #          [AU1(7)]---[AU2(13)]-------
#                               #                          #                                    #
#       South America           #         Africa           #          Australia                 #
#################################################################################################
*/

displayMap :- 
    armyCount(na1, JumlahNA1),
    armyCount(na2, JumlahNA2),
    armyCount(na3, JumlahNA3),
    armyCount(na4, JumlahNA4),
    armyCount(na5, JumlahNA5),
    armyCount(e1, JumlahE1),
    armyCount(e2, JumlahE2),
    armyCount(e3, JumlahE3),
    armyCount(e4, JumlahE4),
    armyCount(e5, JumlahE5),
    armyCount(a1, JumlahA1),
    armyCount(a2, JumlahA2),
    armyCount(a3, JumlahA3),
    armyCount(a4, JumlahA4),
    armyCount(a5, JumlahA5),
    armyCount(a6, JumlahA6),
    armyCount(a7, JumlahA7),
    armyCount(sa1, JumlahSA1),
    armyCount(sa2, JumlahSA2),
    armyCount(af1, JumlahAF1),
    armyCount(af2, JumlahAF2),
    armyCount(af3, JumlahAF3),
    armyCount(au1, JumlahAU1),
    armyCount(au2, JumlahAU2),
    format('#################################################################################################', []), nl,
    format('#         North America         #        Europe         #                 Asia                  #', []), nl,
    format('#                               #                       #                                       #', []), nl,
    format('#       [NA1(~d)]-[NA2(~d)]       #                       #                                       #', [JumlahNA1, JumlahNA2]), nl,
    format('-----------|       |----[NA5(~d)]----[E1(~d)]-[E2(~d)]----------[A1(~d)] [A2(~d)] [A3(~d)]-----------', [JumlahNA5,JumlahE1,JumlahE2,JumlahA1, JumlahA2, JumlahA3]), nl,
    format('#       [NA3(~d)]-[NA4(~d)]       #       |       |       #        |       |       |              #', [JumlahNA3, JumlahNA4]), nl,
    format('#          |                    #    [E3(~d)]-[E4(~d)]    ####     |       |       |              #', [JumlahE3, JumlahE4]), nl,
    format('###########|#####################       |       |-[E5(~d)]-----[A4(~d)]----+----[A5(~d)]           #', [JumlahE5, JumlahA4, JumlahA5]), nl,
    format('#          |                    ########|#######|###########             |                      #', []), nl,
    format('#       [SA1(~d)]               #       |       |          #             |                      #', [JumlahSA1]), nl,
    format('#          |                    #       |    [AF2(~d)]     #          [A6(~d)]---[A7(~d)]         #', [JumlahAF2, JumlahA6, JumlahA7]), nl,
    format('#   |---[SA2(~d)]---------------------[AF1(~d)]---|          #             |                      #', [JumlahSA2,JumlahAF1]), nl,
    format('#   |                           #               |          ##############|#######################', []), nl,
    format('#   |                           #            [AF3(~d)]      #             |                      #', [JumlahAF3]), nl,
    format('----|                           #                          #          [AU1(~d)]---[AU2(~d)]-------', [JumlahAU1, JumlahAU2]), nl,
    format('#                               #                          #                                    #', []), nl,
    format('#       South America           #         Africa           #          Australia                 #', []), nl,
    format('#################################################################################################', []), nl.