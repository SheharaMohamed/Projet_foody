/* NATURAL JOIN
Exercices
1.Récupérer les informations des fournisseurs pour chaque produit
2.Afficher les informations des commandes du client "Lazy K Kountry Store"
3.Afficher le nombre de commande pour chaque messager (en indiquant son nom)
*/
SELECT RefProd,fournisseur.* FROM produit 
	NATURAL JOIN fournisseur;
    
SELECT commande.* FROM commande 
	NATURAL JOIN client WHERE Client.Societe='Lazy K Kountry Store';
    
SELECT messager.NomMess , COUNT(commande.NoCom) AS NbCmd FROM commande 
	NATURAL JOIN messager GROUP BY messager.NoMess;

/* INNER JOIN
Exercices
1.Récupérer les informations des fournisseurs pour chaque produit, avec une jointure interne
2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec une jointure interne
3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec une jointure interne
*/

SELECT produit.Refprod , fournisseur.* FROM produit 
	INNER JOIN  fournisseur ON produit.NoFour=fournisseur.NoFour;
    
SELECT commande.* FROM commande 
	INNER JOIN client ON commande.CodeCli=client.CodeCli 
    WHERE client.Societe='Lazy K Kountry Store';
    
SELECT messager.NomMess , COUNT(commande.NoCom) AS NbCmd FROM commande 
	INNER JOIN messager ON commande.NoMess=messager.NoMess
    GROUP BY messager.NoMess;

/* OUTER JOIN
Exercices
1.Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande
2.Lister les produits n'apparaissant dans aucune commande
3.Existe-t'il un employé n'ayant enregistré aucune commande ?
*/

SELECT produit.Refprod, COUNT(detailcommande.NoCom) AS NbCmd FROM produit
	LEFT OUTER JOIN detailcommande ON  produit.Refprod=detailcommande.RefProd
    GROUP BY detailcommande.RefProd;

SELECT produit.Refprod, produit.Nomprod, COUNT(detailcommande.NoCom) AS NbCmd FROM produit
	LEFT OUTER JOIN detailcommande ON  produit.Refprod=detailcommande.RefProd
    GROUP BY detailcommande.RefProd
    HAVING NbCmd=0;

SELECT employe.NoEmp, COUNT(commande.NoCom) AS NbCmd FROM employe
	LEFT OUTER JOIN commande ON employe.NoEmp=commande.NoEmp
    GROUP BY commande.NoEmp 
    HAVING NbCmd=0;

/* SELF JOIN
Exercices
1.Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main
2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main
3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main
*/

SELECT p.Refprod, f.* FROM fournisseur f, produit p
	WHERE f.NoFour=p.NoFour;

SELECT  co.* FROM commande co, client cl
	WHERE co.CodeCli=cl.CodeCli 
    AND cl.Societe='Lazy K Kountry Store';
    
SELECT  m.NomMess, COUNT(c.NoCom) AS NbCmd FROM commande c, messager m
	WHERE m.NoMess=c.NoMess
    GROUP BY c.NoMess;

/*
Bonus :
1.Compter le nombre de produits par fournisseur
2.Compter le nombre de produits par pays d'origine des fournisseurs
3.Compter pour chaque employé le nombre de commandes gérées, même pour ceux n'en ayant fait aucune
4.Afficher le nombre de pays différents des clients pour chaque employe (en indiquant son nom et son prénom)
5.Compter le nombre de produits commandés pour chaque client pour chaque catégorie
*/

SELECT f.NoFour, COUNT(p.Refprod) AS NbProd FROM fournisseur f
	INNER JOIN produit p ON f.NoFour=p.NoFour
    GROUP BY p.NoFour;

SELECT f.Pays, COUNT(p.Refprod) AS NbProd FROM fournisseur f
	INNER JOIN produit p ON f.NoFour=p.NoFour
    GROUP BY f.Pays;

SELECT e.NoEmp, COUNT(c.NoCom) AS NbCmd FROM employe e
	LEFT OUTER JOIN commande c ON e.NoEmp=c.NoEmp
    GROUP BY c.NoEmp;

SELECT e.NoEmp,e.Nom,e.Prenom, COUNT(DISTINCT cl.Pays) AS NbPays FROM employe e
	LEFT OUTER JOIN commande c ON e.NoEmp=c.NoEmp
    LEFT OUTER JOIN  client cl ON c.CodeCli=cl.CodeCli
    GROUP BY c.NoEmp
    ORDER BY e.NoEmp;

SELECT client.CodeCli, produit.CodeCateg, COUNT(detailcommande.NoCom) AS NbCmd FROM client
	INNER JOIN commande ON client.CodeCli=commande.CodeCli
    INNER JOIN detailcommande ON commande.NoCom=detailcommande.NoCom
    INNER JOIN produit ON detailcommande.RefProd=produit.Refprod
    GROUP BY client.CodeCli, produit.CodeCateg
    ORDER BY client.CodeCli;