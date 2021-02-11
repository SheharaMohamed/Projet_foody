/*
Exercices :
1.Afficher les 10 premiers éléments de la table Produit triés par leur prix unitaire
2.Afficher les trois produits les plus chers
*/

SELECT * FROM produit ORDER BY PrixUnit LIMIT 10;
SELECT * FROM produit ORDER BY PrixUnit DESC LIMIT 3;

/*
Exercices :
1.Lister les clients français installés à Paris dont le numéro de fax n'est pas renseigné
2.Lister les clients français, allemands et canadiens
3.Lister les clients dont le nom de société contient "restaurant"
*/

SELECT * FROM client WHERE ville='Paris' AND Fax IS NULL;
SELECT * FROM client WHERE pays IN ('France','Germany','Canada');
SELECT * FROM client WHERE Societe LIKE '%restaurant%';

/*
Exercices :
1.Lister les descriptions des catégories de produits (table Categorie)
2.Lister les différents pays et villes des clients, le tout trié par ordre alphabétique croissant du pays et décroissant de la ville
3.Lister tous les produits vendus en bouteilles (bottle) ou en canettes(can)
4.Lister les fournisseurs français, en affichant uniquement le nom, le contact et la ville, triés par ville
5.Lister les produits (nom en majuscule et référence) du fournisseur n° 8 dont le prix unitaire est entre 10 et 100 euros, en renommant les attributs pour que ça soit explicite
6.Lister les numéros d'employés ayant réalisé une commande (cf table Commande) à livrer en France, à Lille, Lyon ou Nantes
7.Lister les produits dont le nom contient le terme "tofu" ou le terme "choco", dont le prix est inférieur à 100 euros (attention à la condition à écrire)
*/

SELECT DISTINCT NomCateg AS Categories FROM Categorie;
SELECT DISTINCT Pays , ville  FROM Client ORDER BY Pays ASC, Ville DESC;
SELECT NomProd  FROM Produit WHERE QteParUnit LIKE '%bottle%' OR QteParUnit LIKE '%can%';
SELECT Societe,Contact,Ville  FROM Fournisseur WHERE Pays='France' ORDER BY Ville;
SELECT UPPER(NomProd) AS Nom, RefProd AS Reference FROM Produit WHERE NoFour=8 AND PrixUnit BETWEEN 10 AND 100;
SELECT DISTINCT NoEmp, VilleLiv FROM Commande WHERE VilleLiv IN ('Lille','Lyon','Nantes') AND PaysLiv='France';
SELECT DISTINCT NomProd AS Produits FROM produit WHERE PrixUnit<100 AND NomProd LIKE '%tofu%' OR NomProd LIKE '%choco%';

/*