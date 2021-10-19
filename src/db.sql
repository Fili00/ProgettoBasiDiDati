----------CREAZIONE DELLO SCHEMA LOGICO
CREATE SCHEMA "ProgettoBD";
SET search_path TO "ProgettoBD";
SET datestyle TO "MDY"; -- Vedere (forse cambiare tutte le date)

--Tuple: 4 Blocchi: 6 (Di cui 1 per memorizzare le tuple)
--Tuple: 25004 Blocchi: 785 (Di cui 580 per memorizzare le tuple) CON DATAGRIP
CREATE TABLE SetIcone(
    IdSI serial PRIMARY KEY, -- si potrebbe togliere e mettere Nome chiave
    NomeSI varchar(20) NOT NULL,
    Tema varchar(20) NOT NULL,
    DummySetIcone text,
    UNIQUE(NomeSI)
);

--Tuple: 17 Blocchi: 6 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Icone(
    IdI serial PRIMARY KEY,
    NomeI varchar(20) NOT NULL,
    Img varchar(500) NOT NULL,
    IdSI integer NOT NULL, 
    FOREIGN KEY (IdSI) REFERENCES SetIcone(IdSI),
    UNIQUE(NomeI, IdSI)
);

--Tuple: 7 Blocchi: 4 (Di cui 1 per memorizzare le tuple)
--Tuple: 25007 Blocchi: 1380 (Di cui 1308 per memorizzare le tuple) CON DATAGRIP
CREATE TABLE Plancia(
    IdP serial PRIMARY KEY,
    Img varchar(500) NOT NULL,
    IdSI integer NOT NULL, 
    DummyPlancia text,
    FOREIGN KEY (IdSI) REFERENCES SetIcone(IdSI)
);

--Tuple: 7 Blocchi: 6 (Di cui 1 per memorizzare le tuple)
--Tuple: 25007 Blocchi: 797 (Di cui 600 per memorizzare le tuple) CON DATAGRIP
CREATE TABLE Gioco(
    IdG serial PRIMARY KEY,
    NomeG varchar(20) NOT NULL,
    MinS integer NOT NULL DEFAULT 1 CHECK (MinS > 0),
    MaxS integer NOT NULL CHECK (MaxS > 0),  
    IdP integer NOT NULL,
    DummyGioco text,
    NumDadi integer NOT NULL CHECK (NumDadi >= 0),
    FOREIGN KEY (IdP) REFERENCES Plancia(IdP),
    UNIQUE(NomeG),
    CHECK(MaxS >= MinS) 
);

--Tuple: 9 Blocchi: 4 (Di cui 1 per memorizzare le tuple)
--Tuple: 25009 Blocchi: 701 (Di cui 629 per memorizzare le tuple) CON DATAGRIP
CREATE TABLE Sfida(
    IdSf serial PRIMARY KEY,
    Inizio timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Moderata boolean NOT NULL,
    MinU integer NOT NULL DEFAULT 1 CHECK (MinU > 0) ,
    MaxU integer NOT NULL CHECK (MaxU > 0),
    Durata time NOT NULL,
    IdG integer NOT NULL,
    DummySfida text, 
    FOREIGN KEY (IdG) REFERENCES Gioco(IdG),
    CHECK (MinU < MaxU)
);

--Tuple: 11 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Turno( 
    NumT integer NOT NULL CHECK (NumT >= 0),
    IdSf integer NOT NULL,
    PRIMARY KEY(NumT, IdSf),
    FOREIGN KEY (IdSf) REFERENCES Sfida(IdSf)
);

--Tuple: 17 Blocchi: 8 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Squadra(
    IdSq serial PRIMARY KEY,
    NomeSq varchar(20) NOT NULL,
    IdI integer NOT NULL,
    IdSf integer NOT NULL,
    Punti integer NOT NULL DEFAULT 0,
    UNIQUE(NomeSq, IdSf),
    UNIQUE(IdI, IdSf)
);

--Tuple: 10 Blocchi: 8 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Utente( --vedere se cambiare Admin per evitare casini
    IdU serial PRIMARY KEY,
    Email varchar(50) NOT NULL,
    Nickname varchar(50) NOT NULL,
    Admin boolean NOT NULL DEFAULT false, 
    Nome varchar(50),
    Cognome varchar(50),
    DataN date CHECK(DataN < CURRENT_DATE),
    UNIQUE(Email),
    UNIQUE(Nickname)
);

--Tuple: 3 Blocchi: 6 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Dado(
    IdDa serial PRIMARY KEY,
    Min integer NOT NULL CHECK (Min >= 0 AND Min <6),
    Max integer NOT NULL CHECK (Max > 0 AND Max <= 6),
    UNIQUE(Min, Max),
    CHECK (Min < Max)
);

--Tuple: 8 Blocchi: 4 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Tiro(
    IdT serial PRIMARY KEY,
    Valore integer NOT NULL, 
    IdDa integer NOT NULL,
    IdSf integer NOT NULL, 
    NumT integer NOT NULL, 
    IdSq integer NOT NULL, 
    FOREIGN KEY (IdDa) REFERENCES Dado(IdDa),
    FOREIGN KEY (NumT, IdSf) REFERENCES Turno(NumT, IdSf),
    FOREIGN KEY (IdSq) REFERENCES Squadra(IdSq)
);

--Tuple: 6 Blocchi: 4 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Quiz(
    IdQ serial PRIMARY KEY,
    Testo varchar(500) NOT NULL,
    Img varchar(500) 
);

--Tuple: 18 Blocchi: 4 (Di cui 1 per memorizzare le tuple)
CREATE TABLE RispostaQuiz(
    IdRQ serial PRIMARY KEY,
    Punti integer NOT NULL,
    Testo varchar(500) NOT NULL,
    Img varchar(500),
    IdQ integer NOT NULL, 
    FOREIGN KEY (IdQ) REFERENCES Quiz(IdQ)
);

--Tuple: 6 Blocchi: 4 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Task(
    IdTa serial PRIMARY KEY,
    Testo varchar(500) NOT NULL,
    Punti integer NOT NULL CHECK (Punti > 0)
);

--Tuple: 6 Blocchi: 6 (Di cui 1 per memorizzare le tuple)
CREATE TABLE RispostaTask( 
    IdRT serial PRIMARY KEY,
    File varchar(500) NOT NULL,
    IdTa integer NOT NULL, 
    IdUCarica integer NOT NULL, 
    TempoCT time NOT NULL, 
    NumT integer NOT NULL, 
    IdSf integer NOT NULL, 
    IdUCorretta integer, 
    Esito boolean,
    IdUApprova integer, 
    TempoAT time, 
    FOREIGN KEY (IdTa) REFERENCES Task(IdTa),
    FOREIGN KEY (IdUCarica) REFERENCES Utente(IdU),
    FOREIGN KEY (NumT, IdSf) REFERENCES Turno(NumT, IdSf),
    FOREIGN KEY (IdUCorretta) REFERENCES Utente(IdU),
    FOREIGN KEY (IdUApprova) REFERENCES Utente(IdU),
    UNIQUE(File)
);

--Tuple: 30 Blocchi: 5 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Casella( 
    NumC integer NOT NULL CHECK (NumC >= 0),
    IdP integer NOT NULL,
    X decimal(9,3) NOT NULL,  
    Y decimal(9,3) NOT NULL,
    Video varchar(500),
    Ritirare boolean NOT NULL DEFAULT false,
    SuccNum integer, 
    SuccIdP integer, 
    IdTa integer, 
    TempoT time,
    IdQ1 integer, 
    TempoQ1 time,
    IdQ2 integer, 
    TempoQ2 time,
    IdQ3 integer, 
    TempoQ3 time,
    IdQ4 integer, 
    TempoQ4 time,
    IdQ5 integer, 
    TempoQ5 time,
    PRIMARY KEY (NumC, IdP),
    FOREIGN KEY (IdP) REFERENCES Plancia(IdP),
    FOREIGN KEY (SuccNum, SuccIdP) REFERENCES Casella(NumC, IdP),
    FOREIGN KEY (IdTa) REFERENCES Task(IdTa),
    FOREIGN KEY (IdQ1) REFERENCES Quiz(IdQ),
    FOREIGN KEY (IdQ2) REFERENCES Quiz(IdQ),
    FOREIGN KEY (IdQ3) REFERENCES Quiz(IdQ),
    FOREIGN KEY (IdQ4) REFERENCES Quiz(IdQ),
    FOREIGN KEY (IdQ5) REFERENCES Quiz(IdQ),
    UNIQUE(IdP, X, Y),
    CHECK (NOT( (IdTa IS NULL AND TempoT IS NOT NULL) OR (IdTa IS NOT NULL AND TempoT IS NULL))),
    CHECK (NOT( (IdQ1 IS NULL AND TempoQ1 IS NOT NULL) OR (IdQ1 IS NOT NULL AND TempoQ1 IS NULL))),
    CHECK (NOT( (IdQ2 IS NULL AND TempoQ2 IS NOT NULL) OR (IdQ2 IS NOT NULL AND TempoQ2 IS NULL))),
    CHECK (NOT( (IdQ3 IS NULL AND TempoQ3 IS NOT NULL) OR (IdQ3 IS NOT NULL AND TempoQ3 IS NULL))),
    CHECK (NOT( (IdQ4 IS NULL AND TempoQ4 IS NOT NULL) OR (IdQ4 IS NOT NULL AND TempoQ4 IS NULL))),
    CHECK (NOT( (IdQ5 IS NULL AND TempoQ5 IS NOT NULL) OR (IdQ5 IS NOT NULL AND TempoQ5 IS NULL))),
    CHECK ((Ritirare AND IdQ1 IS NULL AND IdQ2 IS NULL AND IdQ3 IS NULL AND IdQ4 IS NULL AND IdQ5 IS NULL AND IdTa IS NULL) OR NOT Ritirare),
    CHECK ((SuccNum IS NOT NULL AND IdQ1 IS NULL AND IdQ2 IS NULL AND IdQ3 IS NULL AND IdQ4 IS NULL AND IdQ5 IS NULL AND IdTa IS NULL) OR SuccNum IS NULL),
    CHECK (NOT (Ritirare AND SuccNum IS NOT NULL))
);

--Tuple: 14 Blocchi: 5 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Podio(
    Pos integer NOT NULL CHECK (Pos > 0 AND Pos <= 3),
    IdP integer NOT NULL, 
    X decimal(9,3) NOT NULL, 
    Y decimal(9,3) NOT NULL,
    FOREIGN KEY (IdP) REFERENCES Plancia(IdP),
    UNIQUE(IdP, X, Y),
    PRIMARY KEY(Pos, IdP)
);

--Tuple: 9 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE CambiaDadiRispostaQuiz( 
    IdDa integer NOT NULL,
    IdRQ integer NOT NULL,
    Qta integer NOT NULL CHECK (Qta <> 0),
    PRIMARY KEY(IdDa, IdRQ),
    FOREIGN KEY (IdDa) REFERENCES Dado(IdDa),
    FOREIGN KEY (IdRQ) REFERENCES RispostaQuiz(IdRQ)
);

--Tuple: 6 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE CambiaDadiTask( 
    IdDa integer NOT NULL, 
    IdTa integer NOT NULL,
    Qta integer NOT NULL CHECK (Qta > 0),
    PRIMARY KEY(IdDa, IdTa),
    FOREIGN KEY (IdDa) REFERENCES Dado(IdDa),
    FOREIGN KEY (IdTa) REFERENCES Task(IdTa)
);

--Tuple: 6 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE SceltaRispostaQuiz( 
    IdRQ integer NOT NULL, 
    IdSf integer NOT NULL, 
    NumT integer NOT NULL, 
    IdU integer NOT NULL, 
    TempoSQ time NOT NULL,
    PRIMARY KEY(IdRQ, IdSf, NumT, IdU),
    FOREIGN KEY (IdRQ) REFERENCES RispostaQuiz(IdRQ),
    FOREIGN KEY (NumT, IdSf) REFERENCES Turno(NumT, IdSf),
    FOREIGN KEY (IdU) REFERENCES Utente(IdU)
);

--Tuple: 6 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE ApprovaRispostaQuiz(
    IdRQ integer NOT NULL,
    IdSf integer NOT NULL,
    NumT integer NOT NULL, 
    IdU integer NOT NULL, 
    TempoAQ TIME NOT NULL,
    PRIMARY KEY(IdRQ, IdSf, NumT, IdU),
    FOREIGN KEY (IdRQ) REFERENCES RispostaQuiz(IdRQ),
    FOREIGN KEY (NumT, IdSf) REFERENCES Turno(NumT, IdSf),
    FOREIGN KEY (IdU) REFERENCES Utente(IdU)
);

--Tuple: 9 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Appartiene( 
    IdU integer NOT NULL,
    IdSq integer NOT NULL, 
    Coach boolean NOT NULL DEFAULT false,
    Caposquadra boolean NOT NULL DEFAULT false,
    PRIMARY KEY(IdU, IdSq),
    FOREIGN KEY (IdU) REFERENCES Utente(IdU),
    FOREIGN KEY (IdSq) REFERENCES Squadra(IdSq),
    CHECK (NOT (Coach AND Caposquadra))
);

--Tuple: 13 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE SiTrova( --potrebbe essere necessario cambiare in NumT
    IdI integer NOT NULL,
    NumC integer NOT NULL,
    IdP integer NOT NULL,
    NumT integer NOT NULL,
    IdSf integer NOT NULL,
    Ora timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(IdI, NumT, IdSf),
    UNIQUE (Idi, Ora),
    FOREIGN KEY (IdI) REFERENCES Icone(IdI),
    FOREIGN KEY (NumC, IdP) REFERENCES Casella(NumC, IdP),
    FOREIGN KEY (NumT, IdSf) REFERENCES Turno(NumT, IdSf)
);

--Tuple: 6 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE SiTrovaPodio(  
    IdI integer NOT NULL,
    Pos integer NOT NULL,
    IdP integer NOT NULL, 
    NumT integer NOT NULL,
    IdSf integer NOT NULL,
    PRIMARY KEY(IdI, NumT, IdSf),
    FOREIGN KEY (IdI) REFERENCES Icone(IdI),
    FOREIGN KEY (Pos, IdP) REFERENCES Podio(Pos, IdP), 
    FOREIGN KEY (NumT, IdSf) REFERENCES Turno(NumT, IdSf)
);

--Tuple: 12 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Richiede(
    IdDa integer NOT NULL,
    IdG integer NOT NULL,
    Qta integer NOT NULL CHECK (Qta > 0),
    PRIMARY KEY(IdDa, IdG),
    FOREIGN KEY (IdDa) REFERENCES Dado(IdDa),
    FOREIGN KEY (IdG) REFERENCES Gioco(IdG)
);

--Tuple: 8 Blocchi: 3 (Di cui 1 per memorizzare le tuple)
CREATE TABLE Possiede(
    IdDa integer NOT NULL,
    IdSq integer NOT NULL,
    NumT integer NOT NULL,
    IdSf integer NOT NULL,
    Qta integer NOT NULL CHECK (Qta >= 0),
    PRIMARY KEY(IdDa, IdSq, NumT, IdSf),
    FOREIGN KEY (IdDa) REFERENCES Dado(IdDa),
    FOREIGN KEY (IdSq) REFERENCES Squadra(IdSq),
    FOREIGN KEY (NumT, IdSf) REFERENCES Turno(NumT, IdSf)
);

----------SCHEMA FISICO
--Creazione indice ordinato multiattributo su (NumDadi, MaxS) nella tabella Gioco
CREATE INDEX DadiSquadreGioco ON Gioco (NumDadi DESC, MaxS ASC);
CLUSTER Gioco USING DadiSquadreGioco;
--Creazione indice ordinato multiattributo clusterizzato su (IdG, Inizio) nella tabella Sfida
CREATE INDEX IdGInizioSfida ON Sfida (IdG, Inizio);
CLUSTER Sfida USING IdGInizioSfida;
--Creazione vista materializzata SfidaGioco2OreDadi
CREATE MATERIALIZED VIEW SfidaGioco2OreDadi AS 
    SELECT Sfida.IdSf, Gioco.IdG FROM Sfida NATURAL JOIN Gioco 
    WHERE Durata > '02:00:00' AND NumDadi >= 2;

----------POPOLAMENTO

INSERT INTO SetIcone (NomeSI, Tema) VALUES ('S1', 'Sport');
INSERT INTO SetIcone (NomeSI, Tema) VALUES ('S2', 'Università');
INSERT INTO SetIcone (NomeSI, Tema) VALUES ('S3', 'Calcio');
INSERT INTO SetIcone (NomeSI, Tema) VALUES ('S4', 'Auto');

INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Tennis', 'tennis.png', 1);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Calcio', 'Calcio.png', 1);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Pallavolo', 'pallavolo.png', 1);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Rugby', 'rugby.png', 1);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Informatica', 'informatica.png', 2);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Reti', 'reti.png', 2);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Classe', 'classe.png', 2);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Lavagna', 'lavagna.png', 2);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Messi', 'messi.png', 3);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Ronaldo', 'ronaldo.png', 3);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Mercedes', 'mercedes.png', 4);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Audi', 'Audi.png', 4);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('AlfaRomeo', 'alfa.png', 4);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Ferrari', 'ferrari.png', 4);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Lamborghini', 'lambo.png', 4);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Bugatti', 'bugatti.png', 4);
INSERT INTO Icone (NomeI, Img, IdSI) VALUES ('Mazda', 'mazda.png', 4);

INSERT INTO Plancia (Img, IdSI) VALUES ('p2.png', 1);
INSERT INTO Plancia (Img, IdSI) VALUES ('p3.png', 2);
INSERT INTO Plancia (Img, IdSI) VALUES ('p4.png', 3);
INSERT INTO Plancia (Img, IdSI) VALUES ('p5.png', 4);
INSERT INTO Plancia (Img, IdSI) VALUES ('p6.png', 4);
INSERT INTO Plancia (Img, IdSI) VALUES ('p7.png', 4);
INSERT INTO Plancia (Img, IdSI) VALUES ('p8.png', 4);

--NumDadi viene inserito a mano per poter eseguire i test, in realtà andrebbe calcolato mediante un trigger
INSERT INTO Gioco (NomeG, MinS, MaxS, NumDadi, IdP) VALUES ('G1', 2, 4, 1, 1);
INSERT INTO Gioco (NomeG, MaxS, NumDadi, IdP) VALUES ('G2', 4, 1, 2);
INSERT INTO Gioco (NomeG, MinS, MaxS, NumDadi, IdP) VALUES ('G3', 2, 7, 3, 3);
INSERT INTO Gioco (NomeG, MinS, MaxS, NumDadi, IdP) VALUES ('G4', 2, 8, 4, 4);
INSERT INTO Gioco (NomeG, MinS, MaxS, NumDadi, IdP) VALUES ('G5', 2, 3, 2, 5);
INSERT INTO Gioco (NomeG, MinS, MaxS, NumDadi, IdP) VALUES ('G6', 1, 2, 3, 6);
INSERT INTO Gioco (NomeG, MinS, MaxS, NumDadi, IdP) VALUES ('G7', 2, 5, 5, 7);

INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('01-01-2021 12:30:00', false, 1, 100, '02:30:00', 1);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('01-01-2021 12:30:00', true, 1, 100, '02:30:00', 2);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('01-01-2021 11:30:00', false, 1, 100, '04:30:00', 3);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('01-01-2021 12:40:00', false, 1, 100, '03:30:00', 4);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('03-01-2021 12:30:00', false, 1, 100, '00:30:00', 4);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('03-01-2021 12:30:00', false, 1, 100, '00:30:00', 5);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('04-01-2021 12:30:00', false, 1, 100, '06:30:00', 6);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('04-01-2021 12:30:00', false, 1, 100, '00:30:00', 6);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('04-01-2021 12:30:00', false, 1, 100, '05:30:00', 6);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('01-01-2021 12:40:00', false, 1, 100, '00:30:00', 4);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('03-01-2021 12:30:00', false, 1, 100, '03:30:00', 4);
INSERT INTO Sfida (Inizio, Moderata, MinU, MaxU, Durata, IdG) VALUES ('04-01-2021 12:40:00', false, 1, 100, '03:30:00', 4);


INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S1', 1, 1, 3);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S2', 2, 1, 5);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S3', 3, 1, 2);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S4', 4, 1, 1);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S1', 5, 2, 10);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S2', 6, 2, 11);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S3', 7, 2, 12);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S1', 5, 3, 32);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S2', 6, 3, 3);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S3', 7, 3, 4);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S1', 5, 4, 1);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S2', 6, 4, 5);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S3', 7, 4, 1);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S1', 11, 5, 7);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S2', 12, 5, 22);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S3', 13, 5, 24);
INSERT INTO Squadra (NomeSq, IdI, IdSf, punti) VALUES ('S1', 13, 6, 11);

INSERT INTO Utente (Email, Nickname, Admin, Nome, Cognome, DataN) VALUES ('aa@aa.a', 'aa', false, 'aa', 'aa', '01-02-2000');
INSERT INTO Utente (Email, Nickname, Admin) VALUES ('bb@aa.a', 'bb', false);
INSERT INTO Utente (Email, Nickname, Admin, Nome, Cognome, DataN) VALUES ('cc@aa.a', 'cc', true, 'cc', 'aa', '01-02-2000');
INSERT INTO Utente (Email, Nickname, Admin, Nome, Cognome, DataN) VALUES ('dd@aa.a', 'dd', true, 'dd', 'aa', '01-02-2000');
INSERT INTO Utente (Email, Nickname, Admin) VALUES ('ee@aa.a', 'ee', false);
INSERT INTO Utente (Email, Nickname, Admin) VALUES ('ff@aa.a', 'ff', false);
INSERT INTO Utente (Email, Nickname, Admin, Nome, Cognome, DataN) VALUES ('gg@aa.a', 'gg', false, 'gg', 'aa', '01-02-2000');
INSERT INTO Utente (Email, Nickname, Admin, Nome, Cognome, DataN) VALUES ('hh@aa.a', 'hh', true, 'hh', 'aa', '01-02-2000');
INSERT INTO Utente (Email, Nickname, Admin, Nome, Cognome, DataN) VALUES ('ii@aa.a', 'ii', true, 'ii', 'aa', '01-02-2000');
INSERT INTO Utente (Email, Nickname, Admin, Nome, Cognome, DataN) VALUES ('jj@aa.a', 'jj', false, 'jj', 'aa', '01-02-2000');

INSERT INTO Dado (Min, Max) VALUES (2,4);
INSERT INTO Dado (Min, Max) VALUES (2,5);
INSERT INTO Dado (Min, Max) VALUES (1,6);

INSERT INTO Quiz (Testo, Img) VALUES ('Quiz1', 'q1.png');
INSERT INTO Quiz (Testo, Img) VALUES ('Quiz2', 'q2.png');
INSERT INTO Quiz (Testo, Img) VALUES ('Quiz3', 'q3.png');
INSERT INTO Quiz (Testo, Img) VALUES ('Quiz4', 'q4.png');
INSERT INTO Quiz (Testo, Img) VALUES ('Quiz5', 'q5.png');
INSERT INTO Quiz (Testo, Img) VALUES ('Quiz6', 'q6.png');

INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (5, 'R1', 1);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (0, 'R2', 1);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (-5, 'R3', 1);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (5, 'R1', 2);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (0, 'R2', 2);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (-5, 'R3', 2);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (5, 'R1', 3);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (0, 'R2', 3);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (-5, 'R3', 3);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (5, 'R1', 4);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (0, 'R2', 4);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (-5, 'R3', 4);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (5, 'R1', 5);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (0, 'R2', 5);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (-5, 'R3', 5);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (5, 'R1', 6);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (0, 'R2', 6);
INSERT INTO RispostaQuiz (Punti, Testo, IdQ) VALUES (-5, 'R3', 6);

INSERT INTO Task (Testo, Punti) VALUES ('Task1', 5);
INSERT INTO Task (Testo, Punti) VALUES ('Task2', 5);
INSERT INTO Task (Testo, Punti) VALUES ('Task3', 5);
INSERT INTO Task (Testo, Punti) VALUES ('Task4', 5);
INSERT INTO Task (Testo, Punti) VALUES ('Task5', 5);
INSERT INTO Task (Testo, Punti) VALUES ('Task6', 5);

INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (1, 1, 5.0, 5.0, 1, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (2, 1, 6.0, 5.0, 2, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (3, 1, 7.0, 5.0, 3, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (1, 2, 5.0, 5.0, 1, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (2, 2, 6.0, 5.0, 2, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (3, 2, 7.0, 5.0, 3, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (1, 3, 5.0, 5.0, 1, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (2, 3, 6.0, 5.0, 2, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (3, 3, 7.0, 5.0, 3, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (1, 4, 5.0, 5.0, 1, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (2, 4, 6.0, 5.0, 2, '00:05:00');
INSERT INTO Casella (NumC, IdP, X, Y, IdTa, TempoT) VALUES (3, 4, 7.0, 5.0, 3, '00:05:00');

INSERT INTO Casella (NumC, IdP, X, Y, Ritirare) VALUES (4, 1, 8.0, 5.0, true);
INSERT INTO Casella (NumC, IdP, X, Y, Ritirare) VALUES (4, 2, 8.0, 5.0, true);
INSERT INTO Casella (NumC, IdP, X, Y, Ritirare) VALUES (4, 3, 8.0, 5.0, true);
INSERT INTO Casella (NumC, IdP, X, Y, Ritirare) VALUES (4, 4, 8.0, 5.0, true);

INSERT INTO Casella (NumC, IdP, X, Y) VALUES (5, 1, 9.0, 5.0);
INSERT INTO Casella (NumC, IdP, X, Y) VALUES (5, 2, 9.0, 5.0);
INSERT INTO Casella (NumC, IdP, X, Y) VALUES (5, 3, 9.0, 5.0);
INSERT INTO Casella (NumC, IdP, X, Y) VALUES (5, 4, 9.0, 5.0);
INSERT INTO Casella (NumC, IdP, X, Y) VALUES (1, 5, 9.0, 5.0);

INSERT INTO Casella (NumC, IdP, X, Y, SuccNum, SuccIdP) VALUES (6, 1, 10.0, 5.0, 5, 1);
INSERT INTO Casella (NumC, IdP, X, Y, SuccNum, SuccIdP) VALUES (6, 2, 10.0, 5.0, 5, 2);
INSERT INTO Casella (NumC, IdP, X, Y, SuccNum, SuccIdP) VALUES (6, 3, 10.0, 5.0, 5, 3);
INSERT INTO Casella (NumC, IdP, X, Y, SuccNum, SuccIdP) VALUES (6, 4, 10.0, 5.0, 5, 4);

INSERT INTO Casella (NumC, IdP, X, Y) VALUES (0, 1, 11.0, 5.0);
INSERT INTO Casella (NumC, IdP, X, Y) VALUES (0, 2, 11.0, 5.0);
INSERT INTO Casella (NumC, IdP, X, Y) VALUES (0, 3, 11.0, 5.0);
INSERT INTO Casella (NumC, IdP, X, Y) VALUES (0, 4, 11.0, 5.0);
INSERT INTO Casella (NumC, IdP, X, Y) VALUES (0, 5, 11.0, 5.0);

INSERT INTO Podio (Pos, X, Y, IdP) VALUES (1, 0.0, 0.0, 1);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (2, 1.0, 0.0, 1);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (3, 2.0, 0.0, 1);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (1, 0.0, 0.0, 2);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (2, 1.0, 0.0, 2);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (3, 2.0, 0.0, 2);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (1, 0.0, 0.0, 3);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (2, 1.0, 0.0, 3);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (3, 2.0, 0.0, 3);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (1, 0.0, 0.0, 4);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (2, 1.0, 0.0, 4);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (3, 2.0, 0.0, 4);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (1, 0.0, 0.0, 5);
INSERT INTO Podio (Pos, X, Y, IdP) VALUES (2, 1.0, 0.0, 5);

INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (1, 1, false, false);
INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (2, 2, false, false);
INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (3, 2, false, false);
INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (4, 4, false, false);
INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (5, 5, false, false);
INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (6, 6, false, false);
INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (1, 7, false, false);
INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (2, 8, false, false);
INSERT INTO Appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (3, 8, false, false);

INSERT INTO Turno (NumT, IdSf) VALUES (0, 1);
INSERT INTO Turno (NumT, IdSf) VALUES (1, 1);
INSERT INTO Turno (NumT, IdSf) VALUES (0, 2);
INSERT INTO Turno (NumT, IdSf) VALUES (1, 2);
INSERT INTO Turno (NumT, IdSf) VALUES (0, 3);
INSERT INTO Turno (NumT, IdSf) VALUES (0, 4);
INSERT INTO Turno (NumT, IdSf) VALUES (0, 5);
INSERT INTO Turno (NumT, IdSf) VALUES (0, 6);
INSERT INTO Turno (NumT, IdSf) VALUES (1, 6);
INSERT INTO Turno (NumT, IdSf) VALUES (0, 7);
INSERT INTO Turno (NumT, IdSf) VALUES (0, 8);

INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (1, 0, 1, 0, 1, '01-02-2021 15:00:00');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (2, 0, 1, 0, 1, '01-02-2021 15:00:01');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (3, 0, 1, 0, 1, '01-02-2021 15:00:02');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (4, 0, 1, 0, 1, '01-02-2021 15:00:03');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (1, 2, 1, 1, 1, '01-02-2021 15:00:04');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (2, 3, 1, 1, 1, '01-02-2021 15:00:05');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (3, 6, 1, 1, 1, '01-02-2021 15:00:06');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (4, 5, 1, 1, 1, '01-02-2021 15:00:07');

INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (5, 0, 2, 0, 2, '01-02-2021 15:00:08');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (6, 0, 2, 0, 2, '01-02-2021 15:00:09');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (7, 0, 2, 0, 2, '01-02-2021 15:00:10');

INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (13, 0, 5, 0, 6, '01-02-2021 15:00:18');
INSERT INTO SiTrova (IdI, NumC, IdP, NumT, IdSf, Ora) VALUES (13, 1, 5, 1, 6, '01-02-2021 15:00:28');

INSERT INTO SiTrovaPodio (IdI, Pos, IdP, NumT, IdSf) VALUES (1, 1, 1, 1, 1);
INSERT INTO SiTrovaPodio (IdI, Pos, IdP, NumT, IdSf) VALUES (2, 2, 1, 1, 1);
INSERT INTO SiTrovaPodio (IdI, Pos, IdP, NumT, IdSf) VALUES (3, 3, 1, 1, 1);
INSERT INTO SiTrovaPodio (IdI, Pos, IdP, NumT, IdSf) VALUES (1, 1, 2, 1, 2);
INSERT INTO SiTrovaPodio (IdI, Pos, IdP, NumT, IdSf) VALUES (2, 2, 2, 1, 2);
INSERT INTO SiTrovaPodio (IdI, Pos, IdP, NumT, IdSf) VALUES (3, 3, 2, 1, 2);

INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (1, 1, 1);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (2, 2, 1);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (1, 3, 1);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (2, 3, 2);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (1, 4, 1);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (2, 4, 1);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (3, 4, 2);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (2, 5, 2);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (2, 6, 3);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (1, 7, 1);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (2, 7, 3);
INSERT INTO Richiede (IdDa, IdG, Qta) VALUES (3, 7, 1);

INSERT INTO Possiede (IdDa, IdSq, NumT, IdSf, Qta) VALUES (1, 1, 0, 1, 1);
INSERT INTO Possiede (IdDa, IdSq, NumT, IdSf, Qta) VALUES (1, 2, 0, 1, 1);
INSERT INTO Possiede (IdDa, IdSq, NumT, IdSf, Qta) VALUES (1, 3, 0, 1, 1);
INSERT INTO Possiede (IdDa, IdSq, NumT, IdSf, Qta) VALUES (1, 4, 0, 1, 1);
INSERT INTO Possiede (IdDa, IdSq, NumT, IdSf, Qta) VALUES (1, 1, 1, 1, 1);
INSERT INTO Possiede (IdDa, IdSq, NumT, IdSf, Qta) VALUES (1, 2, 1, 1, 1);
INSERT INTO Possiede (IdDa, IdSq, NumT, IdSf, Qta) VALUES (1, 3, 1, 1, 1);
INSERT INTO Possiede (IdDa, IdSq, NumT, IdSf, Qta) VALUES (1, 4, 1, 1, 1);

INSERT INTO Tiro (Valore, IdDa, IdSf, NumT, IdSq) VALUES (3, 1, 1, 0, 1);
INSERT INTO Tiro (Valore, IdDa, IdSf, NumT, IdSq) VALUES (3, 1, 1, 0, 2);
INSERT INTO Tiro (Valore, IdDa, IdSf, NumT, IdSq) VALUES (3, 1, 1, 0, 3);
INSERT INTO Tiro (Valore, IdDa, IdSf, NumT, IdSq) VALUES (3, 1, 1, 0, 4);
INSERT INTO Tiro (Valore, IdDa, IdSf, NumT, IdSq) VALUES (3, 1, 1, 1, 1);
INSERT INTO Tiro (Valore, IdDa, IdSf, NumT, IdSq) VALUES (3, 1, 1, 1, 2);
INSERT INTO Tiro (Valore, IdDa, IdSf, NumT, IdSq) VALUES (3, 1, 1, 1, 3);
INSERT INTO Tiro (Valore, IdDa, IdSf, NumT, IdSq) VALUES (3, 1, 1, 1, 4);

INSERT INTO RispostaTask (File, IdTa, IdUCarica, TempoCT, NumT, IdSf, IdUCorretta, Esito, IdUApprova, TempoAT)
    VALUES ('risposta1.txt', 1, 1, '00:05:05', 1, 1, 3, True, 1, '00:05:05');
INSERT INTO RispostaTask (File, IdTa, IdUCarica, TempoCT, NumT, IdSf, IdUCorretta, Esito, IdUApprova, TempoAT)
    VALUES ('risposta2.txt', 1, 2, '00:05:05', 1, 1, 3, True, 2, '00:05:05');
INSERT INTO RispostaTask (File, IdTa, IdUCarica, TempoCT, NumT, IdSf, IdUCorretta, Esito, IdUApprova, TempoAT)
    VALUES ('risposta3.txt', 1, 3, '00:05:05', 1, 1, 3, True, 3, '00:05:05');
INSERT INTO RispostaTask (File, IdTa, IdUCarica, TempoCT, NumT, IdSf, IdUCorretta, Esito, IdUApprova, TempoAT)
    VALUES ('risposta4.txt', 1, 4, '00:05:05', 1, 2, 3, True, 4, '00:05:05');
INSERT INTO RispostaTask (File, IdTa, IdUCarica, TempoCT, NumT, IdSf, IdUCorretta, Esito, IdUApprova, TempoAT)
    VALUES ('risposta5.txt', 1, 5, '00:05:05', 1, 2, 3, True, 5, '00:05:05');
INSERT INTO RispostaTask (File, IdTa, IdUCarica, TempoCT, NumT, IdSf, IdUCorretta, Esito, IdUApprova, TempoAT)
    VALUES ('risposta6.txt', 1, 6, '00:05:05', 1, 2, 3, True, 6, '00:05:05');

INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 1, +2);
INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 2, +1);
INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 3, -2);
INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 4, +2);
INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 5, +1);
INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 6, -2);
INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 7, +2);
INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 8, +1);
INSERT INTO CambiaDadiRispostaQuiz (IdDa, IdRQ, Qta) VALUES (1, 9, -2);

INSERT INTO CambiaDadiTask (IdDa, IdTa, Qta) VALUES (1, 1, 2);
INSERT INTO CambiaDadiTask (IdDa, IdTa, Qta) VALUES (1, 2, 2);
INSERT INTO CambiaDadiTask (IdDa, IdTa, Qta) VALUES (1, 3, 2);
INSERT INTO CambiaDadiTask (IdDa, IdTa, Qta) VALUES (1, 4, 2);
INSERT INTO CambiaDadiTask (IdDa, IdTa, Qta) VALUES (1, 5, 2);
INSERT INTO CambiaDadiTask (IdDa, IdTa, Qta) VALUES (1, 6, 2);

INSERT INTO SceltaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoSQ) VALUES (1, 1, 1, 1, '00:05:05');
INSERT INTO SceltaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoSQ) VALUES (4, 1, 1, 2, '00:05:05');
INSERT INTO SceltaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoSQ) VALUES (7, 1, 1, 3, '00:05:05');
INSERT INTO SceltaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoSQ) VALUES (1, 2, 1, 4, '00:05:05');
INSERT INTO SceltaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoSQ) VALUES (4, 2, 1, 5, '00:05:05');
INSERT INTO SceltaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoSQ) VALUES (7, 2, 1, 6, '00:05:05');

INSERT INTO ApprovaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoAQ) VALUES (1, 1, 1, 1, '00:05:05');
INSERT INTO ApprovaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoAQ) VALUES (4, 1, 1, 2, '00:05:05');
INSERT INTO ApprovaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoAQ) VALUES (7, 1, 1, 3, '00:05:05');
INSERT INTO ApprovaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoAQ) VALUES (1, 2, 1, 4, '00:05:05');
INSERT INTO ApprovaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoAQ) VALUES (4, 2, 1, 5, '00:05:05');
INSERT INTO ApprovaRispostaQuiz (IdRQ, IdSf, NumT, IdU, TempoAQ) VALUES (7, 2, 1, 6, '00:05:05');

REFRESH MATERIALIZED VIEW SfidaGioco2OreDadi;
----------QUERY DEL WORKLOAD
--Determinare l’identificatore dei giochi che coinvolgono al più quattro squadre e richiedono l’uso di due dadi.
SELECT Gioco.IdG FROM Gioco WHERE Gioco.MaxS <= 4 AND Gioco.NumDadi = 2;
/*
Determinare l’identificatore delle sfide relative a un gioco A di vostra scelta 
(specificare direttamente l’identificatore nella richiesta) che, in alternativa:
•   hanno avuto luogo a gennaio 2021 e durata massima superiore a 2 ore, o
•	hanno avuto luogo a marzo 2021 e durata massima pari a 30 minuti.
*/
SELECT IdSf FROM Sfida WHERE IdG=4 AND (
    (Durata > '02:00:00' AND Inizio BETWEEN '01-01-2021' AND '01-31-2021') OR 
    (Durata = '00:30:00' AND Inizio BETWEEN '03-01-2021' AND '03-31-2021')
);
--Determinare le sfide, di durata massima superiore a 2 ore, dei giochi che richiedono almeno due dadi. 
--Restituire sia l’identificatore della sfida sia l’identificatore del gioco.
SELECT * FROM SfidaGioco2OreDadi;
----------QUERY E VISTE NON DEL WORKLOAD
/*
La definizione di una vista che fornisca alcune informazioni riassuntive per ogni gioco: 
il numero di sfide relative a quel gioco disputate, 
la durata media di tali sfide, il numero di squadre e di giocatori partecipanti a tali sfide, 
i punteggi minimo, medio e massimo ottenuti dalle squadre partecipanti a tali sfide;
*/
CREATE VIEW PuntiGioco AS
    SELECT 
        Gioco.IdG,
        MIN(Squadra.Punti) AS PuntiMinimi,
        AVG(Squadra.Punti) AS PuntiMedi,
        MAX(Squadra.Punti) AS PuntiMassimi
    FROM 
        Gioco NATURAL LEFT JOIN Sfida NATURAL LEFT JOIN Squadra
    GROUP BY Gioco.IdG;

CREATE VIEW SfideGioco AS
    SELECT 
        Gioco.IdG,
        AVG(Sfida.Durata) AS DurataMedia,
        COUNT(Sfida.IdSf) AS NumSfide
    FROM 
        Gioco NATURAL JOIN Sfida
    GROUP BY Gioco.IdG;

CREATE VIEW GiocatoriSquadreGioco AS
    SELECT
        Gioco.IdG,
        COUNT(DISTINCT Squadra.IdSq) AS NumSquadre,
        COUNT(Appartiene.IdU) AS NumGiocatori
    FROM
        Gioco NATURAL LEFT JOIN Sfida NATURAL LEFT JOIN Squadra NATURAL LEFT JOIN Appartiene
    GROUP BY Gioco.IdG;


CREATE VIEW InfoGioco AS 
    SELECT
        PuntiGioco.IdG,
        PuntiGioco.PuntiMinimi,
        PuntiGioco.PuntiMedi,
        PuntiGioco.PuntiMassimi,
        GiocatoriSquadreGioco.NumSquadre,
        GiocatoriSquadreGioco.NumGiocatori,
        SfideGioco.DurataMedia,
        SfideGioco.NumSfide
    FROM PuntiGioco NATURAL JOIN GiocatoriSquadreGioco NATURAL JOIN SfideGioco;

--Determinare i giochi che contengono caselle a cui sono associati task;
--Creazione di una vista materializzata. Sarà necessario un trigger per aggiornarla
--ogni volta che viene inserito un nuovo gioco. Si sceglie di penalizzare la insert
--siccome dovrebbe essere un'operazione effettuata raramente. 
CREATE MATERIALIZED VIEW GiochiConTask AS 
    SELECT DISTINCT Gioco.IdG FROM Gioco NATURAL JOIN Casella WHERE IdTa IS NOT NULL;

SELECT * from GiochiConTask;

--Determinare i giochi che non contengono caselle a cui sono associati task;
--Utilizzando la vista creata in precedenza è possibile ottimizzare anche questa query.
SELECT Gioco.IdG FROM Gioco EXCEPT SELECT IdG FROM GiochiConTask;
--Determinare le sfide che hanno durata superiore alla durata media delle sfide relative allo stesso gioco.
SELECT Sfida.IdSf FROM Sfida NATURAL JOIN InfoGioco WHERE Sfida.Durata > InfoGioco.DurataMedia;


-----VEDERE TUNING LOGICO

----------PROCEDURE/FUNZIONI
/*
Funzione che realizza l’interrogazione 2c in maniera parametrica rispetto
all’ID del gioco (cioè determina le sfide che hanno durata superiore alla durata medie delle sfide
di un dato gioco, prendendo come parametro l’ID del gioco);
*/
CREATE FUNCTION SfideDurataMaggiore (IN idGioco INTEGER) RETURNS TABLE (Sfide INTEGER) AS
    $$
        BEGIN
            RETURN QUERY SELECT Sfida.IdSf FROM Sfida NATURAL JOIN InfoGioco WHERE Sfida.Durata > InfoGioco.DurataMedia AND InfoGioco.IdG = idGioco;
        END;  --vedere se mettere le eccezioni
    $$
LANGUAGE plpgsql;

/*
Funzione di scelta dell’icona da parte di una squadra in una sfida: possono essere scelte solo le
icone corrispondenti al gioco cui si riferisce la sfida che non siano già state scelte da altre squadre.
*/
CREATE FUNCTION SceltaIcona (IN idSquadra INTEGER, IN idIcona INTEGER) RETURNS void AS
    $$
        DECLARE
        idGioco INTEGER;
        idSfida INTEGER;
        BEGIN
            IF (SELECT IdSq FROM Squadra WHERE IdSq = idSquadra) IS NULL THEN RAISE EXCEPTION 'Squadra non esistente';
            END IF;

            SELECT IdSf INTO idSfida FROM Squadra NATURAL JOIN Sfida WHERE IdSq = idSquadra; 
            SELECT IdG INTO idGioco FROM Sfida NATURAL JOIN Gioco WHERE IdSf = idSfida;

            IF (SELECT IdI FROM Gioco NATURAL JOIN Plancia NATURAL JOIN Icone WHERE IdI = idIcona AND IdG = idGioco) IS NULL 
                THEN RAISE EXCEPTION 'Icona non presente nel set icone del gioco';
            END IF;

            IF (SELECT IdSq FROM Squadra NATURAL JOIN Sfida WHERE IdSf = idSfida AND IdI = idIcona) IS NOT NULL 
                THEN RAISE EXCEPTION 'Icona già in uso';
            END IF;

            UPDATE Squadra SET IdI = idIcona WHERE IdSq = idSquadra;
        END;
    $$
LANGUAGE plpgsql;

----------TRIGGER
--Verifica del vincolo che nessun utente possa partecipare a sfide contemporanee;

CREATE OR REPLACE FUNCTION agg_app() 
RETURNS trigger AS $agg_app$
    DECLARE
        inizioSfida timestamp with time zone;
        fineSfida timestamp with time zone;
    BEGIN
        SELECT Sfida.Inizio into inizioSfida 
            FROM Squadra NATURAL JOIN Sfida WHERE IdSq = NEW.IdSq;
        SELECT Sfida.Inizio+Sfida.Durata into fineSfida 
            FROM Squadra NATURAL JOIN Sfida WHERE IdSq = NEW.IdSq;

        IF(
            SELECT COUNT(*) FROM Appartiene NATURAL JOIN Squadra NATURAL JOIN Sfida 
                WHERE Appartiene.IdU = NEW.IdU AND (Sfida.Inizio BETWEEN inizioSfida AND fineSfida 
                    OR (Sfida.Inizio < inizioSfida AND Sfida.Inizio+Sfida.Durata > inizioSfida))
        ) > 0
            THEN RAISE EXCEPTION 'Utente appartenente ad una sfida';
        ELSE
            RETURN NEW;
        END IF;
    END;
$agg_app$ LANGUAGE plpgsql;

CREATE TRIGGER VerificaSfide
BEFORE INSERT OR UPDATE ON Appartiene FOR EACH ROW
EXECUTE PROCEDURE agg_app();
--insert into appartiene (IdU, IdSq, Coach, Caposquadra) VALUES (4, 1, false, false)

/*
Mantenimento del punteggio corrente di ciascuna squadra in ogni sfida e inserimento delle
icone opportune nella casella podio.

Come prime 3 squadre vengono considerate quelle presenti nelle caselle con il valore Num più grande
(quindi più vicine alla casella finale) nell'ultimo turno concluso. Per questo motivo il trigger viene 
eseguito con successo ogni volta che viene inserito un nuovo turno (tranne il turno 0 che è quello iniziale).

Sono stati implementati 2 trigger per aggiornare il punteggio di una squadra quando viene approvato un quiz
o un task.
Non è stato implementato il trigger che consente di aggiungere i punti della risposta di un quiz  
nel caso di una sfida non moderata
*/

CREATE FUNCTION AggiungiPunti (IN idSquadra INTEGER, IN puntiAdd INTEGER) RETURNS void AS
    $$
        BEGIN
            IF (SELECT IdSq FROM Squadra WHERE IdSq = idSquadra) IS NULL THEN RAISE EXCEPTION 'Squadra non esistente';
            END IF;
            UPDATE Squadra SET Punti = Punti + puntiAdd WHERE IdSq = idSquadra;
        END;
    $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION agg_turno() 
RETURNS trigger AS $agg_turno$
    DECLARE
        idIconaCursor CURSOR FOR  
            SELECT IdI FROM SiTrova NATURAL JOIN Casella 
            WHERE SiTrova.IdSf = NEW.IdSf AND SiTrova.NumT = NEW.NumT - 1 
            ORDER BY Casella.NumC DESC;
        idIcona INTEGER;
        idPlancia INTEGER;
        numPosizioni INTEGER;
    BEGIN
        IF (NEW.NumT = 0) THEN 
            RETURN NEW;
        END IF;

        SELECT IdP INTO idPlancia FROM Sfida NATURAL JOIN Gioco WHERE Sfida.IdSf = NEW.IdSf;
        SELECT COUNT(Pos) INTO numPosizioni FROM Plancia NATURAL JOIN Podio WHERE Plancia.IdP = idPlancia;
        OPEN idIconaCursor;

        WHILE numPosizioni > 0 LOOP
            FETCH idIconaCursor INTO idIcona;
            IF idIcona IS NOT NULL THEN
                INSERT INTO SiTrovaPodio (IdI, Pos, IdP,  NumT, IdSf) VALUES (idIcona, 4 - numPosizioni, idPlancia, NEW.NumT, NEW.IdSf);
            END IF;
            numPosizioni = numPosizioni - 1;
        END LOOP;

        CLOSE idIconaCursor;
        RETURN NEW;
    END;
$agg_turno$ LANGUAGE plpgsql;

CREATE TRIGGER AggiornaClassifica
AFTER INSERT OR UPDATE ON Turno FOR EACH ROW
EXECUTE PROCEDURE agg_turno();


CREATE OR REPLACE FUNCTION agg_punti_app_rq() 
RETURNS trigger AS $agg_punti_app_rq$
    DECLARE 
        idSquadra INTEGER;
        puntiRQ INTEGER;
    BEGIN
        SELECT IdSq INTO idSquadra FROM Appartiene NATURAL JOIN Squadra NATURAL JOIN Sfida WHERE Sfida.IdSf = NEW.IdSf AND Appartiene.IdU = NEW.IdU;
        SELECT Punti INTO puntiRQ FROM RispostaQuiz WHERE IdRQ = NEW.IdRQ;
        PERFORM AggiungiPunti(idSquadra, puntiRQ);
        RETURN NEW;
    END;
$agg_punti_app_rq$ LANGUAGE plpgsql;

CREATE TRIGGER AggiornaPuntiApprovaRQ
AFTER INSERT ON ApprovaRispostaQuiz FOR EACH ROW
EXECUTE PROCEDURE agg_punti_app_rq();


CREATE OR REPLACE FUNCTION agg_punti_app_rt() 
RETURNS trigger AS $agg_punti_app_rq$
    DECLARE 
        idSquadra INTEGER;
        puntiRT INTEGER;
    BEGIN
        SELECT IdSq INTO idSquadra FROM Appartiene NATURAL JOIN Squadra NATURAL JOIN Sfida WHERE Sfida.IdSf = NEW.IdSf AND Appartiene.IdU = NEW.IdUCarica;
        SELECT Punti INTO puntiRT FROM Task WHERE IdTa = NEW.IdTa;

        IF(SELECT IdSf FROM Sfida WHERE IdSf = NEW.IdSf AND Moderata = true) IS NOT NULL THEN
            IF (NEW.IdUApprova IS NOT NULL AND NEW.Esito = true) THEN 
                PERFORM AggiungiPunti(idSquadra, puntiRT);
            END IF;
        ELSE
            IF (NEW.Esito = true AND NEW.IdRT = (
                SELECT IdRT FROM RispostaTask NATURAL JOIN Appartiene 
                WHERE Appartiene.IdSq = idSquadra AND NEW.IdTa = RispostaTask.IdTa AND NEW.IdSf = RispostaTask.IdSf AND NEW.NumT = RispostaTask.NumT 
                ORDER BY RispostaTask.TempoCT LIMIT 1

                --insert into rispostatask (file, idta, iducarica, tempoct, numt, idsf, iducorretta, esito, iduapprova, tempoat) values ('aassc.a', 1, 2, '02:00:00', 1, 1, 1, false, 1, '02:00:00')
            ))
            THEN
                PERFORM AggiungiPunti(idSquadra, puntiRT);
            END IF;
        END IF;
        RETURN NEW;
    END;
$agg_punti_app_rq$ LANGUAGE plpgsql;

CREATE TRIGGER AggiornaPuntiApprovaRT
AFTER INSERT OR UPDATE ON RispostaTask FOR EACH ROW
EXECUTE PROCEDURE agg_punti_app_rt();