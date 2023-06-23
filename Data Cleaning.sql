/* 
Data Cleaning Project 
Skills Used: Populate Blank Columns, Remove Duplicates, Remove unused columns, JOINS, CTEs
*/

-- Select all the data

SELECT *
FROM datacleaning.NashvilleHousing;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Populate the blank cells of Property Address
 
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IF(a.PropertyAddress = '', b.PropertyAddress, a.PropertyAddress) AS UpdatedPropertyAddress
FROM datacleaning.NashvilleHousing a
JOIN datacleaning.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress = '';

UPDATE datacleaning.NashvilleHousing a
JOIN datacleaning.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IF(a.PropertyAddress = '', b.PropertyAddress, a.PropertyAddress)
WHERE a.PropertyAddress = '';

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Property Address into Address, City, State
SELECT PropertyAddress
FROM datacleaning.NashvilleHousing;


SELECT 
SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) AS Address
FROM datacleaning.NashvilleHousing;


ALTER TABLE datacleaning.NashvilleHousing
ADD PropertySplitAddress VARCHAR(255);


UPDATE datacleaning.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1)
WHERE PropertyAddress <> '';


ALTER TABLE datacleaning.NashvilleHousing
ADD PropertySplitCity VARCHAR(255);


UPDATE datacleaning.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1)
WHERE PropertyAddress <> '';



SELECT * 
FROM datacleaning.NashvilleHousing;


SELECT 
SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -3) AS OwnerSplitAddress,
SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -2) AS OwnerSplitCity,
SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -1) AS OwnerSplitState
FROM datacleaning.NashvilleHousing;



ALTER TABLE datacleaning.NashvilleHousing
ADD OwnerSplitAddress VARCHAR(255);


UPDATE datacleaning.NashvilleHousing
SET OwnerSplitAddress = SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -3)
WHERE OwnerAddress <> '';



ALTER TABLE datacleaning.NashvilleHousing
ADD OwnerSplitCity VARCHAR(255);


UPDATE datacleaning.NashvilleHousing
SET OwnerSplitCity = SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -2)
WHERE OwnerAddress <> '';



ALTER TABLE datacleaning.NashvilleHousing
ADD OwnerSplitState VARCHAR(255);


UPDATE datacleaning.NashvilleHousing
SET OwnerSplitState = SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.'), '.', -1)
WHERE OwnerAddress <> '';



SELECT * 
FROM datacleaning.NashvilleHousing;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No Repectively in "Sold as Vacant" column

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM datacleaning.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From datacleaning.nashvillehousing;


Update datacleaning.nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;
       
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From datacleaning.nashvillehousing
-- order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

Select *
From datacleaning.nashvillehousing;


-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

SELECT *
FROM datacleaning.nashvillehousing;

ALTER TABLE datacleaning.nashvillehousing
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;

SELECT *
FROM datacleaning.nashvillehousing;


