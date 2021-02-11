/*
Exercices :
1.Calculer le nombre d'employés qui sont "Sales Manager"
2.Calculer le nombre de produits de moins de 50 euros
3.Calculer le nombre de produits de catégorie 2 et avec plus de 10 unités en stocks
4.Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18
5.Calculer le nombre de pays différents de livraison
6.Calculer le nombre de commandes réalisées le en Aout 2006.
*/

SELECT COUNT(*) AS Nb_Emp FROM employe WHERE Fonction='Sales Manager';
SELECT COUNT(*) AS Nb_Prod FROM produit WHERE PrixUnit<50;
SELECT COUNT(*) AS Nb_Prod FROM produit WHERE CodeCateg=2 AND UnitesStock>10;
SELECT COUNT(*) AS Nb_Prod FROM produit WHERE CodeCateg=1 AND NoFour IN (1,18);
SELECT COUNT(DISTINCT PaysLiv) AS Nb_pays FROM commande;
SELECT COUNT(*) AS Nb_Com FROM commande WHERE MONTH(DateCom)=8 AND YEAR(DateCom)=2006;

/*
Exercices
1.Calculer le coût du port minimum et maximum des commandes , ainsi que le coût moyen du port pour les commandes du client dont le code est "QUICK" (attribut CodeCli)
2.Pour chaque messager (par leur numéro: 1, 2 et 3), donner le montant total des frais de port leur correspondant
*/

SELECT CodeCli,(MIN(Port)) AS Min_port,ROUND(MAX(Port)) AS Max_port,ROUND(AVG(Port)) AS Avg_port FROM commande WHERE CodeCli='QUICK';
SELECT NoMess, ROUND(SUM(Port),2) AS Tot_port FROM commande GROUP BY NoMess;

/*
Exercices
1.Donner le nombre d'employés par fonction
2.Donner le montant moyen du port par messager(shipper)
3.Donner le nombre de catégories de produits fournis par chaque fournisseur
4.Donner le prix moyen des produits pour chaque fournisseur et chaque catégorie de produits fournis par celui-ci
*/

SELECT Fonction,Count(*) AS Nb_Emp FROM employe GROUP BY Fonction;
SELECT NoMess, ROUND(AVG(Port),2) AS Avg_Port FROM commande GROUP BY NoMess;
SELECT NoFour,COUNT(DISTINCT CodeCateg ) AS NbCateg FROM produit GROUP BY NoFour;
SELECT NoFour,CodeCateg, ROUND(AVG(PrixUnit),2) AS Prix_Moyen FROM produit GROUP BY NoFour,CodeCateg;

/*
Exercices
1.Lister les fournisseurs ne fournissant qu'un seul produit
2.Lister les catégories dont les prix sont en moyenne supérieurs strictement à 50 euros
3.Lister les fournisseurs ne fournissant qu'une seule catégorie de produits
4.Lister le Products le plus cher pour chaque fournisseur, pour les Products de plus de 50 euro
*/

SELECT NoFour,COUNT(Refprod) AS NbProd FROM produit GROUP BY NoFour HAVING COUNT(Refprod)=1;
SELECT CodeCateg,ROUND(AVG(PrixUnit),2) AS AvgPrix FROM produit GROUP BY CodeCateg HAVING AVG(PrixUnit)>50;
SELECT NoFour,COUNT(DISTINCT CodeCateg) NbCat FROM produit GROUP BY NoFour HAVING COUNT(DISTINCT CodeCateg)=1;
SELECT Refprod,MAX(PrixUnit) AS ProdCher FROM produit GROUP BY NoFour HAVING MAX(PrixUnit)>50;

/*
Bonus :
1.Donner la quantité totale commandée par les clients, pour chaque produit
2.Donner les cinq clients avec le plus de commandes, triés par ordre décroissant
3.Calculer le montant total des lignes d'achats de chaque commande, sans et avec remise sur les produits
4.Pour chaque catégorie avec au moins 10 produits, calculer le montant moyen des prix
5.Donner le numéro de l'employé ayant fait le moins de commandes
*/

SELECT RefProd,SUM(Qte) AS QteTotal FROM detailcommande GROUP BY RefProd;
SELECT CodeCli,COUNT(NoCom) AS NbCmd FROM commande GROUP BY CodeCli ORDER BY NbCmd DESC LIMIT 5;
SELECT NoCom, ROUND(SUM(PrixUnit*Qte),2) AS Tot, ROUND(SUM(PrixUnit*Qte*(1-Remise)),2) AS TotRem FROM detailcommande GROUP BY NoCom;
SELECT CodeCateg,COUNT(Refprod) AS NbProd, ROUND(AVG(PrixUnit),2) AS MoyPrix FROM produit GROUP BY CodeCateg HAVING COUNT(Refprod)>=10;
SELECT NoEmp, COUNT(*) AS NbCmd FROM commande GROUP BY NoEmp ORDER BY COUNT(*)  LIMIT 1;