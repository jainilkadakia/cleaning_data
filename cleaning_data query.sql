use housing_data;
select * from hd1 ;
/* Q1: Standardize Date format*/
Alter table hd1 modify SaleDate Date;

/* Alternative method */
select SaleDate,convert(SaleDate,Date)
from hd1;

/* Change Y and N to Yes and No in "Sold as Vacant" field */

Select distinct (SoldAsVacant) , Count(SoldAsVacant)
from hd1
group by 1 
order by 2 ;

select SoldAsVacant ,Case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldasVacant 
end from hd1;

select * from hd1 ;



/* remove duplicates */

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 SalePrice,
				 LegalReference,
                 PropertyAddress,
				 SalePrice
				 ORDER BY
					UniqueID
					) row_num

From hd1

)
Select *
From RowNumCTE
Where row_num > 1;

/* Populate Property Adress Date */
Select  * from hd1
order by ParcelID ;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM hd1 a
JOIN hd1 b ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE hd1 a
JOIN hd1 b ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;


/* Breaking out Address into Individual Columns (Address, City, State) */

ALTER TABLE hd1
ADD COLUMN PropertySplitAddress NVARCHAR(255),
ADD COLUMN PropertySplitCity NVARCHAR(255);


UPDATE hd1
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1);
















