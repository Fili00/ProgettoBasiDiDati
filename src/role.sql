CREATE ROLE Utente;
GRANT SELECT, UPDATE, INSERT ON "ProgettoBD".Utente TO Utente;
GRANT SELECT ON "ProgettoBD".Squadra, "ProgettoBD".Sfida, "ProgettoBD".Gioco TO Utente;

CREATE ROLE Giocatore;
GRANT Utente TO Giocatore;
GRANT SELECT, INSERT ON "ProgettoBD".ApprovaRispostaQuiz, "ProgettoBD".RispostaTask, "ProgettoBD".SceltaRispostaQuiz,
    "ProgettoBD".Squadra, "ProgettoBD".Tiro TO Giocatore;
GRANT SELECT ON ALL TABLES IN SCHEMA "ProgettoBD" TO Giocatore;
REVOKE SELECT ON "ProgettoBD".CambiaDadiRispostaQuiz FROM Giocatore; 

CREATE ROLE Gameadmin;
GRANT Giocatore TO Gameadmin;
GRANT ALL ON "ProgettoBD".Appartiene, "ProgettoBD".ApprovaRispostaQuiz, "ProgettoBD".Possiede, "ProgettoBD".RispostaTask, 
    "ProgettoBD".SceltaRispostaQuiz, "ProgettoBD".Sfida, "ProgettoBD".SiTrova, "ProgettoBD".SiTrovaPodio, "ProgettoBD".Squadra,
    "ProgettoBD".Tiro, "ProgettoBD".Turno TO Gameadmin WITH GRANT OPTION;

CREATE ROLE Gamecreator;
GRANT ALL ON ALL TABLES IN SCHEMA "ProgettoBD" TO Gamecreator WITH GRANT OPTION;
REVOKE ALL ON "ProgettoBD".Utente FROM Gamecreator;
GRANT Gameadmin TO Gamecreator;