/*
Exercices
En utilisant la clause UNION :
1.Lister les employés (nom et prénom) étant "Representative" ou étant basé au Royaume-Uni (UK)
2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) ou ayant été livré par "Speedy Express"
*/

SELECT Nom,Prenom FROM employe WHERE Fonction LIKE '%Representative' 
	UNION
SELECT Nom,Prenom FROM employe WHERE Pays='UK';

SELECT Societe,Pays FROM client WHERE CodeCli IN 
	(SELECT CodeCli FROM commande WHERE NoEmp IN 
		(SELECT NoEmp FROM employe WHERE Ville='London'))
    UNION
SELECT Societe,Pays FROM client WHERE CodeCli IN 
	(SELECT CodeCli FROM commande WHERE NoMess IN 
		(SELECT NoMess FROM messager WHERE NomMess='Speedy Express'));

/*
Exercices
1.Lister les employés (nom et prénom) étant "Representative" et étant basé au Royaume-Uni (UK)
2.Lister les clients (société et pays) ayant commandés via un employé basé à "Seattle" et ayant commandé des "Desserts"
*/

SELECT Nom,Prenom FROM employe WHERE Fonction LIKE '%Representative' AND 
	NoEmp IN (SELECT NoEmp FROM employe WHERE Pays='UK');

/*A corriger */
SELECT Societe,Pays FROM client WHERE CodeCli IN 
	#les clients (société et pays) ayant commandé via un employé basé à "Seattle"
	((SELECT CodeCli FROM commande WHERE NoEmp IN 
		(SELECT NoEmp FROM employe WHERE Ville='Seattle')) 
    UNION 
    #les clients (société et pays) ayant commandés des "Desserts"
    (SELECT client.CodeCli FROM client WHERE CodeCli IN
		(SELECT CodeCli FROM commande WHERE NoCom IN
			(SELECT NoCom FROM detailcommande WHERE RefProd IN
				(SELECT Refprod FROM produit WHERE CodeCateg=
					(SELECT  CodeCateg FROM categorie WHERE NomCateg='Desserts'))))));

#Autre method pour trouver le les clients (société et pays) ayant commandés des "Desserts" avec join
SELECT DISTINCT client.CodeCli FROM client
		INNER JOIN commande ON client.CodeCli=commande.CodeCli
        INNER JOIN detailcommande ON commande.NoCom=detailcommande.NoCom
        INNER JOIN produit ON detailcommande.RefProd=produit.Refprod
        WHERE produit.CodeCateg=(SELECT CodeCateg FROM categorie WHERE NomCateg='Desserts');

/*
Exercices
1.Lister les employés (nom et prénom) étant "Representative" mais n'étant pas basé au Royaume-Uni (UK)
2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) et n'ayant jamais été livré par "United Package"
*/

#EXCEPT 
SELECT Nom,Prenom FROM employe WHERE Fonction LIKE '%Representative' 
	AND NoEmp NOT IN
(SELECT NoEmp FROM employe WHERE Pays='UK');

SELECT Societe,Pays FROM client WHERE CodeCli IN 
	(SELECT CodeCli FROM commande WHERE NoEmp IN 
		(SELECT NoEmp FROM employe WHERE Ville='London'))
    AND CodeCli NOT IN 
(SELECT CodeCli FROM client WHERE CodeCli IN 
	(SELECT CodeCli FROM commande WHERE NoMess IN 
		(SELECT NoMess FROM messager WHERE NomMess='United Package')));

/*
Bonus :
1.Lister les employés ayant déjà pris des commandes de "Boissons" ou ayant envoyés une commande via "Federal Shipping"
2.Lister les produits de fournisseurs canadiens et ayant été commandé par des clients du "Canada"
3.Lister les clients (Société) qui ont commandé du "Konbu" mais pas du "Tofu"
*/

SELECT NoEmp,Nom,Prenom,Fonction FROM employe WHERE NoEmp IN 
	(SELECT NoEmp FROM commande WHERE NoCom IN
		(SELECT NoCom FROM detailcommande WHERE RefProd IN
			(SELECT RefProd FROM produit WHERE CodeCateg=
				(SELECT CodeCateg FROM categorie WHERE NomCateg='Drinks'))))
	UNION
SELECT NoEmp,Nom,Prenom,Fonction FROM employe WHERE NoEmp IN 
	(SELECT NoEmp FROM commande WHERE NoMess=
		(SELECT NoMess FROM messager WHERE NomMess='Federal Shipping'));

SELECT Refprod,Nomprod FROM produit WHERE NoFour IN
	(SELECT NoFour FROM fournisseur WHERE Pays='Canada')
	AND RefProd IN
    (SELECT Refprod FROM detailcommande WHERE NoCom IN
		(SELECT NoCom FROM commande WHERE CodeCli IN
			(SELECT CodeCli FROM client WHERE  Pays='Canada')));

SELECT Societe FROM client WHERE CodeCli IN 
	(SELECT CodeCli FROM commande WHERE NoCom IN
		(SELECT NoCom FROM detailcommande WHERE 
			RefProd=(SELECT RefProd FROM produit WHERE Nomprod='Konbu')))
	AND CodeCli NOT IN 
	(SELECT CodeCli FROM commande WHERE NoCom IN
		(SELECT NoCom FROM detailcommande WHERE 
			RefProd=(SELECT RefProd FROM produit WHERE Nomprod='Tofu')));
            