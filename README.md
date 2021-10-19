# ProgettoDatabase
Progetto realizzato per l'esame di basi di dati dell'università.
Veniva richiesto di progettare e realizzare una base di dati in PostgreSQL che ottimizzasse le query
presenti nel workload. 
È possibile trovare maggiori informazioni riguardanti la richiesta nel file [specifica.pdf](doc/specifica.pdf)
# Installazione
Nella cartella src sono presenti 3 file:
* [db.sql](src/db.sql): realizza la base di dati e crea un primo popolamento di test
* [role.sql](src/role.sql): realizza i ruoli richiesti dalla specifica
* [datanamic.sql](src/datanamic.sql): popola le tabelle coinvolte nel workload per testare l'efficienza delle query

Il primo script da eseguire è db.sql, successivamente è possibile eseguire role.sql e datanamic.sql nell'ordine che si preferisce
# Documentazione
All'interno della cartella doc è possibile trovare 3 file:
* [progettazione.pdf](doc/progettazione.pdf): specifica lo schema logico della base di dati, l'implementazione delle query del workload e lo schema fisico adottato per poterle ottimizzare
* [interrogazioniERuoli.pdf](doc/interrogazioniERuoli.pdf): mostra i benefici ottenuti con il piano logico adottato e specifica i permessi di ogni ruolo creato
* [progettoBD.png](doc/progettoBD.png): rappresentazione dello schema logico della base di dati ottenuta mediante datagrip
* [specifica.pdf](doc/specifica.pdf): si tratta delle specifiche richieste per il progetto
