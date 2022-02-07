WITH t_price_history AS(
SELECT p.ProductID, pl.StartDate, pl.ListPrice,ps.name,p.ProductSubCategoryID, LAG(pl.ListPrice) OVER (PARTITION BY p.ProductID ORDER BY pl.StartDate) AS prevListPrice, p.ModifiedDate, pmp.CultureID, pd.Description
FROM product p
LEFT OUTER JOIN ProductListPriceHistory pl
ON p.ProductID = pl.ProductID
LEFT OUTER JOIN productsubcategory ps
ON p.ProductSubCategoryID = ps.ProductSubCategoryID
LEFT OUTER JOIN productmodelproductdescriptionculture pmp
ON p.ProductModelID = pmp.ProductModelID
LEFT OUTER JOIN productdescription pd
ON pmp.ProductDescriptionID = pd.ProductDescriptionID
)
SELECT a.ProductID, a.StartDate, IFNULL(LEAD(a.StartDate, 1) OVER (PARTITION BY a.ProductID ORDER BY a.StartDate), '9999-12-31 00:00:00') EndDate, a.ModifiedDate, a.ListPrice,z.Name AS CategoryName,n.name AS SubCategoryName, a.CultureID, c.Name AS culture_name, a.Description
FROM t_price_history a
JOIN productsubcategory n
ON a.ProductSubCategoryID = n.ProductSubCategoryID
LEFT OUTER JOIN productcategory z
ON n.ProductCategoryID = z.ProductCategoryID
LEFT OUTER JOIN culture c
ON a.CultureID = c.CultureID
WHERE listprice != IFNULL(prevListPrice, 0)
;



CREATE TABLE `dim_product` (
  `ProductID` INT DEFAULT NULL,
  `StartDate` DATE DEFAULT NULL,
  `EndDate` DATE DEFAULT NULL,
  `ModifiedDate` DATE DEFAULT NULL,
  `ListPrice` VARCHAR(256) DEFAULT NULL,
  `CategoryName` VARCHAR(256) DEFAULT NULL,
  `SubCategoryName` VARCHAR(256) DEFAULT NULL,
  `CultureID` VARCHAR(256) DEFAULT NULL,
  `culture_name` VARCHAR(256) DEFAULT NULL,
  `Description` VARCHAR(256) DEFAULT NULL,
  `version` VARCHAR(256) DEFAULT NULL,
  `productkey` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`productkey`))
  
  SELECT * FROM dim_product;
  
  TRUNCATE TABLE dim_product;
