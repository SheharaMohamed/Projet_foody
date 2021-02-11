/*
Exercices
1.Lister les employés n'ayant jamais effectué une commande, via une sous-requête
2.Nombre de produits proposés par la société fournisseur "Ma Maison", via une sous-requête
3.Nombre de commandes passées par des employés sous la responsabilité de "Buchanan Steven"
*/

SELECT NoEmp,Nom,Prenom FROM employe WHERE NoEmp NOT IN (SELECT NoEmp FROM commande);

SELECT NoFour,COUNT(Refprod) AS NbProd FROM produit WHERE NoFour=(SELECT NoFour FROM fournisseur WHERE Societe='Ma Maison');

SELECT  COUNT(*) AS NbCmd_par_BuchananSteven FROM commande WHERE NoEmp IN 
	(SELECT NoEmp FROM employe WHERE RendCompteA IN (SELECT NoEmp FROM employe WHERE Nom='Buchanan' AND  Prenom='Steven'));

/*
Exercices
1.Lister les produits n'ayant jamais été commandés, à l'aide de l'opérateur EXISTS
2.Lister les fournisseurs dont au moins un produit a été livré en France
3.Liste des fournisseurs qui ne proposent que des boissons (drinks)
*/

SELECT Refprod,Nomprod FROM produit p WHERE NOT EXISTS (SELECT * FROM detailcommande WHERE RefProd=p.RefProd);

SELECT NoFour,Societe,Ville,Pays FROM fournisseur f WHERE EXISTS
	(SELECT * FROM detailcommande d, commande c, produit p
    WHERE p.RefProd=d.RefProd AND d.NoCom=c.NoCom AND p.NoFour=f.NoFour AND PaysLiv LIKE 'FRANCE');

SELECT NoFour,Societe,Ville,Pays FROM fournisseur f WHERE EXISTS
	(SELECT * FROM produit p WHERE f.NoFour=p.NoFour AND 
		CodeCateg=(SELECT CodeCateg FROM categorie WHERE NomCateg='Drinks'));

/*
Bonus :
1.Lister les clients qui ont commandé du "Camembert Pierrot" (sans aucune jointure)
2.Lister les fournisseurs dont aucun produit n'a été commandé par un client français
3.Lister les clients qui ont command ́e tous les produits du fournisseur "Exotic liquids"
4.Quel est le nombre de fournisseurs n’ayant pas de commandes livrées au Canada ?
5.Lister les employés ayant une clientèle sur tous les pays
*/
SELECT CodeCli,Societe,Ville,Pays FROM client WHERE CodeCli IN 
	(SELECT CodeCli FROM commande WHERE NoCom IN 
    (SELECT NoCom FROM detailcommande WHERE RefProd=
    (SELECT Refprod FROM produit WHERE Nomprod='Camembert Pierrot')));
    
SELECT NoFour,Societe,Ville,Pays FROM fournisseur f WHERE NOT EXISTS
	(SELECT * FROM detailcommande d, commande c, produit p, client cl
    WHERE p.RefProd=d.RefProd AND d.NoCom=c.NoCom AND p.NoFour=f.NoFour AND c.CodeCli=cl.CodeCli AND cl.Pays='FRANCE');

SELECT cl.CodeCli,cl.Societe,cl.Ville,cl.Pays FROM client cl
	INNER JOIN commande c ON cl.CodeCli=c.CodeCli
    INNER JOIN detailcommande d ON c.NoCom=d.NoCom
    WHERE EXISTS (SELECT * FROM produit p WHERE d.RefProd=p.RefProd AND 
		p.NoFour=(SELECT NoFour FROM fournisseur WHERE Societe='Exotic liquids'))
    GROUP BY c.CodeCli
    HAVING COUNT(DISTINCT d.RefProd)=(SELECT COUNT(*) FROM produit p WHERE EXISTS 
		(SELECT * FROM fournisseur f WHERE p.NoFour=f.NoFour AND Societe='Exotic liquids'));

SELECT COUNT(*) AS NbFour FROM fournisseur f WHERE NOT EXISTS
	(SELECT * FROM detailcommande d, commande c, produit p
    WHERE p.RefProd=d.RefProd AND d.NoCom=c.NoCom AND p.NoFour=f.NoFour AND PaysLiv LIKE 'CANADA');

SELECT DISTINCT employe.NoEmp, COUNT(DISTINCT client.Pays) AS NbPays,
	CASE COUNT(DISTINCT client.Pays)
		WHEN (SELECT COUNT(DISTINCT Pays) FROM client) THEN 1
        ELSE 0
	END AS Inclus_tout_pays
	FROM employe
	LEFT OUTER JOIN commande ON commande.NoEmp=employe.NoEmp
    INNER JOIN client ON commande.CodeCli=client.CodeCli
    GROUP BY employe.NoEmp;