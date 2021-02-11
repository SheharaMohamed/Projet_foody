#Comparer les prix de produit
SELECT DISTINCT p.Refprod,p.Nomprod,p.QteParUnit,p.PrixUnit,d.PrixUnit AS PrixVendu,d.Remise,ROUND(d.PrixUnit*(1-d.Remise),2) AS PrixRemise FROM commande c
	INNER JOIN detailcommande d ON c.NoCom=d.NoCom
    INNER JOIN produit p ON d.RefProd=p.Refprod;
    
#Nombre de clients achetes les produits
SELECT p.Refprod,p.Nomprod,p.QteParUnit,p.PrixUnit,p.UnitesStock,COUNT(DISTINCT c.NoCom) AS NbCmd,COUNT(DISTINCT CodeCli) AS NbCli FROM commande c
	INNER JOIN detailcommande d ON c.NoCom=d.NoCom
    INNER JOIN produit p ON d.RefProd=p.Refprod
    GROUP BY p.Refprod;
        
#Nombre de produits par founisseur
SELECT f.NoFour,COUNT(p.Refprod) AS NbProd FROM fournisseur f
	INNER JOIN produit p ON f.NoFour=p.NoFour
    INNER JOIN categorie c ON p.CodeCateg=c.CodeCateg
    GROUP BY f.NoFour
    ORDER BY f.NoFour;
    
#Nombre de produits par pays d'origine
SELECT f.pays,COUNT(p.Refprod) AS NbProd FROM fournisseur f
	INNER JOIN produit p ON f.NoFour=p.NoFour
    INNER JOIN categorie c ON p.CodeCateg=c.CodeCateg
    GROUP BY f.pays
    ORDER BY f.pays;

#Informations Commandes par mois et année
SELECT CONCAT(YEAR(DateCom),'-',MONTH(DateCom)) AS period,COUNT(NoCom) AS NbCmd FROM commande
	GROUP BY YEAR(DateCom),MONTH(DateCom);

#Delai d'envoie et prix par messager
SELECT c.NoCom,m.NoMess,c.PaysLiv,ROUND(AVG(DATEDIFF(c.DateEnv,c.DateCom))) AS 'Delaienvoie (jours)',ROUND(AVG(c.Port),2) AS port  FROM messager m
	INNER JOIN commande c ON m.NoMess=c.NoMess GROUP BY m.NoMess, c.PaysLiv ORDER BY m.NoMess,c.PaysLiv;

#Nombre de commandes effectué par chaque ville et pays
SELECT NoCom,PaysLiv,VilleLiv,COUNT(NoCom) AS NbCmd FROM commande 
	GROUP BY PaysLiv,VilleLiv ORDER BY PaysLiv,VilleLiv;
