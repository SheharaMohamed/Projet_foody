/*
Exercices :
La table DetailsCommande contient l'ensemble des lignes d'achat de chaque commande. Calculer, pour la commande numéro 10251, pour chaque produit acheté dans celle-ci, le montant de la ligne d'achat en incluant la remise (stockée en proportion dans la table). Afficher donc (dans une même requête) :
- le prix unitaire,
- la remise,
- la quantité,
- le montant de la remise,
- le montant à payer pour ce produit
*/
SELECT RefProd,PrixUnit,Remise,Qte,
	ROUND(PrixUnit*Qte*Remise,2) AS MntRemise,
    ROUND(PrixUnit*Qte*(1-Remise),2) AS MntAPayer 
    FROM DetailCommande WHERE NoCom=10251;
    
/*
Exercices :
1.A partir de la table Produit, afficher "Produit non disponible" lorsque l'attribut Indisponible vaut 1, et "Produit disponible" sinon.
2.À partir de la table DetailsCommande, indiquer les infos suivantes en fonction de la remise
* si elle vaut 0 : "aucune remise"
* si elle vaut entre 1 et 5% (inclus) : "petite remise"
* si elle vaut entre 6 et 15% (inclus) : "remise modérée"
* sinon :"remise importante"
3.Indiquer pour les commandes envoyées si elles ont été envoyées en retard (date d'envoi DateEnv supérieure (ou égale) à la date butoir ALivAvant) ou à temps.
*/

SELECT RefProd, NomProd AS Produit,
	CASE Indisponible
		WHEN 1 THEN "Produit non disponible"
        ELSE "Produit disponible"
	END AS Disponibilite
    FROM produit;

SELECT *,
	CASE 
		WHEN Remise=0 THEN "Aucune Remise"
        WHEN  (Remise<0.051) THEN "Petite Remise"
        WHEN  (Remise<0.151) THEN "Remise Modérée"
        ELSE "Remise Importante"
	END AS TypeRemise
    FROM detailcommande;

SELECT NoCom,
	CASE
		WHEN DateEnv>=AlivAvant THEN "En retard"
        ELSE "A temps"
	END AS StatutEnv
    FROM commande;

/*
Exercices :
Dans une même requête, sur la table Client :
* Concaténer les champs Adresse, Ville, CodePostal et Pays dans un nouveau champ nommé Adresse_complète, pour avoir : Adresse, CodePostal, Ville, Pays
* Extraire les deux derniers caractères des codes clients
* Mettre en minuscule le nom des sociétés
* Remplacer le terme "Owner" par "Freelance" dans Fonction
* Indiquer la présence du terme "Manager" dans Fonction
*/

SELECT RIGHT(CodeCli,2) AS CodeCli, LOWER(Societe) AS Societe,
	CONCAT(Address,' ',Ville,' ',CodePostal,' ',Pays) AS  Adresse_complète, 
	REPLACE (Fonction,'Owner','Freelance') AS Fonction,
    CASE
		WHEN  (Fonction LIKE '%Manager%') THEN 'Présent Manager'
        ELSE 'Absent Manager'
	END AS Manager
        FROM Client;

/*
Exercices :
1.Afficher le jour de la semaine en lettre pour toutes les dates de commande, afficher "week-end" pour les samedi et dimanche,
2.Calculer le nombre de jours entre la date de la commande (DateCom) et la date butoir de livraison (ALivAvant), pour chaque commande, On souhaite aussi contacter les clients 1 mois après leur commande.
  ajouter la date correspondante pour chaque commande
*/

SELECT NoCom,DateCom,
	CASE WEEKDAY(DateCom)
		WHEN 1 THEN 'Lundi'
        WHEN 2 THEN 'Mardi'
        WHEN 3 THEN 'Mercredi'
        WHEN 4 THEN 'Jeudi'
        WHEN 5 THEN 'Vendredi'
        ELSE 'Week-end'
	END AS JourCom
    FROM commande;

SELECT NoCom,CodeCli, DATEDIFF(AlivAvant,DateCom) AS Diff_jours,
	DATE_ADD(DateCom,INTERVAL 1 MONTH) AS DateAppel FROM commande;

/*
Bonus :
1.Récupérer l'année de naissance et l'année d'embauche des employés
2.Calculer à l'aide de la requête précédente l'âge d'embauche et le nombre d'années dans l'entreprise
3.Afficher le prix unitaire original, la remise en pourcentage, le montant de la remise et le prix unitaire avec remise (tous deux arrondis aux centimes), pour les lignes de commande dont la remise est strictement supérieure à 10%
4.Calculer le délai d'envoi (en jours) pour les commandes dont l'envoi est après la date butoir, ainsi que le nombre de jours de retard
5.Rechercher les sociétés clientes, dont le nom de la société contient le nom du contact de celle-ci
*/

SELECT NoEmp,DateNaissance,DateEmbauche FROM employe;

SELECT NoEmp, DATE_FORMAT(FROM_DAYS(DATEDIFF(DateEmbauche,DateNaissance)),'%Y')+0 AS AgeEmb,
	DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(),DateEmbauche)),'%Y')+0 AS AnnéesExp
    FROM employe;

SELECT PrixUnit,CONCAT(ROUND(Remise*100,2),'%') AS RemisePourcentage,
	ROUND(PrixUnit*Remise,2) AS MontantRemise,
	ROUND(PrixUnit*(1-Remise),2) AS PrixRemise
    FROM detailcommande;

SELECT NoCom,DATEDIFF(DateEnv,DateCom)  AS DelaiEnvoi,
	CASE 
		WHEN DateEnv>AlivAvant THEN  DATEDIFF(DateEnv,AlivAvant)
	END AS RetardJours
     FROM commande;
	
SELECT CodeCli, Societe, Contact FROM client WHERE Societe LIKE CONCAT('%',Contact,'%');